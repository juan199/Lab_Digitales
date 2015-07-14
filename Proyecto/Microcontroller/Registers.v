module Registers(
input 	wire 	Clock,
// **************** I/O for String size ********************************
input	wire	StringLoadZero,
input	wire	StringLoadChar,
input	wire	StringLoadBuffer,
input	wire	ConcatenateChar,
input	wire	StringShiftRight,
output	reg		[3:0] 	StringSize,
//**********************************************************************

// **************** I/O for String *************************************
input 	wire	ConcatenateStringSize,
input	wire 	[17:0]	Buffer,
output 	reg		[128:0] String,
//**********************************************************************

// **************** I/O for Insert Pointer *****************************
input	wire 	LoadInsertPointer,
input	wire	UpdateInsertPointer,
output 	reg		[17:0] InsertPointer,
//**********************************************************************

// **************** I/O for Code ***************************************
input 	wire	CodeLoadZero,
input	wire	CodeIncrement,
output 	reg		[11:0] Code,	 		
//**********************************************************************

// **************** I/O for RAM Buffer *********************************
input	wire	RAMZeroData,
input	wire	InitRAMCode,
input	wire	WriteString,
output 	reg		[15:0] RAMBuffer,
//**********************************************************************

// **************** I/O for Found **************************************
input 	wire	NotFound,
input	wire	Found,
output	reg 	FoundRegister,
//**********************************************************************

// **************** I/O for Char ***************************************
input 	wire	CharLoadBuffer,
output 	reg		[7:0] Char,
//**********************************************************************

// **************** I/O for Init Dictionary Pointer ********************
input wire		BufferInitDicPointer,
output 	reg		[17:0] InitDicPointer,
//**********************************************************************


// **************** I/O for Dictionary Pointer *************************
input	wire	LoadDicPointer,
input	wire	DicPointerIncrement,
input	wire	JumpLoadAddress,
output 	reg		[17:0] DicPointer,
//**********************************************************************

// **************** I/O for String to RAM ******************************
input 	wire	StringRAMLoad,
input	wire	StringRAMZero,
input	wire	StringRAMShift,
output 	reg		[143:0] StringRAM,
//**********************************************************************

// **************** I/O for Jumping Address ****************************
input	wire	SetJumpAddress,
output 	reg		[17:0] JumpAddress
//**********************************************************************
);

// *************** String Size manage **********************************
always@(posedge Clock)
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
always@(posedge Clock)
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
		String = {120'b0,Buffer[7:0]};	
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
always@(posedge Clock)
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
always@(posedge Clock)
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

// *************** RAMBuffer Manager ***********************************
always@(posedge Clock)
begin
	if(RAMZeroData)	
	begin
		RAMBuffer = 16'b0;	
	end
	
	else if (InitRAMCode)
	begin
		RAMBuffer = {8'b0,Code[7:0]} ;	
	end
	
	else if (WriteString)
	begin
		RAMBuffer = String[15:0];	
	end
end
//**********************************************************************

// *************** Found Manage 	************************************
always@(posedge Clock)
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
always@(posedge Clock)
begin
	if(CharLoadBuffer)	
	begin
		Char = Buffer[7:0];	
	end
end
//**********************************************************************

// *************** Init Dictionary Pointer Manage 	********************
always@(posedge Clock)
begin
	if(BufferInitDicPointer)	
	begin
		InitDicPointer = Buffer;	
	end
end
//**********************************************************************

// *************** Dictionary Pointer Manager **************************
always@(posedge Clock)
begin
	if(LoadDicPointer)	
	begin
		DicPointer = InitDicPointer;	
	end
	
	else if (DicPointerIncrement)
	begin
		DicPointer = DicPointer + 1;	
	end
	
	else if (JumpLoadAddress)
	begin
		DicPointer = JumpAddress;	
	end
end
//**********************************************************************

// *************** Jump Address Manage 	********************************
always@(posedge Clock)
begin
	if(SetJumpAddress)	
	begin
		JumpAddress = DicPointer + 1 + StringRAM + StringRAM[135:127]/2;	
	end
end
//**********************************************************************

// *************** StringRAM Manager ***********************************
always@(posedge Clock)
begin
	if(StringRAMLoad)	
	begin
		StringRAM = {RAMBuffer[17:0],StringRAM[135:15]};	
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
