module IMUL2
(input wire [15:0] iSourceData0, iSourceData1,
 output reg [31:0]   oResult
);

wire [31:0] oMux1, oMux2, oMux3, oMux4, oMux5, oMux6,oMux7,oMux8;
wire [31:0]cero, uno, dos, tres;

assign cero = 0;
assign uno = iSourceData0;
assign dos = iSourceData0<<1;
assign tres = (iSourceData0<<1) + iSourceData0;


MUX4X1 Mux1(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[1], iSourceData1[0]}),
.oOutput(oMux1)
);

MUX4X1 Mux2(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[3], iSourceData1[2]}),
.oOutput(oMux2)
);

MUX4X1 Mux3(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[5], iSourceData1[4]}),
.oOutput(oMux3)
);

MUX4X1 Mux4(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[7], iSourceData1[6]}),
.oOutput(oMux4)
);

MUX4X1 Mux5(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[9], iSourceData1[8]}),
.oOutput(oMux5)
);

MUX4X1 Mux6(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[11], iSourceData1[10]}),
.oOutput(oMux6)
);

MUX4X1 Mux7(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[13], iSourceData1[12]}),
.oOutput(oMux7)
);

MUX4X1 Mux8(
.iInput0(cero),
.iInput1(uno),
.iInput2(dos),
.iInput3(tres),
.iSelect({iSourceData1[15], iSourceData1[14]}),
.oOutput(oMux8)
);

always @(*) begin
oResult = oMux1 +(oMux2<<2)+ (oMux3<<4) + (oMux4<<6) + (oMux5<<8) + (oMux6<<10) + (oMux7<<12) +(oMux8<<14);
end
endmodule