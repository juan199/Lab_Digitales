
module BufferIn(
	input wire       Clk,
	input wire       InputBuffer,
	output reg [7:0] oBufferIn,
	output reg       EndOfFile
);
	reg [7:0] tmpChar;
	integer i;
	
	initial
		begin
		i = $fopen("original.txt");
		EndOfFile = 1'b0;
		end

	always @ (posedge Clk)
		begin
		if(InputBuffer)
			begin
			tmpChar = $fgetc(i);
			if($feof(i))
				EndOfFile = 1'b1;
			else
				oBufferIn = tmpChar[7:0];
			end
		end		
endmodule

module BufferOut(
	input wire       Clk,
	input wire       OutputBuffer,
	input wire       CloseBuffer,
	input wire [11:0] iBufferOut
);
	integer f;
	initial
		f = $fopen("compressed.txt");
	
	always @ (posedge Clk)
		begin
		if(OutputBuffer)
			$fwrite(f,"%b", iBufferOut);
		if(CloseBuffer)
			begin
			$fflush(f);
			$fclose(f);  
			end
		end
endmodule

module RAMBuffer(
	input wire        RAMread,
	input wire        RAMZeroData,
	input wire        InitRAMCode,
	input wire        WriteString,
	input wire [7:0]  ramCode,
	input wire [15:0] ramString,
	input wire [17:0] ramDicPointer,
	output reg [15:0] oRAMBuffer
);

	reg [15:0] RAM [262143:0];
	
	always @ (*)
		begin
		if(RAMZeroData)
			RAM[ramDicPointer] = 16'b0;
		else if(InitRAMCode)
			RAM[ramDicPointer] = {8'b0, ramCode};
		else if(WriteString)
			RAM[ramDicPointer] = ramString;
		else if(RAMread)
			oRAMBuffer = RAM[ramDicPointer];
		end
endmodule
