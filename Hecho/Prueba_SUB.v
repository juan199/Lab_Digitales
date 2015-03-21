`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4009    };
	1: oInstruction = { `STO , `R7,16'b0001 };
	2: oInstruction = { `STO ,`R3,16'h1     }; 
	3: oInstruction = { `STO, `R4,16'd1}; //linea de primer retardo
	4: oInstruction = { `STO, `R5,16'd0     };  
	

//LOOP2: **** Doble lazo de retardo *****
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 }; // imprime en los LEDs
	6: oInstruction = { `STO ,`R1,16'h0     }; 	
	7: oInstruction = { `STO ,`R2,16'd1 }; //segundo retardo


//LOOP1: **** Primer lazo de retardo *****
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; // R1++
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; // Salta a la direccion 8 y especifica el tiempo
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    }; // R5++
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `SUB ,`R7,`R7,`R3    }; //R7++
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
