import os
import sys
import enum
import re

compDict = {
    "0":    "0101010",
    "1":    "0111111",
    "-1":   "0111010",
    "D":    "0001100",
    "A":    "0110000",
    "M":    "1110000",
    "!D":   "0001101",
    "!A":   "0110000",
    "!M":   "1110001",
    "-D":   "0001111",
    "-A":   "0110011",
    "-M":   "1110011",
    "D+1":  "0011111",
    "A+1":  "0110111",
    "M+1":  "1110111",
    "D-1":  "0001110",
    "A-1":  "0110010",
    "M-1":  "1110010",
    "D+A":  "0000010",
    "D+M":  "1000010",
    "D-A":  "0010011",
    "D-M":  "1010011",
    "A-D":  "0000111",
    "M-D":  "1000111",
    "D&A":  "0000000",
    "D&M":  "1000000",
    "D|A":  "0010101",
    "D|M":  "1010101"
}

destDict = {
    "":     "000",
    "null": "000",
    "M":    "001",
    "D":    "010",
    "DM":   "011",
    "MD":   "011",
    "A":    "100",
    "AM":   "101",
    "MA":   "101",
    "AD":   "110",
    "DA":   "110",
    "ADM":  "111",
}

jumpDict = {
    "":     "000",
    "null": "000",
    "JGT":  "001",
    "JEQ":  "010",
    "JGE":  "011",
    "JLT":  "100",
    "JNE":  "101",
    "JLE":  "110",
    "JMP":  "111",
}

symbolTable = {
    "R0": 0,
    "R1": 1,
    "R2": 2,
    "R3": 3,
    "R4": 4,
    "R5": 5,
    "R6": 6,
    "R7": 7,
    "R8": 8,
    "R9": 9,
    "R10": 10,
    "R11": 11,
    "R12": 12,
    "R13": 13,
    "R14": 14,
    "R15": 15,
    "SP": 0,
    "LCL": 1,
    "ARG": 2,
    "THIS": 3,
    "THAT": 4,
    "SCREEN": 16384,
    "KBD": 24576
}

reDest = "(null|ADM|[AD]M|M[AD]|AD|[MDA])"
reJump = "(null|J(GT|GE|LT|LE|EQ|NE|MP))"
reComp = "(([DAM][+-]1)|(D[+&|\-][AM])|([AM]-D)|([-!]?[DAM])|([-]?[01]))"

# regex patterns for A, C and L instructions
# for c instructions can retrieve from group indicies if there is a match; dest=2, comp=3, jump=11
reCInst = f"^({reDest}=)?({reComp})(;{reJump})?$"
reAInst = "^@([0-9]+|.+)$"
reLInst = "^\((.+)\)$"

# largest value for a 15 bit unsigned integer
maxval = (1<<16) - 1

class Code:
    def dest(cInst):
        return destDict[cInst]

    def comp(cInst):
        return compDict[cInst]

    def jump(cInst):
        return jumpDict[cInst]

class InstructionType(enum.Enum):
    A = 1
    C = 2
    L = 3

