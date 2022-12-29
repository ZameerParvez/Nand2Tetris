//function Sys.init 0

        (Sys.init)

        @SP
        D=M
        

        A=D
        
        
//push constant 4000

            
            @4000
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop pointer 0

            
            @THIS
            D=A
            @0
            A=D+A
            D=M
            

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
            
//push constant 5000

            
            @5000
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop pointer 1

            
            @THIS
            D=A
            @1
            A=D+A
            D=M
            

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
            
//call Sys.main 0

        @Sys.main.ReturnAddress
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
        

        @SP
        D=M-1
        D=D-1
        D=D-1
        D=D-1
        D=D-1
         

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @Sys.main
        0;JMP

        (Sys.main.ReturnAddress)

        
//pop temp 1

            
            @5
            D=A
            @1
            A=D+A
            D=M
            

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
            
//label LOOP
(LOOP)

//goto LOOP
@LOOP
0;JMP

//function Sys.main 5

        (Sys.main)

        @SP
        D=M
        M=M+1
M=M+1
M=M+1
M=M+1
M=M+1


        A=D
        M=0
A=A+1
M=0
A=A+1
M=0
A=A+1
M=0
A=A+1
M=0
A=A+1

        
//push constant 4001

            
            @4001
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop pointer 0

            
            @THIS
            D=A
            @0
            A=D+A
            D=M
            

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
            
//push constant 5001

            
            @5001
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop pointer 1

            
            @THIS
            D=A
            @1
            A=D+A
            D=M
            

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
            
//push constant 200

            
            @200
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop local 1

            
            @LCL
            D=M
            @1
            A=D+A
            D=M
            

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
            
//push constant 40

            
            @40
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop local 2

            
            @LCL
            D=M
            @2
            A=D+A
            D=M
            

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
            
//push constant 6

            
            @6
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop local 3

            
            @LCL
            D=M
            @3
            A=D+A
            D=M
            

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
            
//push constant 123

            
            @123
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//call Sys.add12 1

        @Sys.add12.ReturnAddress
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
        

        @SP
        D=M-1
        D=D-1
        D=D-1
        D=D-1
        D=D-1
        D=D-1
 

        @ARG
        M=D

        @SP
        D=M
        @LCL
        M=D

        @Sys.add12
        0;JMP

        (Sys.add12.ReturnAddress)

        
//pop temp 0

            
            @5
            D=A
            @0
            A=D+A
            D=M
            

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
            
//push local 2

            
            @LCL
            D=M
            @2
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//push local 3

            
            @LCL
            D=M
            @3
            A=D+A
            D=M
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//push local 4

            
            @LCL
            D=M
            @4
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
        
//add

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        
//add

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        
//add

        @SP
        M=M-1
        A=M
        D=M

        @SP
        A=M-1
        M=M+D
        
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
        
//function Sys.add12 0

        (Sys.add12)

        @SP
        D=M
        

        A=D
        
        
//push constant 4002

            
            @4002
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop pointer 0

            
            @THIS
            D=A
            @0
            A=D+A
            D=M
            

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
            
//push constant 5002

            
            @5002
            D=A
            

            @SP
            A=M
            M=D

            @SP
            M=M+1
            
//pop pointer 1

            
            @THIS
            D=A
            @1
            A=D+A
            D=M
            

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
            
//push constant 12

            
            @12
            D=A
            

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
        
