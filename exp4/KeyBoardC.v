`timescale 1ns / 1ps

`define RESET            0
`define STORE	          1
`define CHECK            2


module KeyBoard_Controller(
	input KB_Clock,
	input Data,
	input Reset,
	output wire [7:0] Parallel_data,
	output reg Ready
);

reg [10:0] Data_store;
reg [1:0] CurrentState;
reg [1:0] NextState;
reg [3:0] Counter;
reg Counter_Reset;
wire parity;


assign parity = Data_store[9];
assign Parallel_data = Data_store[9:2];


always @ (negedge KB_Clock)
begin
	if(Counter_Reset)
		Counter = 4'd10;
	else
		Counter = Counter - 1;
	
	if(Reset)
		begin
			CurrentState = `RESET;
		end
	else
		CurrentState = NextState;
	
	Data_store[Counter]=Data;
end


always @ (*)
begin
case(CurrentState)
	`RESET:
		begin	
		Counter_Reset= 4'b1;
		Ready=1'b0;	
		NextState = `STORE;
		end
		
	`STORE:
	   begin
		if(Counter == 4'd10)
			begin
				Ready=1'b1;
				Counter_Reset= 4'b1;
				NextState = `CHECK;
			end
		else
			begin
				Ready=1'b0;
				Counter_Reset= 4'b0;
				NextState = `STORE;
			end   
	   end
	   
	`CHECK:
		begin
			if(parity & Parallel_data!= 11'hF0)
				begin
					Ready=1'b1;
				end
			else
				begin
					Ready=1'b0;
				end
				
			Counter_Reset= 4'b0;		
			NextState     = `STORE;
	
		end
		
	default:
	begin	
		Counter_Reset= 4'b1;
		Ready = 1'b0;
		NextState    = `RESET;
	end	
endcase
end

endmodule
