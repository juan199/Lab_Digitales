`define InstrucWidth 49
`define MemorySize 256
`define AddressSize 8

module controller (
	input  wire clk, 
	input  wire reset,
// **************** Control for String *********************************
	output wire StringLoadZero,
	output wire StringLoadChar,
	output wire StringLoadBuffer,
	output wire ConcatenateChar,
	output wire StringShiftRight,
	output wire ConcatenateStringSize,
// **************** Control for Insert Pointer *************************
	output wire LoadInsertPointer,
	output wire UpdateInsertPointer,
// **************** Control for Code ***********************************
	output wire CodeLoadZero,
	output wire CodeIncrement,	 		
// **************** Control for Found **********************************
	output wire NotFound,
	output wire Found,
// **************** Control for Char ***********************************
	output wire CharLoadBuffer,
// **************** Control for Init Dictionary Pointer ****************
	output wire BufferInitDicPointer,
// **************** Control for Dictionary Pointer *********************
	output wire LoadDicPointer,
	output wire DicPointerIncrement,
	output wire JumpLoadAddress,
// **************** Control for StringRAM ******************************
	output wire StringRAMLoad,
	output wire StringRAMZero,
	output wire StringRAMShift,
// **************** Control for Jumping Address ************************
	output wire SetJumpAddress,
// **************** Control for Buffers and RAM ************************
	output wire InputBuffer,
	output wire OutputBuffer,
	output wire CloseBuffer,
	output wire RAMread,
	output wire RAMZeroData,
	output wire InitRAMCode,
	output wire WriteString,
//************************ Jump conditions******************************
	input wire Compress, 						// 1101 
	input wire Decompress,                      // 1100
	input wire found,                           // 1011
	input wire DicPointerEqualsINsertPoniter,   // 1010
	input wire StringRAMSizeEqualsStringSize,   // 1001
	input wire DicPointerEqualsJumpAddress,     // 1000
	input wire StringRAMSizeEqualsZero,         // 0111
	input wire StringRAMEqualsString,           // 0110
	input wire CodeBigger128,                   // 0101
	input wire CodeEqualsZero,                  // 0100
	input wire EndOfFile,                       // 0011
	input wire FoundStatus                      // 0010
	//   Inconditional jump                     // 0001
	//   No jump                                // 0000
);

//----------------------------------------------------------------------
//							   Internal Variables
//----------------------------------------------------------------------
    assign JumpConditions = {Compress,
							Decompress,
							found,
							DicPointerEqualsINsertPoniter,
							StringRAMSizeEqualsStringSize,
							DicPointerEqualsJumpAddress,
							StringRAMSizeEqualsZero,
							StringRAMEqualsString,
							CodeBigger128,
							CodeEqualsZero,
							EndOfFile,
							FoundStatus,
							1'b1,
							1'b0,
};

//----------------------------------------------------------------------
//							   Memory Section
//----------------------------------------------------------------------
	reg  [`InstrucWidth-1:0] Memory[0:`MemorySize-1];
	
	initial
		$readmemb("ctrl_program.up", Memory);
	
	wire [`InstrucWidth-1:0] NextInstruction;
	wire  [`AddressSize-1:0] ProxAddress;
	wire  [`AddressSize-1:0] ReturnAddress;
	
	assign NextInstruction = Memory[ProxAddress];	
	

//----------------------------------------------------------------------
//      				   Instruction Register
//----------------------------------------------------------------------
	reg [`InstrucWidth-1:0] InstrucRegister;
	always @(posedge clk)
		InstrucRegister <= NextInstruction;
	
	assign ControlSignals = InstrucRegister[48:21];	//	Revisar
	assign JumpSelection  = InstrucRegister[20:17];
	assign JumpAddress    = InstrucRegister[16:9];	// Revisar
	assign Return         = InstrucRegister[8];
	
	always @ (posedge clk)
		if(JumpTrue)
			ReturnAddress = InstrucRegister[7:0]; // Revisar

	
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
	assign ProxAddress = reset & (Return ? ReturnAddress : AddressMux);
	
endmodule
