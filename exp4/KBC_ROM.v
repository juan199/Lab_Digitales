`timescale 1ns / 1ps
`include "Defintions.v"

`define WAITING 8'd0

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `BRANCH_IF_KB , `WAITING  ,16'd0  };
	
	
	default:
		oInstruction = { `LED ,  24'b0 };		//NOP
	endcase	
end
	
endmodule

