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
module MUX4X1 #(parameter SIZE=32) 
(
	input wire[SIZE-1:0] iInput0,
	input wire[SIZE-1:0] iInput1,
	input wire[SIZE-1:0] iInput2,
	input wire[SIZE-1:0] iInput3,
	input wire[1:0] iSelect,
	output reg[SIZE-1:0] oOutput	
);

always @(*) begin
case (iSelect)
2'd0: oOutput=iInput0;
2'd1: oOutput=iInput1;
2'd2: oOutput=iInput2;
2'd3: oOutput=iInput3;
endcase

end
endmodule

