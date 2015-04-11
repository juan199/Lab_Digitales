`timescale 1ns / 1ps
`include "Defintions.v"

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)
	// op, dest, Src1, Src2;
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R1, 16'd8};
	2: oInstruction = { `STO , `R2, 16'd4};
	3: oInstruction = { `IMUL, `R3, `R1, `R2};
	default:
		oInstruction = { `LED ,  24'b10101010 };
	endcase	
end
	
endmodule