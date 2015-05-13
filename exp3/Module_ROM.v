`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	

`define LABEL_LOOP 8'd2
`define LABEL_LOOP1 8'd10
`define LABEL_CONTINUE 8'd5
`define LABEL_CONTINUE1 8'd8
`define LABEL_CONTINUE2 8'd13

always @ ( iAddress )
begin
	case (iAddress)

	
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R1,16'd64 };
//LABEL_LOOP:	
	2: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	3: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE  ,16'd0  }; 
	4:	oInstruction = { `JMP , `LABEL_LOOP  ,16'd0  }; 
		
//LABEL_CONTINUE		
	5: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	6: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE1  ,16'd0  };
	7:	oInstruction = { `JMP , `LABEL_CONTINUE  ,16'd0  };
	
//`LABEL_CONTINUE1
	8: oInstruction = { `STO , `R1,16'd50 }; 
	9: oInstruction = { `STO , `R1,16'd80 };
	
//LABEL_LOOP1:	
	10: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	11: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE2  ,16'd0  }; 
	12: oInstruction = { `JMP , `LABEL_LOOP1  ,16'd0  }; 

//CONTINUE2	
	13: oInstruction = { `STO , `R1,16'd100 }; 
	default:
		oInstruction = { `LED ,  24'b10101010 };	//NOP
	endcase	
end
	
endmodule
