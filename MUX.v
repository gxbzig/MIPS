module Mux4
(
	input [1:0] i_way,
	input [31:0] i_mux0, i_mux1, i_mux2, i_mux3,
	output reg [31:0] o_mux
);
	
	always @*
		case (i_way)
			2'b00: o_mux = i_mux0;
			2'b01: o_mux = i_mux1;
			2'b10: o_mux = i_mux2;
			2'b11: o_mux = i_mux3;
		endcase
endmodule 

module Mux2 #(parameter BIT = 32)
(
	input i_way,
	input [BIT-1:0] i_mux0, i_mux1,
	output reg [BIT-1:0] o_mux
);
	
	always @*
		case (i_way)
			1'b0: o_mux = i_mux0;
			1'b1: o_mux = i_mux1;
		endcase
endmodule 
