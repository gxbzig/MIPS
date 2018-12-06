
module RegisterM (
	input Reset,
	input i_Clk,
	input [31:0] i_ReadData,
	input [31:0] i_ALUout,
	input [4:0] i_WriteReg,
	input i_RegWrite, i_MemtoReg,
	output reg [31:0] o_ReadData,
	output reg [31:0] o_ALUout,
	output reg [4:0] o_WriteReg,
	output reg o_RegWrite, o_MemtoReg
);

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_ReadData <= 0;
	else o_ReadData <= i_ReadData;
end
always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_ALUout <= 0;
	else o_ALUout <= i_ALUout;
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
endmodule
