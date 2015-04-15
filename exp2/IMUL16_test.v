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

	0: oInstruction = { `NOP ,24'd4009    };
	1: oInstruction = { `STO ,`R1,16'd125};
	2: oInstruction = { `STO ,`R2,16'd110};
	3: oInstruction = { `NOP ,24'd4009    };
	4: oInstruction = { `IMUL16 ,`R4,`R2,`R1 };
	5: oInstruction = { `NOP ,24'd4009    };
	6: oInstruction = { `LED ,8'b0,`R4,8'b0 };

	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule