`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:52 01/30/2011
// Design Name:   MiniAlu
// Module Name:   D:/Proyecto/RTL/Dev/MiniALU/TestBench.v
// Project Name:  MiniALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MiniAlu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg Clock;
	reg Reset;
	//reg response;

	// MiniALU Outputs
	wire response;
	wire [7:0] oLed;
	wire [3:0]data;
	wire LCDreset;
	wire writeEN;
	// LCD_Controller OutPuts
	wire [3:0]oLCD_Data;
	wire oLCD_Enabled;
	wire oLCD_RegisterSelect;
	wire oLCD_ReadWrite;
	wire oLCD_StrataFlashControl;
	

	// Instantiate the Units Under Test (UUT)
	MiniAlu uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLed(oLed),
		.iLCD_response(response),
		.oLCD_data(data),
		.oLCD_reset(LCDreset), 
		.oLCD_writeEN(writeEN)
	);
	
	LCD_controler uut1(
		.clk(Clock),
		.iLCD_data(data),
		.iLCD_reset(LCDreset),
		.iLCD_writeEN(writeEN),
		.oLCD_response(response),
		.oLCD_Data(oLCD_Data),
		.oLCD_Enabled(oLCD_Enabled),
		.oLCD_RegisterSelect(oLCD_RegisterSelect), 
		.oLCD_ReadWrite(oLCD_ReadWrite),
		.oLCD_StrataFlashControl(oLCD_StrataFlashControl)
	);
	
	always
	begin
		#1  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;

		// Wait 100 ns for global reset to finish
		Reset = 1;
		#2
		Reset = 0;
        
		// Add stimulus here
		

	end
      
endmodule

