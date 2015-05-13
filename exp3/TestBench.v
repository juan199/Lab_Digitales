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
	reg response;

	// Outputs
	wire [7:0] oLed;
	wire [3:0]data;
	wire LCDreset;
	wire writeEN;

	// Instantiate the Unit Under Test (UUT)
	MiniAlu uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLed(oLed),
		.iLCD_response(response),
		.oLCD_data(data),
		.oLCD_reset(LCDreset), 
		.oLCD_writeEN(writeEN)
	);
	
	always
	begin
		#5  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		response=0;

		// Wait 100 ns for global reset to finish
		Reset = 1;
		#50
		Reset = 0;
        
		// Add stimulus here
		#50 response=1; #26 response=0; #130 response=1;

	end
      
endmodule

