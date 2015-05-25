`default_nettype none
`timescale 1ns/100ps

module vga_controller(
	input  wire       clock_ref, // 50 MHz
	input  wire       reset,
	input  wire [2:0] iRGB, 
	output wire       h_sync,
	output wire       v_sync,
	output wire [8:0] row,
	output wire [9:0] column,
	output reg  [2:0] oRGB
);

wire reset_h_counter, reset_v_counter;
wire enable_v_counter;
wire [9:0] h_counter;
wire [9:0] v_counter;
wire clock;  // 25 MHz

UPCOUNTER_POSEDGE #(1) clock_divisor(
	.Clock(clock_ref),
	.Reset(reset),
	.Initial(1'b1),
	.Enable(1'b1),
	.Q(clock)
);

UPCOUNTER_POSEDGE #(10) horizontal_counter(
	.Clock(clock), 
	.Reset(reset_h_counter),
	.Initial(10'b0),
	.Enable(1'b1),
	.Q(h_counter)
);

UPCOUNTER_POSEDGE #(10) vertical_counter(
	.Clock(clock), 
	.Reset(reset_v_counter),
	.Initial(10'b0),
	.Enable(enable_v_counter),
	.Q(v_counter)
);

assign reset_h_counter = reset | (h_counter == 10'd799);
assign reset_v_counter = reset | (v_counter == 10'd521);  // 520 ó 521??
assign enable_v_counter = reset_h_counter;
assign h_sync = h_counter < 10'd96 ? 1'b0 : 1'b1;
assign v_sync = v_counter < 10'd2 ? 1'b0 : 1'b1;
assign row = (v_counter > 10'd11 & v_counter < 10'd491) ? (v_counter - 10'd11) : 10'b0 ;
assign column = (h_counter > 10'd143 & h_counter < 10'd783) ? (h_counter - 10'd143) : 10'b0 ; 

always @ (posedge clock)
	oRGB <= 3'b010;

endmodule