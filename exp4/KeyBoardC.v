module KeyBoard_Controller(
	input clk,
	input data,
	input reset,
	output reg [7:0] Parallel_data,
	output reg Sent
);

reg [10:0] data_recieved; 
reg [4:0] cont;

always@(reset)
begin
cont=0;
Sent=0;
end

always@(negedge clk)
begin
	Sent=0;
	data_recieved = data_recieved<<1;
	data_recieved[0]=data;
	cont=cont+1;
end

always@(*)
begin 
	if(cont==11)
	begin
	cont=0;
	Sent=1;
	Parallel_data=data_recieved[9:2];
	end
end


endmodule
