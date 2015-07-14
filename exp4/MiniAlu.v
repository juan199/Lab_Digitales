
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 input wire PS2_CLK,
 input wire PS2_DATA,
 output wire [7:0] oLed 
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
wire [7:0] KeyCode,wKeyCode;
wire KeyCodeReady;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire signed [15:0] wSourceData0,wSourceData1,wImmediateValue;
wire [15:0] wIPInitialValue;
wire [15:0] oIMUL2;


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
	.Enable( KeyCodeReady ),
	.D( wKeyCode ),
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


FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 ) FFDKEy 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(KeyCodeReady),
	.D(KeyCode),
	.Q(wKeyCode)
);


KeyBoard_Controller KBC 
(
		.Clk(PS2_CLK), 
		.Data(PS2_DATA), 
		.reset(Reset),
		.Parallel_data(KeyCode),
		.Sent(KeyCodeReady)
);


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
		rResult      <= 0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
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
		rResult      <= wSourceData1 - wSourceData0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end
	//-------------------------------------
	`SMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 * wSourceData0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
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
		rBranchTaken <= 1'b0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
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
		
	end
	
	//-------------------------------------
	`BRANCH_IF_KB:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (KeyCodeReady)
			rBranchTaken <= 1'b0;
		else
			rBranchTaken <= 1'b1;
		
	end
	//-------------------------------------

	
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		Subroutine_Flag <=1'b0;
		Return_Flag <=1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
