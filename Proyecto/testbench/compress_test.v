module testbench;
	
	reg clk;
	reg reset;
	reg Compress;
	reg Decompress;
	
	
	initial
		begin
		clk   = 1'b1;
		reset = 1'b1;
		Decompress = 1'b0;
		#30 reset = 1'b0;
		#50 Compress = 1'b1;
		end
		
	always
		#5 clk = ~clk;
	
	wire [17:0] oBufferIn;
		
	BufferIn buffin(
		.Clk(clk),
		.InputBuffer(RequestInputBuffer),
		.oBufferIn(oBufferIn),
		.EndOfFile(EOF)
	);
	
	controller ctrl(
		.clk(clk), 
		.reset(reset),
		.StringLoadZero(StringLoadZero),
		.StringLoadChar(StringLoadChar),
		.StringLoadBuffer(StringLoadBuffer),
		.ConcatenateChar(ConcatenateChars),
		.StringShiftRight(StringShiftRight),
		.ConcatenateStringSize(ConcatenateStringSize),
		.LoadInsertPointer(LoadInsertPointer),
		.UpdateInsertPointer(UpdateInsertPointer),
		.CodeLoadZero(CodeLoadZero),
		.CodeIncrement(CodeIncrement),	 		
		.NotFound(NotFound),
		.Found(Found),
		.CharLoadBuffer(CharLoadBuffer),
		.BufferInitDicPointer(BufferInitDicPointer),
		.LoadDicPointer(LoadDicPointer),
		.DicPointerIncrement(DicPointerIncrement),
		.LoadJumpAddress(JumpLoadAddress),
		.DicPointerLoadInsert(DicPointerLoadInsert),
		.StringRAMLoad(StringRAMLoad),
		.StringRAMZero(StringRAMZero),
		.StringRAMShift(StringRAMShift),
		.SetJumpAddress(SetJumpAddress),
		.RequestOutBuffer(RequestOutBuffer),
		.CloseBuffer(CloseBuffer),
		.RAMread(RAMread),
		.RAMZeroData(oRAMzeroData),
		.InitRAMCode(oInitRAMCode),
		.WriteString(oWriteString),
//************************ Jump conditions******************************
		.Compress(Compress), 											// 1100 
		.Decompress(Decompress),                      					// 1011
		.DicPointerEqualsINsertPoniter(DicPointerEqualsInsertPointer),  // 1010
		.StringRAMSizeEqualsStringSize(StringRAMSizeEqualsStringSize),  // 1001
		.DicPointerEqualsJumpAddress(DicPointerEqualsJumpAddress),     	// 1000
		.StringRAMSizeEqualsZero(StringRAMSizeEqualsZero),         		// 0111
		.StringRAMEqualsString(StringRAMEqualsString),           		// 0110
		.CodeBigger128(CodeBigger128),                   				// 0101
		.CodeEqualsZero(CodeEqualsZero),                  				// 0100
		.EndOfFile(EOF),                       							// 0011
		.FoundStatus(FoundStatus)                      					// 0010
	//   Inconditional jump                     						// 0001
	//   No jump                                						// 0000
);

wire [15:0] iRAMBuffer;
wire [11:0] outBuffer;
wire [7:0]  ramCode;
wire [15:0] ramString;
wire [17:0] ramDicPointer;


Registers registers(
	.Clk(clk),
	.InBuffer(oBufferIn),
	.iRAMBuffer(iRAMBuffer),
	.outBuffer(outBuffer),
	.RequestInBuffer(RequestInputBuffer),

// **************** Control for String *************************************
	.StringLoadZero(StringLoadZero),
	.StringLoadChar(StringLoadChar),
	.StringLoadBuffer(StringLoadBuffer),
	.ConcatenateChar(ConcatenateChars),
	.StringShiftRight(StringShiftRight),
	.ConcatenateStringSize(ConcatenateStringSize),

// **************** Control for Insert Pointer *************************
	.LoadInsertPointer(LoadInsertPointer),
	.UpdateInsertPointer(UpdateInsertPointer),

// **************** Control for Code ***********************************
	.CodeLoadZero(CodeLoadZero),
	.CodeIncrement(CodeIncrement),	 		
	
// **************** Control for Found **********************************
	.NotFound(NotFound),
	.Found(Found),

// **************** Control for Char ***********************************
	.CharLoadBuffer(CharLoadBuffer),

// **************** Control for Init Dictionary Pointer ****************
	.BufferInitDicPointer(BufferInitDicPointer),

// **************** Control for Dictionary Pointer *********************
	.LoadDicPointer(LoadDicPointer),
	.DicPointerIncrement(DicPointerIncrement),
	.LoadJumpAddress(JumpLoadAddress),
	.DicPointerLoadInsert(DicPointerLoadInsert),

// **************** Control for StringRAM ******************************
	.StringRAMLoad(StringRAMLoad),
	.StringRAMZero(StringRAMZero),
	.StringRAMShift(StringRAMShift),

// **************** Control for Jumping Address ************************
	.SetJumpAddress(SetJumpAddress),

// ****************** Jump conditions **********************************
	.DicPointerEqualsInsertPointer(DicPointerEqualsInsertPointer),
	.StringRAMSizeEqualsStringSize(StringRAMSizeEqualsStringSize),
	.DicPointerEqualsJumpAddress(DicPointerEqualsJumpAddress),
	.StringRAMSizeEqualsZero(StringRAMSizeEqualsZero),
	.StringRAMEqualsString(StringRAMEqualsString),
	.CodeBigger128(CodeBigger128),
	.CodeEqualsZero(CodeEqualsZero),
	.FoundStatus(FoundStatus),
	
// ********************* Data to RAM ***********************************	
	.ramCode(ramCode),
	.ramString(ramString),
	.ramDicPointer(ramDicPointer)
);

wire [15:0] oRAMBuffer;

RAMBuffer ramBuffer(
	.RAMread(RAMread),
	.RAMZeroData(oRAMzeroData),
	.InitRAMCode(oInitRAMCode),
	.WriteString(oWriteString),
	.ramCode(ramCode),
	.ramString(ramString),
	.ramDicPointer(ramDicPointer),
	.oRAMBuffer(oRAMBuffer)
);	
	

BufferOut	BufferOut(
	.Clk(clk),
	.OutputBuffer(RequestOutBuffer),
	.CloseBuffer(CloseBuffer),
	.iBufferOut(outBuffer)
);
		
endmodule
