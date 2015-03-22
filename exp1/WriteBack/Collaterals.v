`timescale 1ns / 1ps
//------------------------------------------------
module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;
			
		end			
  end

endmodule
//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);
	

always @ (posedge Clock) 
begin
	if ( Reset )
		Q <= 0;
	else
	begin	
		if (Enable) 
			Q <= D; 
	end	
 
end//always

endmodule


//----------------------------------------------------------------------


