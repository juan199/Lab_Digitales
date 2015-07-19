CC = gcc

c_program: LZW.c
	$(CC) -o LZW.exe LZW.c

reg: registers.v 
	iverilog -o Reg.test registers.v

compress: 
	iverilog registers.v buffers.v controlador.v testbench/compress_test.v -o compress.vvp
	vvp compress.vvp
