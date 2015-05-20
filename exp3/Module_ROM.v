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
`define LABEL_LOOP1 8'd9
`define LABEL_LOOP2 8'd16
`define LABEL_LOOP3 8'd23
`define LABEL_LOOP4 8'd30
`define LABEL_LOOP5 8'd37
`define LABEL_LOOP6 8'd44
`define LABEL_LOOP7 8'd51
`define LABEL_LOOP8 8'd58
`define LABEL_LOOP9 8'd65
`define LABEL_LOOP10 8'd72

`define LABEL_CONTINUE 8'd5
`define LABEL_CONTINUE1 8'd8
`define LABEL_CONTINUE2 8'd12

`define LABEL_CONTINUE3 8'd15
`define LABEL_CONTINUE4 8'd19
`define LABEL_CONTINUE5 8'd22

`define LABEL_CONTINUE6 8'd26
`define LABEL_CONTINUE7 8'd29
`define LABEL_CONTINUE8 8'd33

`define LABEL_CONTINUE9 8'd36
`define LABEL_CONTINUE10 8'd40
`define LABEL_CONTINUE11 8'd43

`define LABEL_CONTINUE12 8'd47
`define LABEL_CONTINUE13 8'd50
`define LABEL_CONTINUE14 8'd54

`define LABEL_CONTINUE15 8'd57
`define LABEL_CONTINUE16 8'd61
`define LABEL_CONTINUE17 8'd64

`define LABEL_CONTINUE18 8'd68
`define LABEL_CONTINUE19 8'd71
`define LABEL_CONTINUE20 8'd75

`define LABEL_CONTINUE21 8'd78

always @ ( iAddress )
begin
	case (iAddress)

	
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R1,16'd72 };//carga H
//LABEL_LOOP:	
	2: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	3: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE  ,16'd0  }; 
	4:	oInstruction = { `JMP , `LABEL_LOOP  ,16'd0  }; 
		
//LABEL_CONTINUE		
	5: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	6: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE1  ,16'd0  };
	7:	oInstruction = { `JMP , `LABEL_CONTINUE  ,16'd0  };
	
	
	
//`LABEL_CONTINUE1
	8: oInstruction = { `STO , `R1,16'd101 };//carga E
//LABEL_LOOP1:	
	9: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	10: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE2  ,16'd0  }; 
	11: oInstruction = { `JMP , `LABEL_LOOP1  ,16'd0  }; 
	
//`LABEL_CONTINUE2	
	12: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	13: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE3  ,16'd0  };
	14:oInstruction = { `JMP , `LABEL_CONTINUE2  ,16'd0  };



//`LABEL_CONTINUE3	
	15: oInstruction = { `STO , `R1,16'd108 };//carga L
//LABEL_LOOP2:	
	16: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	17: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE4  ,16'd0  }; 
	18: oInstruction = { `JMP , `LABEL_LOOP2  ,16'd0  }; 
	
//`LABEL_CONTINUE4	
	19: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	20: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE5  ,16'd0  };
	21:	oInstruction = { `JMP , `LABEL_CONTINUE4  ,16'd0  };
	
	
	
	
//`LABEL_CONTINUE5		
	22: oInstruction = { `STO , `R1,16'd108 };//carga L
//LABEL_LOOP3:	
	23: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	24: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE6  ,16'd0  }; 
	25: oInstruction = { `JMP , `LABEL_LOOP3  ,16'd0  }; 
	
//`LABEL_CONTINUE6	
	26: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	27: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE7  ,16'd0  };
	28: oInstruction = { `JMP , `LABEL_CONTINUE6  ,16'd0  };
	
	
	
	
//`LABEL_CONTINUE7		
	29: oInstruction = { `STO , `R1,16'd111 };//carga O
//LABEL_LOOP4:	
	30: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	31: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE8  ,16'd0  }; 
	32: oInstruction = { `JMP , `LABEL_LOOP4  ,16'd0  }; 
	
//`LABEL_CONTINUE8	
	33: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	34: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE9  ,16'd0  }; 
	35: oInstruction = { `JMP , `LABEL_CONTINUE8  ,16'd0  };
	


//`LABEL_CONTINUE9		
	36: oInstruction = { `STO , `R1,16'd32 };//carga space
//LABEL_LOOP5:	
	37: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	38: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE10  ,16'd0  }; 
	39: oInstruction = { `JMP , `LABEL_LOOP5  ,16'd0  }; 
	
//`LABEL_CONTINUE10	
	40: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	41: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE11  ,16'd0  };
	42: oInstruction = { `JMP , `LABEL_CONTINUE10  ,16'd0  };


//`LABEL_CONTINUE11		
	43: oInstruction = { `STO , `R1,16'd119 };//carga W
//LABEL_LOOP6:	
	44: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	45: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE12  ,16'd0  }; 
	46: oInstruction = { `JMP , `LABEL_LOOP6  ,16'd0  }; 
	
//`LABEL_CONTINUE12	
	47: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	48: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE13  ,16'd0  };
	49: oInstruction = { `JMP , `LABEL_CONTINUE12  ,16'd0  };
	
	


//`LABEL_CONTINUE13		
	50: oInstruction = { `STO , `R1,16'd111 };//carga O
//LABEL_LOOP7:	
	51: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	52: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE14  ,16'd0  }; 
	53: oInstruction = { `JMP , `LABEL_LOOP7  ,16'd0  }; 
	
//`LABEL_CONTINUE14	
	54: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	55: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE15  ,16'd0  };
	56: oInstruction = { `JMP , `LABEL_CONTINUE14  ,16'd0  };




//`LABEL_CONTINUE15		
	57: oInstruction = { `STO , `R1,16'd111 };//carga R
//LABEL_LOOP8:	
	58: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	59: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE16  ,16'd0  }; 
	60: oInstruction = { `JMP , `LABEL_LOOP8  ,16'd0  }; 
	
//`LABEL_CONTINUE16	
	61: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	62: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE17  ,16'd0  };
	63: oInstruction = { `JMP , `LABEL_CONTINUE16  ,16'd0  };
	
	
	
//`LABEL_CONTINUE17		
	64: oInstruction = { `STO , `R1,16'd108 };//carga L
//LABEL_LOOP9:	
	65: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	66: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE18  ,16'd0  }; 
	67: oInstruction = { `JMP , `LABEL_LOOP9  ,16'd0  }; 
	
//`LABEL_CONTINUE18	
	68: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	69: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE19  ,16'd0  };
	70: oInstruction = { `JMP , `LABEL_CONTINUE18  ,16'd0  };
	

//`LABEL_CONTINUE19		
	71: oInstruction = { `STO , `R1,16'd100 };//carga D
//LABEL_LOOP10:	
	72: oInstruction = { `LCD , 8'd0, `R1 , 8'd0  }; 
	73: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE20  ,16'd0  }; 
	74: oInstruction = { `JMP , `LABEL_LOOP10  ,16'd0  }; 
	
//`LABEL_CONTINUE20	
	75: oInstruction = { `SLH , 8'd0, `R1 , 8'd0  };
	76: oInstruction = { `BRANCH_IF_NSYNC , `LABEL_CONTINUE21  ,16'd0  };
	77: oInstruction = { `JMP , `LABEL_CONTINUE20  ,16'd0  };

//`LABEL_CONTINUE21 
	78: oInstruction = { `STO , `R1,16'd100 }; 


	default:
		oInstruction = { `LED ,  24'b10101010 };	//NOP
	endcase	
end
	
endmodule
