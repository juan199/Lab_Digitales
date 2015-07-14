// Laboratorio de Circuitos Digitales
// Cornejo, Rincón, Sánchez
// Proyecto Final 

// --->>> Módulo controlador microprogramado (Based on controlador.v) <<<---
`define InstrucWidth 5
`define MemorySize
`define AddressSize


module controller (
	input wire clk, reset,// Fixed Inputs 
//************************ Jump conditions**********************************
	input wire Compress,
	input wire Decompress,
	input wire found,
	input wire DicPointerEqualsINsertPoniter,
	input wire StringRAMSizeEqualsStringSize,
	input wire DicPointerEqualsJumpAddress,
	input wire StringRAMSizeEqualsZero,
	input wire StringRAMEqualsString,
	input wire CodeBigger128,
	input wire CodeEqualsZero
//***********************************************************************
);
//-------------------------------------------------------------------------
//							   Internal Variables
//-------------------------------------------------------------------------
    assign JumpConditions = {Compress,
							Decompress,
							found,
							DicPointerEqualsINsertPoniter,
							StringRAMSizeEqualsStringSize,
							DicPointerEqualsJumpAddress,
							StringRAMSizeEqualsZero,
							StringRAMEqualsString,
							CodeBigger128,
							CodeEqualsZero};
			


//----------------------------------------------------------------------
//							   Memory Section
//----------------------------------------------------------------------
	reg  [`InstrucWidth-1:0] Memory[0:`MemorySize-1];
	initial
	$readmemb ("programa.dat", Memory);
	wire [`InstrucWidth-1:0]NextInstruction;
	wire  [`AddressSize-1:0] ProxAddress;
	//always @(ProxAddress)
	assign NextInstruction = Memory[ProxAddress];	
	

//----------------------------------------------------------------------
//							   Instruction Register
//----------------------------------------------------------------------
	reg [`InstrucWidth-1:0] InstrucRegister;
	always @(posedge clk)
		InstrucRegister <= NextInstruction;
	
	assign JumpSelection = InstrucRegister[3:0];
	assign JumpAddress = InstrucRegister[3:0];	// Cambiar
	assign ControlSignals = InstrucRegister[3:0];	//	Cambiar
	
	
//----------------------------------------------------------------------
//							   JumpMux
//----------------------------------------------------------------------	
	assign JumpTrue = JumpConditions[JumpSelection];
	
	
//----------------------------------------------------------------------
//							Program Counter
//----------------------------------------------------------------------		
	reg [`AddressSize-1:0] ProgramCounter;
	always @(posedge clk)
		ProgramCounter = ProxAddress;

//----------------------------------------------------------------------
//							  AddressMux
//----------------------------------------------------------------------		
	assign AddressMux = JumpTrue ? JumpAddress : (ProgramCounter + 1);

	
//----------------------------------------------------------------------
//							  andReset
//----------------------------------------------------------------------
	assign ProxAddress = reset & AddressMux;
	
endmodule