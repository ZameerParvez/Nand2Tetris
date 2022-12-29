@256
D=A
@SP
M=D

        @Sys.init.ReturnAddress.0
        D=A
        @SP
        M=M+1
        A=M-1
        M=D
        
        @LCL
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @ARG
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THIS
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THAT
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        

        @5
        D=A
        @SP
        D=M-D
        @0
        D=D-A

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @Sys.init
        0;JMP

        (Sys.init.ReturnAddress.0)

        
//function Main.fibonacci 0

        (Main.fibonacci)

        @SP
        D=M
        @13
        M=D

        @0
        D=A
        @SP
        M=M+D

        @13
        A=M
        
        //push argument 0

            
            @ARG
            D=M
            @0
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //push constant 2

            
            @2
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //lt

        @SP
        M=M-1
        A=M
        D=M

        @SP
        M=M-1
        A=M

        D=M-D
        @LessThan.Main.14
        D;JLT
        @SP
        A=M
        M=0
        @END.Main.14
        0;JMP
        (LessThan.Main.14)
        @SP
        A=M
        M=-1
        (END.Main.14)
        
        @SP
        M=M+1
        //if-goto IF_TRUE

        @SP
        M=M-1
        A=M
        D=M
        @IF_TRUE
        D;JNE
        //goto IF_FALSE
@IF_FALSE
0;JMP
//label IF_TRUE
(IF_TRUE)
//push argument 0

            
            @ARG
            D=M
            @0
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //return

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

        
        @1
        D=A
        @LCL
        A=M-D
        D=M
        @THAT
        M=D
        
        
        @2
        D=A
        @LCL
        A=M-D
        D=M
        @THIS
        M=D
        
        
        @3
        D=A
        @LCL
        A=M-D
        D=M
        @ARG
        M=D
        
        
        @4
        D=A
        @LCL
        A=M-D
        D=M
        @LCL
        M=D
        

        @15
        A=M
        0;JMP
        //label IF_FALSE
(IF_FALSE)
//push argument 0

            
            @ARG
            D=M
            @0
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //push constant 2

            
            @2
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //sub

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M-D
        //call Main.fibonacci 1

        @Main.fibonacci.ReturnAddress.24
        D=A
        @SP
        M=M+1
        A=M-1
        M=D
        
        @LCL
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @ARG
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THIS
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THAT
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        

        @5
        D=A
        @SP
        D=M-D
        @1
        D=D-A

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @Main.fibonacci
        0;JMP

        (Main.fibonacci.ReturnAddress.24)

        //push argument 0

            
            @ARG
            D=M
            @0
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //push constant 1

            
            @1
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //sub

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M-D
        //call Main.fibonacci 1

        @Main.fibonacci.ReturnAddress.28
        D=A
        @SP
        M=M+1
        A=M-1
        M=D
        
        @LCL
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @ARG
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THIS
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THAT
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        

        @5
        D=A
        @SP
        D=M-D
        @1
        D=D-A

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @Main.fibonacci
        0;JMP

        (Main.fibonacci.ReturnAddress.28)

        //add

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        //return

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

        
        @1
        D=A
        @LCL
        A=M-D
        D=M
        @THAT
        M=D
        
        
        @2
        D=A
        @LCL
        A=M-D
        D=M
        @THIS
        M=D
        
        
        @3
        D=A
        @LCL
        A=M-D
        D=M
        @ARG
        M=D
        
        
        @4
        D=A
        @LCL
        A=M-D
        D=M
        @LCL
        M=D
        

        @15
        A=M
        0;JMP
        //function Sys.init 0

        (Sys.init)

        @SP
        D=M
        @13
        M=D

        @0
        D=A
        @SP
        M=M+D

        @13
        A=M
        
        //push constant 4

            
            @4
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            //call Main.fibonacci 1

        @Main.fibonacci.ReturnAddress.13
        D=A
        @SP
        M=M+1
        A=M-1
        M=D
        
        @LCL
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @ARG
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THIS
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        
        
        @THAT
        D=M
        @SP
        M=M+1
        A=M-1
        M=D
        

        @5
        D=A
        @SP
        D=M-D
        @1
        D=D-A

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @Main.fibonacci
        0;JMP

        (Main.fibonacci.ReturnAddress.13)

        //label WHILE
(WHILE)
//goto WHILE
@WHILE
0;JMP
