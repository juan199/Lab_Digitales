`define STATE_RESET 0

module LCD_controler(
	input wire clk,
	input wire [3:0] iLCD_data,
	input wire iLCD_reset,
	input wire iLCD_writeEN,
	output reg oLCD_response,
	output reg [3:0] oLCD_Data,
	output reg oLCD_Enabled,
	output reg oLCD_RegisterSelect, 
	output wire oLCD_ReadWrite,
	output wire oLCD_StrataFlashControl
);

assign oLCD_StrataFlashControl = 1;
assign oLCD_ReadWrite = 0;

reg [7:0] CurrentState;
reg [7:0] NextState;
reg [31:0] TimeCount;
reg TimeCountReset;
reg init_ptr;

always @ (posedge clk)
begin
	if(iLCD_reset)
		begin
		CurrentState = `STATE_RESET;
		TimeCount = 32'b0;
		end
	else
		begin
		if(TimeCountReset)
			TimeCount = 32'b0;
		else
			TimeCount = TimeCount + 1;
		end
	CurrentState = NextState;		
end

always @ ()