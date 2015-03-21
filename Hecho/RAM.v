`timescale 1ns / 1ps

module RAM_DUAL_READ_PORT # ( parameter DATA_WIDTH= 16, parameter ADDR_WIDTH=8, parameter MEM_SIZE=8 )
(
	input wire						Clock,
	input wire						iWriteEnable,
	input wire[ADDR_WIDTH-1:0]	iReadAddress0,
	input wire[ADDR_WIDTH-1:0]	iReadAddress1,
	input wire[ADDR_WIDTH-1:0]	iWriteAddress,
	input wire[DATA_WIDTH-1:0]		 	iDataIn,
	output reg [DATA_WIDTH-1:0] 		oDataOut0,
	output reg [DATA_WIDTH-1:0] 		oDataOut1
);

reg [DATA_WIDTH-1:0] Ram [MEM_SIZE:0];		

always @(posedge Clock) 
begin 
	
		if (iWriteEnable) 
			Ram[iWriteAddress] <= iDataIn; 
			
	
			oDataOut0 <= Ram[iReadAddress0]; 
			oDataOut1 <= Ram[iReadAddress1]; 
		
end 
endmodule

