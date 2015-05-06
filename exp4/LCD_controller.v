`timescale 1ns / 1ps

`define RESET            0
`define RESET_WAIT       1
`define INIT_INSTRUCTION 2
`define INIT_WAIT        3
`define DATA_WAIT        4
`define DATA_WRITE       5
`define DATA_WRITE_WAIT  6

module LCD_controler(
	input wire clk,
	input wire [3:0] iLCD_data,
	input wire iLCD_reset,
	input wire iLCD_writeEN,
	output reg oLCD_response,
	output reg [3:0] oLCD_Data,
	output reg oLCD_Enabled,
	output reg oLCD_RegisterSelect, 
	output wire oLCD_ReadWrite,
	output wire oLCD_StrataFlashControl
);

assign oLCD_StrataFlashControl = 1;
assign oLCD_ReadWrite = 0;

reg [7:0] CurrentState;
reg [7:0] NextState;
reg [31:0] TimeCount;
reg TimeCountReset;
reg [7:0] init_ptr;
reg [3:0] instruction;

always @ (posedge clk)
begin
	if(iLCD_reset)
		CurrentState = `RESET;
	else
		begin
		if(TimeCountReset)
			TimeCount = 32'b0;
		else
			TimeCount = TimeCount + 1;
		end
	CurrentState = NextState;		
end

always @ (*)
	case(CurrentState)
	`RESET:
		begin
		oLCD_response = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_Enabled = 1'b0;
		oLCD_RegisterSelect = 1'b0;
		init_ptr = 3'b0;
		TimeCountReset = 1'b1;
		
		NextState = `RESET_WAIT;
		end
		
	`RESET_WAIT:
	   begin
		oLCD_response = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_Enabled = 1'b0;
		oLCD_RegisterSelect = 1'b0;
		init_ptr = init_ptr;

		if(TimeCount > 32'd750000)
			begin
			TimeCountReset = 1'b1;
			NextState = `INIT_INSTRUCTION;
			end
		else
			begin
			TimeCountReset = 1'b0;
			NextState = `RESET_WAIT;
			end
	   end
		
	`INIT_INSTRUCTION:
		begin
		oLCD_response = 1'b0;
		oLCD_RegisterSelect = 1'b0;
		init_ptr = init_ptr;

		if(TimeCount > 32'd12)
			begin
			oLCD_Data = 4'h0;
			oLCD_Enabled = 1'b0;			
			TimeCountReset = 1'b1;
			NextState = `INIT_WAIT;
			end
		else
			begin
			oLCD_Data = instruction;
			oLCD_Enabled = 1'b1;			
			TimeCountReset = 1'b0;
			NextState = `INIT_INSTRUCTION;
			end
		end
			
	`INIT_WAIT:
		if(TimeCount > 32'd250000)
			// se acabaron las instrucciones
			if(init_ptr == 8'd11)
				begin
				oLCD_response = 1'b1;
				oLCD_Data = 4'h0;
				oLCD_Enabled = 1'b0;
				oLCD_RegisterSelect = 1'b0;
				
				TimeCountReset = 1'b1;
				NextState = `DATA_WAIT;
				init_ptr = init_ptr;
				end
			else
				begin
				oLCD_response = 1'b0;
				oLCD_Data = 4'h0;
				oLCD_Enabled = 1'b0;
				oLCD_RegisterSelect = 1'b0;
				
				TimeCountReset = 1'b1;
				NextState = `INIT_INSTRUCTION;
				init_ptr = init_ptr + 1;
				end
		else
			begin
			oLCD_response = 1'b0;
			oLCD_Data = 4'h0;
			oLCD_Enabled = 1'b0;
			oLCD_RegisterSelect = 1'b0;
				
			TimeCountReset = 1'b0;
			init_ptr = init_ptr;
			NextState = `INIT_WAIT;
			end
	`DATA_WAIT:
		begin
		oLCD_response = 1'b1;
		oLCD_Enabled = 1'b0;
		oLCD_RegisterSelect = 1'b0;
		TimeCountReset = 1'b1;
		init_ptr = init_ptr;
		if(iLCD_writeEN)
			begin
			NextState = `DATA_WRITE;
			oLCD_Data = iLCD_data;
			end
		else
			begin
			oLCD_Data = 4'b0;
			NextState = `DATA_WAIT;
			end
		end
	`DATA_WRITE:
		begin
		oLCD_response = 1'b0;
		oLCD_Enabled = 1'b1;
		oLCD_RegisterSelect = 1'b1;
		init_ptr = init_ptr;
		if(TimeCount > 32'd50)	
			begin
			oLCD_Data = 4'b0;
			NextState = `DATA_WRITE_WAIT;
			TimeCountReset = 1'b1;
			end
		else
			begin
			oLCD_Data = oLCD_Data;
			NextState = `DATA_WRITE;
			TimeCountReset = 1'b0;
			end
		end
	`DATA_WRITE_WAIT:
		begin
			oLCD_Data = 4'b0;
			oLCD_Enabled = 1'b0;
			oLCD_RegisterSelect = 1'b0;
			init_ptr = init_ptr;
			if(TimeCount > 32'd2000)
				begin
				oLCD_response = 1'b1;
				NextState = `DATA_WAIT;
				TimeCountReset = 1'b1;
				end
			else
				begin
				oLCD_response = 1'b0;
				NextState = `DATA_WRITE_WAIT;
				TimeCountReset = 1'b0;
				end
		end		
	default:
		begin
		oLCD_response = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_Enabled = 1'b0;
		oLCD_RegisterSelect = 1'b0;
		NextState = `RESET; 
		TimeCountReset = 1'b1;
		init_ptr = 1'b0;
		end
	endcase	

always @ (init_ptr)
	case(init_ptr)
		// init sequence 
		0:	instruction = 4'h3;
		1: instruction	= 4'h3;
		2: instruction = 4'h3;
		3: instruction = 4'h2;
		// Function_set 0x28
		4: instruction = 4'h2;
		5: instruction = 4'h8;
		//Entry_mode 0x06
		6: instruction = 4'h0;
		7: instruction = 4'h6;
		//Display On
		8: instruction = 4'h0;
		9: instruction = 4'hC;
		//Clear Display
		10: instruction = 4'h0;
		11: instruction = 4'h1;
		default: instruction = 4'h0;		
	endcase

endmodule			