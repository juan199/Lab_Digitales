module adder(
input a,
input b,
input ci,
output s,
output co
);

    wire a, b, ci;
    reg s, co;
	
	always@(*)
	begin
    {co, s} = a + b + ci;
	end 
	
endmodule
