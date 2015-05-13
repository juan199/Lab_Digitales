
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 input wire iLCD_response,//Respuesta del LCD
 output reg [7:0] oLed,
 output reg [3:0] oLCD_data,//Datos a enviar al LCD
 output wire oLCD_reset, //Reset del LCD_Controller
 output reg oLCD_writeEN // Señal de envío de Datos al LCD_Controller
);

wire [15:0]  wIP,wIP_temp,IMUL_Result;
wire [7:0] imul_result;
reg Subroutine_Flag;
reg Return_Flag;
wire [15:0] wReturn_Sub; 
reg         rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg signed [32:0]   rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire signed [15:0] wSourceData0,wSourceData1,wImmediateValue;
wire [15:0] wIPInitialValue;
wire [15:0] oIMUL2;

IMUL2 Multiply4(
			.iSourceData0(wSourceData0),
			.iSourceData1(wSourceData1),
			.oResult(oIMUL2)
			);

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);


assign oLCD_reset = Reset;
assign wIPInitialValue = (Reset) ? 8'b0 : (Return_Flag? wReturn_Sub:wDestination);

UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);


assign wIP = (rBranchTaken) ? (Return_Flag? wReturn_Sub:wIPInitialValue): wIP_temp;


FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);

reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);
//***************************** FFD Subroutine **********************************
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 ) FFDSub 
(
	.Clock(Subroutine_Flag),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wIP_temp),
	.Q(wReturn_Sub)

);
//************************************************************************
//***************************** IMUL16 **********************************
IMUL16 #(16) MULT16
(
.A(wSourceData0),
.B(wSourceData1),
.oResult(IMUL_Result)
);
//************************************************************************

mult imultiplier( .opA(wSourceData0), .opB(wSourceData1), .result(imul_result));

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};



always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 1'b0;
		oLCD_writeEN <= 1'b0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;

	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		oLCD_writeEN <=1'b0;
		rResult      <= wSourceData1 + wSourceData0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;

	end
	//-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		oLCD_writeEN <= 1'b0;
		rResult      <= wSourceData1 - wSourceData0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;

	end
	//-------------------------------------
	`BRANCH_IF_NSYNC:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (iLCD_response)
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		oLCD_writeEN <= 1'b1;
		
	end
	//-------------------------------------
	`LCD:  // Juan
		begin		
		rWriteEnable <= 1'b0;
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		oLCD_data    <= wSourceData1[7:4];//Manda Parte Alta 
		oLCD_writeEN	<= 1'b1;
		rResult <= 1'b0;
	end
		//-------------------------------------
	`SLH:  // Juan
		begin
		rWriteEnable   <= 1'b0;
		rFFLedEN       <= 1'b0;
		oLCD_data      <= wSourceData1[3:0];//Manda Parte Alta 
		oLCD_writeEN	<= 1'b1;
		rBranchTaken <= 1'b0;
		rResult <=0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end

	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		oLCD_writeEN <= 1'b0;
		rResult      <= wImmediateValue;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;

	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 1'b0;
		oLCD_writeEN <= 1'b0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
		
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
				
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		oLCD_writeEN <= 1'b0;
		rBranchTaken <= 1'b1;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;

	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		oLCD_writeEN <= 1'b0;
		rBranchTaken <= 1'b0;
		Subroutine_Flag <= 1'b0;
		Return_Flag <= 1'b0;
	end

	//-------------------------------------		

	`CALL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b1;
		rWriteEnable <= 1'b0;
		Subroutine_Flag <=1'b1;
		Return_Flag <=1'b0;
		rResult      <= 0;
		oLCD_writeEN <= 1'b0;
			
	end
	//-------------------------------------
	`RET:
	begin
    	
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b1;
		rWriteEnable <= 1'b0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b1;
		rResult      <= 0;
		oLCD_writeEN <= 1'b0;
		
	end

	//-------------------------------------		
	`SMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 * wSourceData0;
		oLCD_writeEN <= 1'b0;
		
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		oLCD_writeEN <= 1'b0;
		rBranchTaken <= 1'b0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
