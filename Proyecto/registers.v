module Registers(
	input  wire 	   Clk,
	input  wire [17:0] InBuffer,
	input  wire [15:0] iRAMBuffer,
	output wire [11:0] outBuffer,
	output wire        RequestInBuffer,

// **************** Control for String *************************************
	input wire StringLoadZero,
	input wire StringLoadChar,
	input wire StringLoadBuffer,
	input wire ConcatenateChar,
	input wire StringShiftRight,
	input wire ConcatenateStringSize,

// **************** Control for Insert Pointer *************************
	input wire LoadInsertPointer,
	input wire UpdateInsertPointer,

// **************** Control for Code ***********************************
	input wire CodeLoadZero,
	input wire CodeIncrement,	 		
	
// **************** Control for Found **********************************
	input wire NotFound,
	input wire Found,

// **************** Control for Char ***********************************
	input wire CharLoadBuffer,

// **************** Control for Init Dictionary Pointer ****************
	input wire BufferInitDicPointer,

// **************** Control for Dictionary Pointer *********************
	input wire LoadDicPointer,
	input wire DicPointerIncrement,
	input wire LoadJumpAddress,
	input wire DicPointerLoadInsert,

// **************** Control for StringRAM ******************************
	input wire StringRAMLoad,
	input wire StringRAMZero,
	input wire StringRAMShift,

// **************** Control for Jumping Address ************************
	input wire SetJumpAddress,

// ****************** Jump conditions **********************************
	output wire	DicPointerEqualsInsertPointer,
	output wire	StringRAMSizeEqualsStringSize,
	output wire	DicPointerEqualsJumpAddress,
	output wire	StringRAMSizeEqualsZero,
	output wire	StringRAMEqualsString,
	output wire	CodeBigger128,
	output wire	CodeEqualsZero,
	output wire FoundStatus,
	
// ********************* Data to RAM ***********************************	
	output wire [7:0]  ramCode,
	output wire [15:0] ramString,
	output wire [17:0] ramDicPointer
);

//**********************************************************************
//**************************  Conditions *******************************
//**********************************************************************
assign DicPointerEqualsInsertPointer 	= (DicPointer == InsertPointer)? 1'b1:1'b0;
assign StringRAMSizeEqualsStringSize 	= (StringRAM[135:127] == StringSize)? 1'b1:1'b0;
assign DicPointerEqualsJumpAddress	  	= (DicPointer == JumpAddress)? 1'b1:1'b0;	
assign StringRAMSizeEqualsZero	  		= (StringRAM[7:0] == 0)? 1'b1:1'b0;
assign StringRAMEqualsString		  	= (StringRAM[135:7] == String)? 1'b1:1'b0;
assign CodeBigger128				  	= (Code > 12'd128)? 1'b1:1'b0;
assign CodeEqualsZero				  	= (Code == 0)? 1'b1:1'b0;
assign FoundStatus                      = FoundRegister;

//**********************************************************************
//*************************   Data to RAM  *****************************
//**********************************************************************

assign ramCode       = Code[7:0];
assign ramString     = String[15:0];
assign ramDicPointer = DicPointer;

//**********************************************************************
//***********************   Data to Buffer  ****************************
//**********************************************************************

assign outBuffer        = Code;
assign RequestInBuffer  = StringLoadBuffer | CharLoadBuffer | BufferInitDicPointer;

//**********************************************************************
//**************************  Registers *******************************
//**********************************************************************
reg [17:0]  JumpAddress;
reg	[143:0] StringRAM;
reg	[17:0]  DicPointer;
reg	[17:0]  InitDicPointer;
reg	[7:0]   Char;
reg         FoundRegister;
reg	[11:0]  Code;
reg	[17:0]  InsertPointer;
reg	[3:0] 	StringSize;
reg	[128:0] String;

// *************** String Size manage **********************************
always@(posedge Clk)
begin
	if(StringLoadZero)	
	begin
		StringSize = 4'b0;	
	end
	else if (StringLoadChar || StringLoadBuffer)
	begin
		StringSize = 4'd1;	
	end
	else if (ConcatenateChar)
	begin
		StringSize = StringSize+1;
	end
	else if (StringShiftRight)
	begin
		StringSize = StringSize-1;
	end	

end
//**********************************************************************


// *************** String manage ***************************************
always@(posedge Clk)
begin
	if(StringLoadZero)	
	begin
		String = 128'b0;	
	end
	
	else if (StringLoadChar)
	begin
		String = {120'b0,Char};	
	end
	
	else if (StringLoadBuffer)
	begin
		String = {120'b0, InBuffer[7:0]};	
	end
	
	else if (ConcatenateChar)
	begin
		String = {String[119:0],Char};
	end
	
	else if (StringShiftRight)
	begin
		String = {8'b0,String[119:0]};
	end	
	
	else if (ConcatenateStringSize)
	begin
		String = {String[119:0],StringSize};
	end	

end
//**********************************************************************

// *************** Insert Pointer manage *******************************
always@(posedge Clk)
begin
	if(LoadInsertPointer)	
	begin
		InsertPointer = DicPointer;	
	end
	
	else if (UpdateInsertPointer)
	begin
		InsertPointer = InsertPointer+ StringSize/2 +1;	
	end
end
//**********************************************************************

// *************** Code Manage 	****************************************
always@(posedge Clk)
begin
	if(CodeLoadZero)	
	begin
		Code = 12'b0;	
	end
	
	else if (CodeIncrement)
	begin
		Code = Code +1;	
	end
end
//**********************************************************************


// *************** Found Manage 	************************************
always@(posedge Clk)
begin
	if(Found)	
	begin
		FoundRegister = 1'b1;	
	end
	
	else if (NotFound)
	begin
		FoundRegister =  1'b0;	
	end
end
//**********************************************************************

// *************** Char Manage 	****************************************
always@(posedge Clk)
begin
	if(CharLoadBuffer)	
	begin
		Char = InBuffer[7:0];	
	end
end
//**********************************************************************

// *************** Init Dictionary Pointer Manage 	********************
always@(posedge Clk)
begin
	if(BufferInitDicPointer)	
	begin
		InitDicPointer = InBuffer;	
	end
end
//**********************************************************************

// *************** Dictionary Pointer Manager **************************
always@(posedge Clk)
begin
	if(LoadDicPointer)	
	begin
		DicPointer = InitDicPointer;	
	end
	
	else if (DicPointerIncrement)
	begin
		DicPointer = DicPointer + 1;	
	end
	
	else if (LoadJumpAddress)
	begin
		DicPointer = JumpAddress;	
	end
	else if (DicPointerLoadInsert)
		DicPointer = InsertPointer;
end
//**********************************************************************

// *************** Jump Address Manage 	********************************
always@(posedge Clk)
begin
	if(SetJumpAddress)	
	begin
		JumpAddress = DicPointer + 1 + StringRAM + StringRAM[135:127]/2;	
	end
end
//**********************************************************************

// *************** StringRAM Manager ***********************************
always@(posedge Clk)
begin
	if(StringRAMLoad)	
	begin
		StringRAM = {iRAMBuffer[17:0],StringRAM[135:15]};	
	end
	
	else if (StringRAMZero)
	begin
		StringRAM = 144'b0;	
	end
	
	else if (StringRAMShift)
	begin
		StringRAM = {16'b0,StringRAM[143:15]};	
	end
end
//**********************************************************************


endmodule
