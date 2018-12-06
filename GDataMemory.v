module DataMemory(
	input Reset,
	input [31:0] i_A, 
	input i_WE, 
	output reg [31:0] o_D, 
	input [31:0] i_D, 
	input Clk
);

reg [31:0] Registers [31:0];

always @* begin	
	if (~i_WE) 
		o_D = Registers[i_A];
	else o_D = 32'b0;
end

integer i;

always @(posedge Clk, negedge Reset) begin
	if (~Reset) begin
	for(i = 0;i<32;i=i+1) 
			Registers[i] = 32'h00000000;
	end else if (i_WE) 
		Registers[i_A] <= i_D;
end

endmodule

module ADecoder(
	input MemWrite,
	input [31:0] Addres, 
	output WEM, 
	output WE1,
	output WE2,
	output RDSEL
);

reg [2:0]DCout = 3'b000;

always @*
	casez (Addres[5:0])
		6'b0?????: DCout = 3'b001;
		6'b100000: DCout = 3'b010;
		6'b100001: DCout = 3'b100;
		default: DCout = 3'b000;
endcase

assign WEM = DCout[0] && MemWrite;
assign WE1 = DCout[1] && MemWrite;
assign WE2 = DCout[2] && MemWrite;
assign RDSEL = ~DCout[0];

endmodule

module GDataMemory(
	input Reset,
	input [31:0] i_A, 
	input i_WE, 
	output [31:0] o_D, 
	input [31:0] i_D, 
	input Clk
);

wire WE1;
wire WE2;
wire WEM;
wire RDsel;
wire [31:0] oM, oG;
DataMemory GDM(
	.Reset(Reset),
	.i_A(i_A),
	.i_WE(WEM), 
	.o_D(oM),
	.i_D(i_D), 
	.Clk(Clk)
);

GPIO GPIO(
	.i_DD(i_D),
	.i_Clk(Clk),
	.IO(),
	.i_rst_n(Reset),
	.i_WER(WE1),
	.i_WEO(WE2),
	.o_DIN(oG)
);

ADecoder ADecoder(
	.MemWrite(i_WE),
	.Addres(i_A), 
	.WEM(WEM), 
	.WE1(WE1),
	.WE2(WE2),
	.RDSEL(RDsel)
);

Mux2 MMMux(
	.i_way(RDsel),
	.i_mux0(oM), 
	.i_mux1(oG), 
	.o_mux(o_D)
);

endmodule

