
.text

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

 .equ pushbuttons, 0x11010
 .equ switches, 0x11020
 .equ hex0, 0x11000

 .equ hex_0, 0x003F
 .equ hex_2, 0x005B
 .equ hex_3, 0x004F
 .equ hex_4, 0x0066
 .equ hex_5, 0x006D
 .equ hex_6, 0x007D
 .equ hex_7, 0x0007
 .equ hex_8, 0x007F
 .equ hex_9, 0x006F

 .global main

 main:
 	# use r12 for switch data, r13 for pushbutton data, r14 for hex0
	movia r2, switches
	movia r3, pushbuttons
	movia r4, hex0