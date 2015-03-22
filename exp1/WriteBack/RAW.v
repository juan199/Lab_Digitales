module RAW (
input wire [15:0] SourceD1,
input wire [15:0] SourceD2,
input wire [7:0] Source_Add1,
input wire [7:0] Source_Add2,
input wire [7:0] Result_Add,
input wire [15:0] Result_Data,
output reg [15:0] Data1,
output reg [15:0] Data2
);

always @(Source_Add1 or Source_Add2)
	begin
		if(Result_Add==Source_Add1)
		begin
			Data1 = Result_Data;
			Data2 = SourceD2;
		end
		
		else if(Result_Add==Source_Add2)
		begin
			Data2 = Result_Data;
			Data1 = SourceD1;
		end		
		
		else
		begin
			Data2 = SourceD2;
			Data1 = SourceD1;			
		end

	end

endmodule
