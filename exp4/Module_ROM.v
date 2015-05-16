`timescale 1ns / 1ps
`include "Defintions.v"

`define S_ADD 8'd222

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R1,16'd15 };
	2: oInstruction = { `STO , `R2,16'd500 };
	3: oInstruction = { `CALL , `S_ADD ,16'd0 };
	4: oInstruction = { `STO , `R3,16'd95 };
	5: oInstruction = { `NOP ,24'd4000    };
	6: oInstruction = { `SUB , `R4, `R3,`R1 };
	
// subrutina	
	222: oInstruction = { `ADD , `R7, `R1,`R2 };
	223: oInstruction = { `RET , 24'd00 };

	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
