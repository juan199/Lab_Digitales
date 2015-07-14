`timescale 1ns / 1ps

module KeyB_test;

	// Inputs
	reg Clock;
	reg Data;
	reg Reset;
	wire sent;
	wire [7:0] Result;
	
	
	reg send_flag;


	KeyBoard_Controller uut (
		.KB_Clock(Clock),
		.Data(Data), 
		.Reset(Reset),
		.Parallel_data(Result),
		.Ready(sent)
	);
	
	always
	begin
		#107 send_flag<= ! send_flag;
	end
	
	always@(posedge send_flag)
	begin
		while(send_flag)
		begin 
			#5  Clock <=  ! Clock;
		end
	end
	
	always @(negedge Clock)
	begin
		#7 Data <= $random;
	end
	

	initial begin
		// Initialize Inputs
		
		Clock = 1;
		Data = 0;
		send_flag=0;
		Reset = 0;
		
		// First Reset
		#107 Reset = 1;
		#107 Reset = 0;
	end
      
endmodule

