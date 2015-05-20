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

wire reset_h_counter, reset_v_counter, reset_row_counter;
wire enable_row_counter;
wire [9:0] h_counter;
wire [18:0] v_counter;
wire clock;  // 25 MHz

UPCOUNTER_POSEDGE #(1) tmp_counter(
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

UPCOUNTER_POSEDGE #(19) vertical_counter(
	.Clock(clock), 
	.Reset(reset_v_counter),
	.Initial(19'b0),
	.Enable(1'b1),
	.Q(v_counter)
);

UPCOUNTER_POSEDGE #(9) row_counter(
	.Clock(clock), 
	.Reset(reset_row_counter),
	.Initial(9'b0),
	.Enable(enable_row_counter),
	.Q(row)
);

assign reset_h_counter = reset | (h_counter == 10'd799) ? 1 : 0;
assign reset_v_counter = reset | (v_counter == 19'd416799) ? 1 : 0; 
assign reset_row_counter = reset | (row == 9'd479) ? 1 : 0 | (v_counter == 19'd9599);
// Si la figura de la pantalla se mueve raro, intente quitando (v_counter == 19'd9599)
assign enable_row_counter = reset_h_counter;
assign column = (h_counter > 10'd143 && h_counter < 10'd623) ? (h_counter - 10'd143) : 0;
assign h_sync = (h_counter < 10'd95) ? 0 : 1;
assign v_sync = (v_counter < 19'd1599) ? 0 : 1;

always @ (posedge clock)
	oRGB <= 3'b010;

endmodule