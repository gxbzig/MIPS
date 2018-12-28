
module RegisterM (
	input Reset,
	input WE_n,
	input i_Clk,
	input [31:0] i_ReadData,
	input [31:0] i_ALUout,
	input [4:0] i_WriteReg,
	input i_RegWrite, 
	input [1:0] i_MemtoReg,
	input [4:0] i_Rt,
	output reg [31:0] o_ReadData,
	output reg [31:0] o_ALUout,
	output reg [4:0] o_WriteReg,
	output reg o_RegWrite, 
	output reg [1:0] o_MemtoReg,
	output reg [4:0] o_Rt
);

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_ReadData <= 0;
	else if (~WE_n) o_ReadData <= i_ReadData;
end

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_ALUout <= 0;
	else if (~WE_n) o_ALUout <= i_ALUout;
end

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_WriteReg <= 0;
	else if (~WE_n) o_WriteReg <= i_WriteReg;
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_RegWrite <= 0;
	else if (~WE_n) o_RegWrite <= i_RegWrite;
end

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_MemtoReg <= 0;
	else if (~WE_n) o_MemtoReg <= i_MemtoReg;
end

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_Rt <= 0;
	else if (~WE_n) o_Rt <= i_Rt;
end
endmodule
