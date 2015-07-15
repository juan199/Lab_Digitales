CC = gcc

c_program: LZW.c
	$(CC) -o LZW.exe LZW.c

reg: registers.v 
	iverilog -o Reg.test registers.v
