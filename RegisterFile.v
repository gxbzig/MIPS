
module RegisterFile(A1, A2, A3, WD, WE, Clk, RD1, RD2);

	
input [4:0] A1,A2,A3;
input [31:0] WD;
input WE,Clk;
	
output reg [31:0] RD1,RD2;
	
	
reg [31:0] Registers [31:0];
	
initial begin : RRESET
	integer i;
	for (i=0; i<32; i=i+1) begin
		Registers[i] <= 32'h00000000;
	end
end
	
always @(negedge Clk) begin
	if (WE) begin
		if (~|A3) Registers[A3] <= Registers[A3];
		else Registers[A3] <= WD;
	end
end
	
always @(*) begin 
	RD1 = Registers[A1];
	RD2 = Registers[A2];
end

endmodule
