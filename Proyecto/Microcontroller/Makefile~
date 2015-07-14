all: MEM

MEM: Memory.v ../RAM.v ../Definitions.v ../Collaterals.v
	iverilog -o MEM.test ../Collaterals.v ../Definitions.v ../RAM.v Memory.v
