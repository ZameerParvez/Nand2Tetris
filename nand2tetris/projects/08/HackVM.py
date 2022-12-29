import os
import sys
import enum
import re

reSegment = "argument|local|static|constant|this|that|pointer|temp"
reArithmeticLogic = "add|sub|neg|eq|gt|lt|and|or|not"

reArithmeticCommand = f"^({reArithmeticLogic})$"
rePushCommand = f"^push\s+({reSegment})\s+([0-9]+)$"
rePopCommand = f"^pop\s+({reSegment})\s+([0-9]+)$"
reLabelCommand = f"^label\s+(.*)$"
reGotoLabelCommand = f"^goto\s+(.*)$"
reIfGotoLabelCommand = f"^if-goto\s+(.*)$"
reFunctionCommand = f"^function\s+(.*)\s+([0-9]+)$"
reReturnCommand = f"^return$"
reCallCommand = f"^call\s+(.*)\s+([0-9]+)$"

arithmeticDict = {
    "add": 
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        """,
    "sub":
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M-D
        """,
    "neg":
        """
        @SP
        A=M-1
        M=-M
        """,
    "eq":
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        M=M-1
        A=M

        D=M-D
        @Equal{0}
        D;JEQ
        @SP
        A=M
        M=0
        @END{0}
        0;JMP
        (Equal{0})
        @SP
        A=M
        M=-1
        (END{0})
        
        @SP
        M=M+1
        """,
    "gt": # might be broken
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        M=M-1
        A=M

        D=M-D
        @GreaterThan{0}
        D;JGT
        @SP
        A=M
        M=0
        @END{0}
        0;JMP
        (GreaterThan{0})
        @SP
        A=M
        M=-1
        (END{0})
        
        @SP
        M=M+1
        """,
    "lt":
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        M=M-1
        A=M

        D=M-D
        @LessThan{0}
        D;JLT
        @SP
        A=M
        M=0
        @END{0}
        0;JMP
        (LessThan{0})
        @SP
        A=M
        M=-1
        (END{0})
        
        @SP
        M=M+1
        """,
    "and":
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M&D
        """,
    "or":
        """
        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M|D
        """,
    "not":
        """
        @SP
        A=M-1
        M=!M
        """
}

segmentDict = {
    "stack": "SP", # this is a pointer to the global stack
    "argument": "ARG", # this is a pointer to the argument segment
    "local": "LCL", # this is a pointer to the local segment
    # "static":  "", # is from 16-25 and should have labelled names in the generated assembly (e.g. FOO.1 for the first static variable in FOO.vm)
    # "constant":  "", # isn't a segment, is just used to get/set a value directly
    "this":  "THIS", # a pointer
    "that":  "THAT", # a pointer
    "pointer": "THIS", # directly in RAM[3] and RAM[4] (which are the THIS and THAT pointers) push pointers 1 should push the value of THAT into the stack
    "temp":  "5" # the beginning of the pointer segment
}

