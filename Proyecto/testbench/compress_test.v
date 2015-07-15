module testbench;
	
	reg clk;
	reg reset;
	
	initial
		begin
		clk   = 1'b1;
		reset = 1'b1;
		#30 reset = 1'b0;
		end
		
	always
		#5 clk = ~clk;
		
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
		.JumpLoadAddress(JumpLoadAddress),
		.StringRAMLoad(StringRAMLoad),
		.StringRAMZero(StringRAMZero),
		.StringRAMShift(StringRAMShift),
		.SetJumpAddress(SetJumpAddress),
	output wire RequestOutBuffer,
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


		
endmodule
