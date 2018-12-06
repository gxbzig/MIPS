
module RegisterE (
	input Reset,
	input i_Clk,
	input [31:0] i_ALUout,
	input [31:0] i_WriteData,
	input [4:0] i_WriteReg,
	input i_RegWrite, i_MemtoReg, i_MemWrite,
	output reg [31:0] o_ALUout,
	output reg [31:0] o_WriteData,
	output reg [4:0] o_WriteReg,
	output reg o_RegWrite, o_MemtoReg, o_MemWrite
);

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_ALUout <= 0;
	else o_ALUout <= i_ALUout;
end
always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_WriteData <= 0;
	else o_WriteData <= i_WriteData;
end
always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_WriteReg <= 0;
	else o_WriteReg <= i_WriteReg;
end
always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_RegWrite <= 0;
	else o_RegWrite <= i_RegWrite;
end
always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_MemtoReg <= 0;
	else o_MemtoReg <= i_MemtoReg;
end
always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_MemWrite <= 0;
	else o_MemWrite <= i_MemWrite;
end
endmodule
