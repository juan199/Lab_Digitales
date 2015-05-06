`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:59:13 04/29/2015 
// Design Name: 
// Module Name:    LCD_Controller_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LCD_Controller_test(
	output wire oLCD_RegisterSelect,
	output wire oLCD_ReadWrite
);

reg [3:0] data; 
wire [3:0] data_out; 
reg reset, write_en, lcd_response, Clock;
wire enable_out, rs_out;

initial 
	Clock = 1'b0;

always
	#5 Clock = !Clock;

LCD_controler uut( .clk(Clock), .iLCD_data(data), .iLCD_reset(reset), .iLCD_writeEN(write_en), .oLCD_response(lcd_responce), .oLCD_Data(data_out), .oLCD_Enabled(enable_out), .oLCD_RegisterSelect(rs_out), .oLCD_ReadWrite(oLCD_ReadWrite), .oLCD_StrataFlashControl(oLCD_StrataFlashControl) );

initial
	begin
	#10 reset = 1;
	#10 reset = 0;
	end
	
always @ (lcd_responce)
	if(lcd_responce)
		begin
		write_en = 1'b1;
		data = 4'b0101;
		end
	else
		begin
		write_en = 1'b0;
		data = 4'b0;		
		end	
endmodule
