`include "adder.v"

module IMUL16 # (parameter NUM_BITS = 2)
(

input wire [NUM_BITS-1:0] A,
input wire [NUM_BITS-1:0] B,
output wire [2*NUM_BITS-1:0] oResult

);

wire [NUM_BITS-1:0] wCarry  [NUM_BITS-2:0]; // matriz definida para conectar los carry's
wire[NUM_BITS-1:0] Temp_results [NUM_BITS-1:0]; // matriz definida para conectar los resultados de los sumadores y los carry's de los ultimos digitos en la ultima columna.
genvar CurrentRow, CurrentCol; // iteradores de columnas y filas

assign oResult[0]=A[0]&B[0]; // se asigna el primer digito de la multiplicacion ya que es fijo
assign Temp_results[0][NUM_BITS-1]=1'b0; // se asigna un 0 al ultimo sumador de la primera fila siempre

generate
	for(CurrentRow=0; CurrentRow<NUM_BITS-1;CurrentRow=CurrentRow+1)
	begin:MULTIROW
		
		assign wCarry[CurrentRow][0]=0;

		for(CurrentCol=0; CurrentCol<NUM_BITS;CurrentCol=CurrentCol+1)
			begin:MULTICOL
				// Se guardan en Temp_results los primeros numeros en entrar a la primera fila de sumadores
				if(CurrentRow==0 & CurrentCol<NUM_BITS-1)
				begin
					assign Temp_results[0][CurrentCol]=A[CurrentCol+1]&B[0];

				end

				// Caso de los sumadores intermedios:
					//Se instancian de la forma que tomen sus sumandos de Temp_Result (previos)
					//y se guardan sus resultados tanto en Temp_Result como en wCarry para cablear el resto de 
					// sumadores y niveles.
				if(CurrentCol<(NUM_BITS-1))
				begin
					if(CurrentCol==0)
					begin
						adder Circuit_Adders(
							.a(A[0]&B[CurrentRow+1]),
							.b(Temp_results[CurrentRow][0]),
							.s(oResult[CurrentRow+1]),
							.ci(wCarry[ CurrentRow ][ 0 ] ),
							.co(wCarry[ CurrentRow ][ 1 ] )	
						);
					end
					else 
					begin
					    	adder Circuit_Adders(
							.a(A[CurrentCol]&B[CurrentRow+1]),
							.b(Temp_results[CurrentRow][CurrentCol]),
							.s(Temp_results[CurrentRow+1][CurrentCol-1]),
							.ci(wCarry[ CurrentRow ][ CurrentCol ] ),
							.co(wCarry[ CurrentRow ][ CurrentCol + 1])	
						);
					end	
				end
		
				//Caso del ultimo bloque sumador por fila:
					// Este es especial ya que su carry out se guarda en los Tem_Results para poder
					// sumarselo al ultimo bloque del siguiente nivel.
				if(CurrentCol==(NUM_BITS-1) & CurrentRow<NUM_BITS-2) 
				begin
					    adder Circuit_Adders(
						.a(A[CurrentCol]&B[CurrentRow+1]),
						.b(Temp_results[CurrentRow][CurrentCol]),
						.s(Temp_results[CurrentRow+1][CurrentCol-1]),
						.ci(wCarry[ CurrentRow ][ CurrentCol ] ),
						.co(Temp_results[ CurrentRow + 1 ][ CurrentCol])	
						);
				end
				if(CurrentRow==NUM_BITS-2)
				begin
					assign oResult[CurrentCol+NUM_BITS]=Temp_results[CurrentRow+1][CurrentCol];
				end
			end		
		end 
		
endgenerate


endmodule