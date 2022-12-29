//function SimpleFunction.test 2

        (SimpleFunction.test)

        @SP
        D=M
        M=M+1
M=M+1


        A=D
        M=0
A=A+1
M=0
A=A+1

        
//push local 0

            
            @LCL
            D=M
            @0
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//push local 1

            
            @LCL
            D=M
            @1
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//add

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        
//not

        @SP
        A=M-1
        M=!M
        
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
            
//add

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        
//push argument 1

            
            @ARG
            D=M
            @1
            A=D+A
            D=M
            

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
        
//return

        @LCL
        A=M
        A=A-1
        A=A-1
        A=A-1
        A=A-1
        A=A-1
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
        //M=D+1 // TODO I think this is wrong, and it's actually supposed to write to the memory pointed to by arg

        @ARG
        D=M
        @SP
        M=D+1

        
        @LCL
        A=M
        A=A-1

        D=M
        @THAT
        M=D
        
        
        @LCL
        A=M
        A=A-1
A=A-1

        D=M
        @THIS
        M=D
        
        
        @LCL
        A=M
        A=A-1
A=A-1
A=A-1

        D=M
        @ARG
        M=D
        
        
        @LCL
        A=M
        A=A-1
A=A-1
A=A-1
A=A-1

        D=M
        @LCL
        M=D
        

        @15
        A=M
        0;JMP
        
