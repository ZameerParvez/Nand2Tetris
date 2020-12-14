// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// a faster multiplication algorithm?
// simple algo is to loop n times and add to D
// has a lot of loops there might be a better solution with log(n) multiplications
// bit shift and add seems like the way
// e.g. 4*5 -> 100_2 * 101_2 -> 100_2 * (100_2 + 001_2) -> 100_2*(4+1) -> (100_2 << 2) + (100_2<<0)

  @R2
  M=0 // initialise memory of m[R2]
  
  @R0
  D=M // loads first number into D
  D;JLE // jumps to end if D == 0

  @i // sets a loop counter at m[i]
  M=D 

(LOOP)
  @R1
  D=M // loads m[R1] into D
  
  @R2
  M=M+D // computes m[R2]=m[R2] + d

  @i
  MD=M-1 // sets D=M[i]=M[i-1]

  @END
  D;JLE // jumps to end if D == 0

  @LOOP
  0;JEQ

(END)
  @END
  0;JMP

