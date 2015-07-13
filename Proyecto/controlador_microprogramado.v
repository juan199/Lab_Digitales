// Laboratorio de Circuitos Digitales
// Cornejo, Rincón, Sánchez
// Proyecto Final 

// --->>> Module controlador microprogramado (Based on controlador.v) <<<---

module incrementador (salida, entrada);
    parameter anchopalabra = 1; 

    input [anchopalabra-1:0] entrada;
    output [anchopalabra-1:0] salida;

    assign salida = entrada + 1;

endmodule

module memoria (datos, direccion);
    parameter	anchopalabra = 32, tamanomemoria = 100;

    output  [anchopalabra-1:0]    datos;
    input   [4:0]               direccion;
    
    reg [anchopalabra-1:0]    datos;
    reg [anchopalabra-1:0]    memoria_lectura [0:tamanomemoria-1];

    initial
	$readmemb ("programa.dat", memoria_lectura);

    always @(direccion)
	datos = memoria_lectura[direccion];

endmodule

module multiplexor (salida, seleccion, entradas);
    parameter	numentradas = 1, numselecciones = 1;

    output  salida;
    input   [ numselecciones-1:0]	seleccion;
    input   [numentradas-1:0]	entradas;

    assign salida = entradas[seleccion];

endmodule

module selector (salida, entrada0, entrada1, seleccion);
    parameter anchopalabra = 1;

    output [anchopalabra-1:0] salida;
    input  [anchopalabra-1:0] entrada0, entrada1;
    input		    seleccion;

    reg	   [anchopalabra-1:0] salida;
    
always @(entrada0 or entrada1 or seleccion)
begin
    case (seleccion)
	1'b0:	salida = entrada0;
	1'b1:	salida = entrada1;
    endcase
end

endmodule

module registro (salida, entrada, reloj);
    parameter	anchoregistro = 1;

    output  [anchoregistro-1:0]	salida;
    input   [anchoregistro-1:0]	entrada;
    input			reloj;

    reg	[anchoregistro-1:0]   salida;

    always @(negedge reloj)
	salida = entrada;

endmodule


//Hasta acá listo...

module controlador (estado, go, mult_div, neg1, neg2, AEScero, A0EScero, CNOcero, neg1IGUALneg2, contNOquince, reloj, reset, neg_reg_C_MSB);
    output estado;
          
    input go, mult_div, neg1, neg2, AEScero, A0EScero, CNOcero, neg1IGUALneg2, contNOquince, neg_reg_C_MSB;	// Jump conditions (OJO!!!)
    input reloj, reset;		// Fixed Inputs 
    
	//Salidas del registro de Instrucción
    wire [26:0] instruccion, prox_instruccion;
    wire [4:0]	dir_salto = instruccion[4:0];		// Dirección de salto
    wire [3:0]	selector_cond = instruccion[26:23];
	
	
    wire [4:0]	prox_direccion, prox_direccion_reset, dir_presente, dir_presente_inc;
    wire [17:0] estado;
    // Definicion del vector condiciones[15:0]
    wire [15:0]	condiciones;
    assign  condiciones = {3'b111,neg_reg_C_MSB,contNOquince,neg1IGUALneg2,CNOcero,A0EScero,AEScero,~neg2,~neg1,mult_div,go,~go,1'b1,1'b0};

    // Definicion del vector de salida estado
    assign estado = instruccion[22:5];

    // Conexion de la salida del selector hacia el bus de direcciones de la
    // memoria de programa. AND para el reset (bit a bit)
    and g0 (prox_direccion_reset[0], prox_direccion[0], reset),
	g1 (prox_direccion_reset[1], prox_direccion[1], reset),
	g2 (prox_direccion_reset[2], prox_direccion[2], reset),
	g3 (prox_direccion_reset[3], prox_direccion[3], reset),
	g4 (prox_direccion_reset[4], prox_direccion[4], reset);
 
    // Se instancia memoria con microprograma, anchopalabra = 27 bits,
    // tamanomemoria = 31 palabras:

    ///////////////////////////////////////////////////////////////////
    memoria #(27, 32) programa (prox_instruccion, prox_direccion_reset);

    // Se instancia un registro de instruccion
    registro #(27) registro_instruccion (instruccion, prox_instruccion, reloj);

    // Se instancia el multiplexor que selecciona la condicion segun la
    // instruccion presente. Condiciones es un vector de ancho [15:0], pero
    // solo los primeros 12 bits son utilizados
    multiplexor #(16, 4) mux_condiciones (cond_verdadera, selector_cond, condiciones);
    
    // Instanciacion del registro de direccion de microinstruccion
    registro #(4) reg_PC (dir_presente, prox_direccion_reset, reloj);

    // Instaciacion del incrementador de direcciones
    incrementador #(5) inc_PC (dir_presente_inc, dir_presente);

    // Se instancia el selector que escoge la fuente de la direccion de la
    // proxima instruccion, controlado por el estado de la condicion
    // seleccionada. El campo de direccion de salto es de 5 bits
    selector #(5) selector_prox_instr (prox_direccion, dir_presente_inc, dir_salto, cond_verdadera);

endmodule