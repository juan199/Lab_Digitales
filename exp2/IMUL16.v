module IMUL16 # (parameter NUM_BITS = 16)
(

input wire [NUM_BITS-1:0] iA,
input wire [NUM_BITS-1:0] iB,
output wire [2*NUM_BITS:0] oResult,

);

wire [NUM_BITS-1:0] wCarry [NUM_BITS-1:0]; // matriz definida para conectar los carry's
wire [NUM_BITS-1:0] Temp_results [NUM_BITS-1:0]; // matriz definida para conectar los resultados de los sumadores y los carry's de los ultimos digitos en la ultima columna.
genvar CurrentRow, CurrentCol; // iteradores de columnas y filas

assign oResult[0]=iA[0]&iB[0]; // se asigna el primer digito de la multiplicacion ya que es fijo
assign Temp_results[0][NUM_BITS-1]=0; // se asigna un 0 al ultimo sumador de la primera fila siempre
generate
	for(CurrentRow=0 CurrentRow<NUM_BITS;CurrentRow=CurrentRow+1)
	begin
		assign wCarry[CurrentRow][0];

		for(CurrentCol=0 CurrentCol<NUM_BITS;CurrentCol=CurrentCol+1)
			begin
				// Se guardan en Temp_results los primeros numeros en entrar a la primera fila de sumadores
				if(CurrentRow==0 && CurrentCol<NUM_BITS-1)
				begin
					Temp_results[0][CurrentCol]=A[CurrentCol+1]&B[0];

				end

				// Caso de los sumadores intermedios:
					//Se instancian de al forma que tomen sus sumandos de Temp_Result (previos)
					//y se guardan sus resultados tanto en Tem_Result como en wCarry para cablear el resto de 
					// sumadores y niveles.
				if(CurrentCol<NUM_BITS-1 && CurrentRow<NUM_BITS-1)
				begin
					if(CurrentCols!=0)
					begin
						adder Circuit_Adders(
							a.(A[CurrentCol]&B[CurrentRow+1]),
							b.(Temp_Results[CurrentRow][CurrentCol]),
							s.(Temp_Results[CurrentRow+1][CurrentCol]),
							ci.(wCarry[ CurrentRow ][ CurrentCol ] ),
							co.(wCarry[ CurrentRow ][ CurrentCol + 1])	
						);
					end
					else // Caso de los primeros sumadores para cada fila:
						// En estos se cambian la salida para que se guarde de una vez en el resultado
					begin
					    	adder Circuit_Adders(
							a.(A[CurrentCol]&B[CurrentRow+1]),
							b.(Temp_Results[CurrentRow][CurrentCol]),
							s.(oResult[CurrentRow+1]),
							ci.(wCarry[ CurrentRow ][ CurrentCol ] ),
							co.(wCarry[ CurrentRow ][ CurrentCol + 1])	
						);
					end	
				end
				
				//Caso del ultimo bloque sumador por fila:
					// Este es especial ya que su carry out se guarda en los Tem_Results para poder
					// sumarselo al ultimo bloque del siguiente nivel.
				if(CurrentCol==NUM_BITS-1 && CurrentRow<NUM_BITS-1) 
				begin
					adder Circuit_Adders(
						a.(A[CurrentCol]&B[CurrentRow+1]),
						b.(Temp_Results[CurrentRow][NUM_BITS-1]),
						s.(Temp_Results[CurrentRow][NUM_BITS-1]),
						ci.(wCarry[ CurrentRow ][ NUM_BITS-1 ] ),
						co.(Temp_Results[ CurrentRow+1 ][ NUM_BITS-1])	
					);
				end

				// El ultimo if es para asignar los resultados finales a oResult
				
				if(CurrentRow==NUM_BITS-1)
				begin
					oResult[CurrentCol+NUM_BITS]=Temp_Results[NUM_BITS-1][CurrentRow];
				end
				

			end


		end

	end	
endgenerate
endmodule