class Code:
    def __init__(self, filename = ""):
        self.filename = filename
    
    def setFileName(self, newfilename):
        self.filename = newfilename
    
    def bootstrap(self):
        return "@256\nD=A\n@SP\nM=D\n{}\n".format(self.call("Sys.init", 0, 0))
    
    def arithmetic(self, arithmeticCommand, instructionNumber):
        # assumes that the stack will be atleast 2 sized for binary operators
        return arithmeticDict[arithmeticCommand].format(f".{self.filename}.{instructionNumber}")
    
    # TODO could error if cType or segment doesn't exist
    def pushpop(self, cType, segment, index):
        loadingvalue = ""
        if (segment == "constant"):
            loadingvalue = f"""
            @{index}
            D=A
            """
            # TODO add a check to make sure it isn't a pop instruction (which doesn't make sense)
        elif (segment == "static"):
            loadingvalue = f"""
            @{self.filename}.{index}
            D=M
            """  
        elif (segment == "temp" or segment == "pointer"):
            loadingvalue = f"""
            @{segmentDict[segment]}
            D=A
            @{index}
            A=D+A
            D=M
            """           
        elif (segment in segmentDict):
            loadingvalue = f"""
            @{segmentDict[segment]}
            D=M
            @{index}
            A=D+A
            D=M
            """

        temp = ""
        if cType is CommandType.C_PUSH:
            # read whatever is given by segment-index pair (could be value or pointer)
            # increment stack pointer (at RAM[0])
            # write that to the stack
            
            # At this point D should have the address of whatever is being pointed to, or the data itself
            temp = f"""
            {loadingvalue}

            @SP
            A=M
            M=D

            @SP
            M=M+1
            """
        elif cType is CommandType.C_POP:
            # get the data from the stack pointer
            # decrement the stack pointe
            # find the address of where to write too
            # write the data that was taken from the stack to the address
            
            # At this point A should always be an adress
            temp = f"""
            {loadingvalue}

            D=A
            @R13
            M=D

            @SP
            M=M-1
            A=M
            D=M
            
            @R13
            A=M
            M=D
            """
        
        return temp

    # TODO unique labels might prevent some bugs here
    def label(self, labelname):
        return f"({labelname})\n"

    def goto(self, labelname):
        return f"@{labelname}\n0;JMP\n"
        
    def ifgoto(self, labelname):
        return f"""
        @SP
        M=M-1
        A=M
        D=M
        @{labelname}
        D;JNE
        """

    def function(self, name, nvars):
        n = int(nvars)
        zeroVars = "M=0\nA=A+1\n"*n
        functioncode = f"""
        {self.label(name)}
        @SP
        D=M
        @13
        M=D

        @{nvars}
        D=A
        @SP
        M=M+D

        @13
        A=M
        {zeroVars}
        """

        return functioncode

    def call(self, name, nvars, sourcelinenum):
        pushRegister = """
        @{0}
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        """

        callcode = f"""
        @{name}.ReturnAddress.{sourcelinenum}
        D=A
        @SP
        M=M+1
        A=M-1
        M=D
        {pushRegister.format("LCL")}
        {pushRegister.format("ARG")}
        {pushRegister.format("THIS")}
        {pushRegister.format("THAT")}

        @5
        D=A
        @SP
        D=M-D
        @{nvars}
        D=D-A

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @{name}
        0;JMP

        {self.label(f"{name}.ReturnAddress.{sourcelinenum}")}
        """

        return callcode

    def returncall(self):
        restoreRegister = lambda register, offset : """
        @{0}
        D=A
        @LCL
        A=M-D
        D=M
        @{1}
        M=D
        """.format(offset, register)
 
        returncode = f"""
        @5
        D=A
        @LCL
        A=M-D
        D=M
        @15
        M=D

        @SP
        M=M-1
        A=M
        D=M
        @ARG
        A=M
        M=D

        @ARG
        D=M
        @SP
        M=D+1

        {restoreRegister("THAT", 1)}
        {restoreRegister("THIS", 2)}
        {restoreRegister("ARG", 3)}
        {restoreRegister("LCL", 4)}

        @15
        A=M
        0;JMP
        """
        return returncode

class CommandType(enum.Enum):
    C_ARITHMETIC = 1
    C_PUSH = 2
    C_POP = 3
    C_LABEL = 4
    C_GOTO = 5
    C_IF = 6
    C_FUNCTION = 7
    C_RETURN = 8
    C_CALL = 9

