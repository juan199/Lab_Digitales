module adder(
input wire a,
input wire b,
input wire ci,
output reg s,
output reg co
);
	
	always @ (*)
		{co, s} = a + b + ci;

endmodule

module mult(
			input wire [3:0] opA,
			input wire [3:0] opB,
			output wire [7:0] result
			);
			
	wire a [11:0];
	wire b [11:0];
	wire c [11:0];
	wire s [11:0];
		
	assign result = {c[11] ,s[11], s[10], s[9], s[8], s[4], s[0], (opA[0] & opB[0])};
		
	adder add0( .a(opA[0] & opB[1]), .b(opA[1] & opB[0]), .ci(1'b0), .s(s[0]), .co(c[0]) );
	adder add1( .a(opA[2] & opB[0]), .b(opA[1] & opB[1]), .ci(c[0]), .s(s[1]), .co(c[1]) );
	adder add2( .a(opA[3] & opB[0]), .b(opA[2] & opB[1]), .ci(c[1]), .s(s[2]), .co(c[2]) );
	adder add3( .a(1'b0), .b(opA[3] & opB[1]), .ci(c[2]), .s(s[3]), .co(c[3]) );
	adder add4( .a(s[1]), .b(opA[0] & opB[2]), .ci(1'b0), .s(s[4]), .co(c[4]) );
	adder add5( .a(s[2]), .b(opA[1] & opB[2]), .ci(c[4]), .s(s[5]), .co(c[5]) );
	adder add6( .a(s[3]), .b(opA[2] & opB[2]), .ci(c[5]), .s(s[6]), .co(c[6]) );
	adder add7( .a(c[3]), .b(opA[3] & opB[2]), .ci(c[6]), .s(s[7]), .co(c[7]) );
	adder add8( .a(s[5]), .b(opA[0] & opB[3]), .ci(1'b0), .s(s[8]), .co(c[8]) );
	adder add9( .a(s[6]), .b(opA[1] & opB[3]), .ci(c[8]), .s(s[9]), .co(c[9]) );
	adder add10( .a(s[7]), .b(opA[2] & opB[3]), .ci(c[9]), .s(s[10]), .co(c[10]) );
	adder add11( .a(c[7]), .b(opA[3] & opB[3]), .ci(c[10]), .s(s[11]), .co(c[11]) );	
		
endmodule			
