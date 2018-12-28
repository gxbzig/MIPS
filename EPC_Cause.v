module EPC (
	input [31:0] i_data,
	input EPCWrite,
	input Reset,
	input Clk,
	output reg [31:0] o_data
);

always @(posedge Clk, negedge Reset) begin
	if (~Reset) begin
		o_data <= 32'b0;
	end
	else if (EPCWrite) begin
			o_data <= i_data;
		end
end
	
endmodule

module Cause (
	input [31:0] i_data,
	input CWrite,
	input Reset,
	input Clk,
	output reg [31:0] o_data
);

always @(posedge Clk, negedge Reset) begin
	if (~Reset) begin
		o_data <= 32'b0;
	end
	else if (CWrite) begin
			o_data <= i_data;
		end
end
	
endmodule

module Status (
	input [31:0] i_data,
	input SWrite,
	input Reset,
	input Clk,
	input srst,
	output reg [31:0] o_data
);

always @(posedge Clk, negedge Reset) begin
	if (~Reset) begin
		o_data <= 32'b0;
	end
	else if (srst) o_data <= 32'b0;
	else if (SWrite) begin
			o_data <= i_data;
		end
end
	
endmodule
