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

// current state is that it works a bit
// but if the first line is coloured black it doesn't fully return back to normal yet
// this is because if currentpos==SCREEN I don't draw white yet
// maybe need to reorder increment and decrement of current pos and when the stuff is actually drawn


  // loop over all 256*512 pixels
  // 32 consecutive words in a row (which is the 512), and there are 256 rows
  // so 32*256 addresses in the screen ram

  
  @24576
  D=A
  @screenend
  M=D
  @SCREEN
  D=A
  @currentpos // initialise a pointer to the screen area
  M=D


(CHECKKB)
  @KBD
  D=M // store keyboard input in D
  @DRAWW
  D;JEQ // if keyboard input is 0 then no key is pressed so draw white
  @DRAWB
  D;JNE // if keyboard input is not 0 then a key is pressed so draw black

(DRAWW)
  @currentpos
  D=M+1 // this is to make sure when currentpos==SCREEN the first word is drawn white
  @SCREEN
  D=D-A // see if currentpos pointer is the same as SCREEN
  @CHECKKB  // currentpos is already at the beginning of the screen so it should already be white, so loop early
  D;JEQ

  D=0 // store white in D

  @currentpos
  A=M // set current pointer to what currentpos is pointing to
  M=D // set the colour at the memory location m[m[current]]
  
  @currentpos
  MD=M-1 // decrement the currentpos pointer and also store the value in D

  @CHECKKB
  0;JEQ // check keyboard input for a change

(DRAWB)
  @currentpos
  D=M
  @screenend
  D=D-M // see if currentpos pointer is the same as m[screenend]
  @CHECKKB  // currentpos is already at the end of the screen so it should already be black, so loop early
  D;JEQ

  D=-1 // store black in D, black is -1 (or 1111 1111 1111 1111 in 16bit twos complement)

  @currentpos
  A=M // set current pointer to what currentpos is pointing to
  M=D // set the colour at the memory location m[m[current]]
  
  @currentpos
  MD=M+1 // increment the currentpos pointer and also store the value in D

  @CHECKKB
  0;JEQ // check keyboard input for a change
