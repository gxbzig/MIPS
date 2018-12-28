
module RegisterF (
	input Reset,
	input CLR,
	input i_Clk,
	input [31:0] i_Ins,
	input [29:0] i_PC4,
	input WE_n,
 	output reg [31:0] o_Ins,
	output reg [29:0] o_PC4
);

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset)  o_PC4 <= 0 ;
	else if(~WE_n) begin 
		o_PC4 <= i_PC4;
		if (CLR)  o_PC4 <= 0 ;
	end
end

always @(posedge i_Clk, negedge Reset) begin
	if (~Reset) o_Ins <= 0;
	else if(~WE_n) begin 
		o_Ins <= i_Ins;
		if (CLR)  o_Ins <= 0;
	end
end
endmodule
