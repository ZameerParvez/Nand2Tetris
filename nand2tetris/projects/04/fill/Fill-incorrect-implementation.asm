// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.



  // loop over all 256*512 pixels
  // 32 consecutive words in a row (which is the 512), and there are 256 rows
  // so 32*256 addresses in the screen ram

  // This section could be replaced with a static allocation of the screenend size if I knew what it was
  @8192
  D=A // sets D=8192
  @SCREEN
  D=A+D // sets D=Screen+8192 to get the address of the end of the screen
  @screenend
  M=D // store the address for the screen end in m[screenend]

  // might only need counter for screen loop, e.g. i=8192
  // actually don't need counter

(CHECKKB)
  @KBD
  D=M // store keyboard input in D
  @DRAWW
  D;JEQ // if keyboard input is 0 then no key is pressed so draw white
  @DRAWB
  D;JNE // if keyboard input is not 0 then a key is pressed so draw black

(DRAWW)
  @0
  D=A // white is 0, so temporarily stores it in D
  @colour
  M=D // set m[colour] to white
  @DRAW
  0;JEQ // go on to draw the colour to the screen

(DRAWB)
  @1
  D=-A // black is -1 (or 1111 1111 1111 1111 in 16bit twos complement), so temporarily stores it in D
  @colour
  M=D // set m[colour] to black
  @DRAW
  0;JEQ // go on to draw the colour to the screen

//general draw loop, colour variable set elsewhere then this called
(DRAW)
  @SCREEN
  D=A
  @currentpos
  M=D // initialise m[currentpos]=SCREEN

(FILL)
  @colour
  D=M // store current colour in D

//  @currentpos
//  A=M // set current pointer to what currentpos is pointing to
//  M=D // set the colour at the memory location m[m[current]]
  
//  @currentpos
//  MD=M+1 // increment the currentpos pointer and also store the value in D

//  @screenend
//  D=D-M // see if currentpos pointer is the same as screenend
  
//  @FILL
//  D;JNE

//  @CHECKKB
//  0;JEQ
  
  @currentpos
  A=M // set current pointer to what currentpos is pointing to
  M=D // set the colour at the memory location m[m[current]]
  A=A+1
  M=D
  
  A=A+1 // 1
  M=D
  A=A+1 // 2
  M=D
  A=A+1 // 3
  M=D
  A=A+1 // 4
  M=D
  A=A+1 // 5
  M=D
  A=A+1 // 6
  M=D
  A=A+1 // 7
  M=D
  A=A+1 // 8
  M=D
  A=A+1 // 9
  M=D
  A=A+1 // 10
  M=D
  
  A=A+1 // 1
  M=D
  A=A+1 // 2
  M=D
  A=A+1 // 3
  M=D
  A=A+1 // 4
  M=D
  A=A+1 // 5
  M=D
  A=A+1 // 6
  M=D
  A=A+1 // 7
  M=D
  A=A+1 // 8
  M=D
  A=A+1 // 9
  M=D
  A=A+1 // 10
  M=D
  
  A=A+1 // 1
  M=D
  A=A+1 // 2
  M=D
  A=A+1 // 3
  M=D
  A=A+1 // 4
  M=D
  A=A+1 // 5
  M=D
  A=A+1 // 6
  M=D
  A=A+1 // 7
  M=D
  A=A+1 // 8
  M=D
  A=A+1 // 9
  M=D
  A=A+1 // 10
  M=D

  @32
  D=A
  @currentpos
  MD=M+D // increment the currentpos pointer and also store the value in D

  @screenend
  D=D-M // see if currentpos pointer is the same as screenend
  
  @FILL
  D;JNE

  @CHECKKB
  0;JEQ
