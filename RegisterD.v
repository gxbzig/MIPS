
module RegisterD (
	input Reset,
	input WE_n,
	input i_Clk,
	input [31:0]i_RD1,
	input [31:0]i_RD2,
	input [31:0] i_SignImm,
	input i_ALUSrc, i_RegDst, i_RegWrite, i_MemWrite, 
	input [1:0]i_MemtoReg,
	input [3:0] i_ALUCtrl,
	input [25:0] i_PCImm,
	input CLR,
	output reg [31:0]o_RD1,
	output reg [31:0]o_RD2,
	output reg [31:0] o_SignImm,
	output reg o_ALUSrc, o_RegDst, o_RegWrite, o_MemWrite, 
	output reg [1:0]o_MemtoReg,
	output reg [3:0] o_ALUCtrl,
	output reg [25:0] o_PCImm
);

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_RD1 <= 0;
	else if (~WE_n) begin
	if (CLR) o_RD1 <= 0;
		else o_RD1 <= i_RD1;
	end
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_RD2 <= 0;
	else if (~WE_n) begin
	if (CLR) o_RD2 <= 0;
		else o_RD2 <= i_RD2;
	end
end 

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_SignImm <= 0;
	else if (~WE_n) begin 
	if (CLR) o_SignImm <= 0;
		else o_SignImm <= i_SignImm;
	end
end 
 
always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_ALUSrc <= 0;
	else if (~WE_n) begin
	if (CLR) o_ALUSrc <= 0;
		else o_ALUSrc <= i_ALUSrc;
	end
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_ALUCtrl <= 0;
	else if (~WE_n) begin
	if (CLR) o_ALUCtrl <= 0;
		else o_ALUCtrl <= i_ALUCtrl;
	end
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_RegDst <= 0;
	else if (~WE_n) begin
	if (CLR) o_RegDst <= 0;
		else o_RegDst <= i_RegDst;
	end
end 

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_RegWrite <= 0;
	else if (~WE_n) begin
	if (CLR) o_RegWrite <= 0;
		else o_RegWrite <= i_RegWrite;
	end
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_MemWrite <= 0;
	else if (~WE_n) begin
	if (CLR) o_MemWrite <= 0;
		else o_MemWrite <= i_MemWrite;
	end
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_MemtoReg <= 0;
	else if (~WE_n) begin
	if (CLR) o_MemtoReg <= 0;
		else o_MemtoReg <= i_MemtoReg;
	end
end

always @(posedge i_Clk, negedge Reset) begin
   if (~Reset) o_PCImm <= 0;
	else if (~WE_n) begin
	if (CLR) o_PCImm <= 0;
		else o_PCImm <= i_PCImm;
	end
end



endmodule