class ParserModule:
    # == member variables ==
    # file
    # eof
    # currInstruction
    # currLineNum
    # currInstructionMatch
    # currInstructionType
    # currInstructionCount, only for A and C instructions
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
            self.currInstructionType = None
            self.currInstructionCount = 0
            self.failed = False
        except (OSError, IOError) as e:
            print(e)
            raise e

    def __del__(self):
        self.file.close()
    
    def reset(self):
        self.currLineNum = 0
        self.file.seek(0)
        self.currInstruction = ""
        self.currInstructionType = None
        self.currInstructionMatch = None
        self.currInstructionCount = 0
        self.failed = False

    def hasMoreLines(self):
        return (self.currLineNum < self.eofLine)

    def advance(self):
        while self.hasMoreLines():
            self.currLineNum += 1
            currLine = self.file.readline().split("//", 1)[0].strip()
            if currLine != "":
                self.currInstruction = currLine
                self.instructionType()
                return True
        return False

    def instructionType(self):
        aInstMatch = re.match(reAInst, self.currInstruction)
        if aInstMatch:
            self.currInstructionType = InstructionType.A
            self.currInstructionMatch = aInstMatch
            self.currInstructionCount += 1
            return InstructionType.A

        lInstMatch = re.match(reLInst, self.currInstruction)
        if lInstMatch:
            self.currInstructionType = InstructionType.L
            self.currInstructionMatch = lInstMatch
            return InstructionType.L

        cInstMatch = re.match(reCInst, self.currInstruction)
        if cInstMatch:
            self.currInstructionType = InstructionType.C
            self.currInstructionMatch = cInstMatch
            self.currInstructionCount += 1
            return InstructionType.C

        print(f"No matching instruction type for Line {self.currLineNum}: \"{self.currInstruction}\"")
        self.currInstructionType = None
        self.currInstructionMatch = None
        self.failed = True
        return None

    def symbol(self):
        if self.currInstructionType is InstructionType.A or self.currInstructionType is InstructionType.L:
            return self.currInstructionMatch.group(1)
        print(f"This is not an A or L instruction, Line {self.currLineNum}: \"{self.currInstruction}\"")
        self.failed = True

    def dest(self):
        if self.currInstructionType is InstructionType.C:
            if self.currInstructionMatch.group(2) is None:
                return "null"
            return self.currInstructionMatch.group(2)
        print(f"This is not a C instruction, Line {self.currLineNum}: \"{self.currInstruction}\"")
        self.failed = True

    def comp(self):
        if self.currInstructionType is InstructionType.C:
            return self.currInstructionMatch.group(3)
        print(f"This is not a C instruction, Line {self.currLineNum}: \"{self.currInstruction}\"")
        self.failed = True

    def jump(self):
        if self.currInstructionType is InstructionType.C:
            if self.currInstructionMatch.group(11) is None:
                return "null"
            return self.currInstructionMatch.group(11)
        print(f"This is not a C instruction, Line {self.currLineNum}: \"{self.currInstruction}\"")
        self.failed = True

# Builds the initial symbol table from the defined labels in the source
def buildSymbolTable(parser):
    while parser.advance():
        if parser.failed: continue
        if parser.currInstructionType == InstructionType.L:
            symbol = parser.symbol()
            if symbol in symbolTable:
                # shouldn't overrwrite but print as a parsing error and fail after checking all labels
                print(f"This symbol is already defined, Line {parser.currLineNum}: \"{parser.currInstruction}\"")
                parser.failed = True
            else:
                symbolTable[symbol] = parser.currInstructionCount
    
    if (parser.failed):
        raise Exception("Failed to parse symbols")
    else:
        parser.reset()

def assemble(inSrc, outSrc):
    parser = ParserModule(inSrc)
    buildSymbolTable(parser)
    variableSymbolIdx = 16
    with open(outSrc, "w") as newfile:
        while parser.advance():
            if parser.failed: continue
            if parser.currInstructionType == InstructionType.A:
                symbol = parser.symbol()
                if re.match("[0-9]+", symbol):
                    # case for loading constants
                    newfile.write(f"0{max(0, min(int(symbol), maxval)):015b}\n")
                else:
                    if symbol in symbolTable:
                        # case for symbols defined by labels, or that have been added to the symbol table before
                        newfile.write(f"0{symbolTable[symbol]:015b}\n")
                    else:
                        # case for variable symbols
                        symbolTable[symbol] = variableSymbolIdx
                        newfile.write(f"0{variableSymbolIdx:015b}\n")
                        variableSymbolIdx += 1
            if parser.currInstructionType == InstructionType.C:
                newfile.write(f"111{Code.comp(parser.comp())}{Code.dest(parser.dest())}{Code.jump(parser.jump())}\n")

        del parser

n = len(sys.argv)
if (n != 2):
    print("needs an input file name. e.g. if file is prog.asm, give prog")
    exit()

assemble(f"{sys.argv[1]}", f"{os.path.splitext(sys.argv[1])[0]}.hack")

# def testCInstructionRegexAndCode():
#     cInstructionTests = [
#         "D=A",
#         "AM=M+1",
#         "D=D+A",
#         "M=D",
#         "D",
#         "D",
#         "M",
#         "0;JMP",
#         "D;JNE",
#         "ADM=D&A;JEQ",
#         "M=!M"
#     ]

#     print(reCInst)

#     for test in cInstructionTests:
#         temp = re.search(reCInst, test)
#         if temp:
#             result = ""
#             if temp.group(2):
#                 result += temp.group(2) + "="
#             result += temp.group(3)
#             if temp.group(11):
#                 result += ";" + temp.group(11)
#             print(f"{result}\t\t{temp.groups()} 111{Code.comp(temp.group(3))}{Code.dest(temp.group(2) if temp.group(2) else '')}{Code.jump(temp.group(11) if temp.group(11) else '')}")


# testCInstructionRegexAndCode()

