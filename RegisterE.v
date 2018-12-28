
module RegisterE (
	input Reset,
	input WE_n,
	input i_Clk,
	input [31:0] i_ALUout,
	input [31:0] i_WriteData,
	input [4:0] i_WriteReg,
	input i_RegWrite, i_MemWrite,
	input [1:0] i_MemtoReg,
	input [4:0] i_Rt,
	output reg [31:0] o_ALUout,
	output reg [31:0] o_WriteData,
	output reg [4:0] o_WriteReg,
	output reg o_RegWrite, o_MemWrite,
	output reg [1:0] o_MemtoReg,
	output reg [4:0] o_Rt
);

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_ALUout <= 0;
	else if (~WE_n) o_ALUout <= i_ALUout;
end

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_WriteData <= 0;
	else if (~WE_n) o_WriteData <= i_WriteData;
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
	if (~Reset) o_MemWrite <= 0;
	else if (~WE_n) o_MemWrite <= i_MemWrite;
end

always @(posedge i_Clk, negedge Reset) begin 
	if (~Reset) o_Rt <= 0;
	else if (~WE_n) o_Rt <= i_Rt;
end

endmodule