class Parser:
    # == member variables ==
    # file
    # eof
    # currCommand
    # currLineNum
    # currCommandMatch
    # currCommandType
    # failed, this is used to skip outputting if the parsing has already failed, but I still want errors to be printed

    def __init__(self, fileToRead):
        try:
            self.file = open(fileToRead, "r")
            pos = self.file.tell()

            # this should find the end of the file, so I can cache it's position and check against it for the hasMoreLines function
            self.eofLine = 0
            while (self.file.readline()):
                self.eofLine += 1
            
            self.currLineNum = 0
            self.file.seek(pos)
            self.currCommandType = None
            self.failed = False
        except (OSError, IOError) as e:
            print(e)
            raise e

    def __del__(self):
        self.file.close()
    
    def reset(self):
        self.currLineNum = 0
        self.file.seek(0)
        self.currCommand = ""
        self.currCommandType = None
        self.currCommandMatch = None
        self.failed = False

    def hasMoreLines(self):
        return (self.currLineNum < self.eofLine)

    def advance(self):
        while self.hasMoreLines():
            self.currLineNum += 1
            currLine = self.file.readline().split("//", 1)[0].strip()
            if currLine != "":
                self.currCommand = currLine
                self.commandType()
                return True
        return False

    def error(self, message):
        print(f"{message}. Line {self.currLineNum}: \"{self.currCommand}\"")
        self.failed = True

    def commandType(self):
        commandMatch = re.match(reArithmeticCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_ARITHMETIC
            self.currCommandMatch = commandMatch
            return CommandType.C_ARITHMETIC

        commandMatch = re.match(rePushCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_PUSH
            self.currCommandMatch = commandMatch
            return CommandType.C_PUSH

        commandMatch = re.match(rePopCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_POP
            self.currCommandMatch = commandMatch
            return CommandType.C_POP

        commandMatch = re.match(reLabelCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_LABEL
            self.currCommandMatch = commandMatch
            return CommandType.C_LABEL

        commandMatch = re.match(reGotoLabelCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_GOTO
            self.currCommandMatch = commandMatch
            return CommandType.C_GOTO

        commandMatch = re.match(reIfGotoLabelCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_IF
            self.currCommandMatch = commandMatch
            return CommandType.C_IF

        commandMatch = re.match(reFunctionCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_FUNCTION
            self.currCommandMatch = commandMatch
            return CommandType.C_FUNCTION

        commandMatch = re.match(reReturnCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_RETURN
            self.currCommandMatch = commandMatch
            return CommandType.C_RETURN

        commandMatch = re.match(reCallCommand, self.currCommand)
        if commandMatch:
            self.currCommandType = CommandType.C_CALL
            self.currCommandMatch = commandMatch
            return CommandType.C_CALL

        self.error("No matching command type. Make sure the command, and arguments are correct")
        self.currCommandType = None
        self.currCommandMatch = None
        return None

    def arg1(self):
        if self.currCommandType in {
            CommandType.C_PUSH,
            CommandType.C_POP,
            CommandType.C_ARITHMETIC,
            CommandType.C_LABEL,
            CommandType.C_GOTO,
            CommandType.C_IF,
            CommandType.C_FUNCTION,
            CommandType.C_CALL
            }:
            return self.currCommandMatch.group(1)
        elif self.currCommandType is None:
            self.error("This is not a valid command, so can't retrieve its arguments")
            return None
        else:
            self.error("No matching argument for this command")
            return None

    def arg2(self):
        if self.currCommandType in {
            CommandType.C_PUSH,
            CommandType.C_POP,
            CommandType.C_FUNCTION,
            CommandType.C_CALL
            }:
            return self.currCommandMatch.group(2)
        elif self.currCommandType is None:
            self.error("This is not a valid command, so can't retrieve its arguments")
            return None
        else:
            self.error("No matching argument for this command")
            return None

def fileToVM(inSrc, outSrc, codeGenerator):
    parser = Parser(inSrc)
    with open(outSrc, "a") as newfile:
        while parser.advance():
            if parser.failed: continue
            newfile.write(f"//{parser.currCommand}\n") # NOTE debug
            if parser.currCommandType in {CommandType.C_PUSH, CommandType.C_POP}:
                newfile.write(f"{codeGenerator.pushpop(parser.currCommandType, parser.arg1(), parser.arg2())}")
            elif parser.currCommandType is CommandType.C_ARITHMETIC:
                newfile.write(f"{codeGenerator.arithmetic(parser.arg1(), parser.currLineNum)}")
            elif parser.currCommandType is CommandType.C_LABEL:
                newfile.write(f"{codeGenerator.label(parser.arg1())}")
            elif parser.currCommandType is CommandType.C_GOTO:
                newfile.write(f"{codeGenerator.goto(parser.arg1())}")
            elif parser.currCommandType is CommandType.C_IF:
                newfile.write(f"{codeGenerator.ifgoto(parser.arg1())}")
            elif parser.currCommandType is CommandType.C_FUNCTION:
                newfile.write(f"{codeGenerator.function(parser.arg1(), parser.arg2())}")
            elif parser.currCommandType is CommandType.C_RETURN:
                newfile.write(f"{codeGenerator.returncall()}")
            elif parser.currCommandType is CommandType.C_CALL:
                newfile.write(f"{codeGenerator.call(parser.arg1(), parser.arg2(), parser.currLineNum)}")
        del parser

def toVM(inSrc):
    if os.path.isfile(inSrc):
        file = os.path.splitext(inSrc)[0]
        codeGenerator = Code(os.path.basename(file))
        outSrc = f"{file}.asm"
        with open(outSrc, "w") as newfile:
            newfile.write("")
        fileToVM(inSrc, outSrc, codeGenerator)
    elif os.path.isdir(inSrc):
        codeGenerator = Code("")
        outSrc = f"{inSrc}/{os.path.basename(inSrc)}.asm"
        with open(outSrc, "w") as newfile:
            newfile.write(f"{codeGenerator.bootstrap()}")
        files = os.listdir(inSrc)
        files = [os.path.splitext(f)[0] for f in files if os.path.isfile(f"{inSrc}/{f}") and f.endswith(".vm")]
        for f in files:
            codeGenerator.setFileName(f)
            fileToVM(f"{inSrc}/{f}.vm", outSrc, codeGenerator)

n = len(sys.argv)
if (n != 2):
    print("Expects an argument. Either a directory or '.vm' file.")
    exit()

toVM(sys.argv[1])