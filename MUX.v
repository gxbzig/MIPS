module Mux4 #(parameter BIT = 32)
(
	input [1:0] i_way,
	input [BIT-1:0] i_mux0, i_mux1, i_mux2, i_mux3,
	output reg [BIT-1:0] o_mux
);
	
	always @*
		case (i_way)
			2'b00: o_mux = i_mux0;
			2'b01: o_mux = i_mux1;
			2'b10: o_mux = i_mux2;
			2'b11: o_mux = i_mux3;
		endcase
endmodule 

module Mux3 #(parameter BIT = 32)
(
	input [1:0] i_way,
	input [BIT-1:0] i_mux0, i_mux1, i_mux2,
	output reg [BIT-1:0] o_mux
);
	
	always @*
		case (i_way)
			2'b00: o_mux = i_mux0;
			2'b01: o_mux = i_mux1;
			2'b10: o_mux = i_mux2;
			2'b11: o_mux = 0;
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

module Mux14(
	input [3:0]i_way,
	input [31:0] i_mux0, i_mux1, i_mux2, i_mux3, i_mux4, i_mux5, i_mux6, i_mux7, i_mux8, i_mux9, i_mux10, i_mux11, i_mux12, 
	i_mux13, i_mux14,
	output reg [31:0] o_mux
);
	
	always @*
		case (i_way)
			4'd0: o_mux = i_mux0;
			4'd1: o_mux = i_mux1;
			4'd2: o_mux = i_mux2;
			4'd3: o_mux = i_mux3;
			4'd4: o_mux = i_mux4;
			4'd5: o_mux = i_mux5;
			4'd6: o_mux = i_mux6;
			4'd7: o_mux = i_mux7;
			4'd8: o_mux = i_mux8;
			4'd9: o_mux = i_mux9;
			4'd10: o_mux = i_mux10;
			4'd11: o_mux = i_mux11;
			4'd12: o_mux = i_mux12;
			4'd13: o_mux = i_mux13;
			4'd14: o_mux = i_mux14;
			default: o_mux = 32'b0;
		endcase
endmodule 
