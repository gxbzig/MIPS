module FPGAMIPS(
	input CLOCK_50,
	input [3:0]KEY
);

wire Clk = CLOCK_50;

MIPS MIPS(
	.Clk(Clk),
	.Reset(~KEY[1]) // KEY[1]
);

endmodule

