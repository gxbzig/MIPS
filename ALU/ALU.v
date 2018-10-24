
module ALU (
	input [31:0] i_A, i_B,
	input [3:0] i_control, // 0,1-to barrel mod; 0-adder cin; 3,2-to mux2; 0,1-to mux1
	input [4:0] i_sa, // to barrel sh
	output zero,Overflow,
	output [31:0] o_res
);

	wire adder_overflow, slt_out;
	wire [31:0] adder_out, and_out, or_out, nor_out, xor_out, barrel_out, logic_out;

	ALU_adder adder (
		.i_addera(i_A),
		.i_adderb(i_B),
		.i_cin(i_control[0]),
		.o_adderres(adder_out),
		.o_overflow(adder_overflow)
	);
	
	barrel Barrel (
		.in(i_B),
		.sh(i_A[4:0]),
		.mod(i_control[1:0]),
		.out(barrel_out)
	);
	
	assign slt_out= adder_out[31] ^ adder_overflow;
	assign and_out= i_A & i_B;
	assign or_out= i_A | i_B;
	assign nor_out= ~(i_A & i_B);
	assign xor_out= i_A ^ i_B;
	
	Mux8 mux1(
	.i_way(i_control[1:0]),
	.i_mux0(and_out),
	.i_mux1(or_out),
	.i_mux2(nor_out),
	.i_mux3(xor_out),
	.o_mux(logic_out)
	);
	
	Mux8 mux2(
	.i_way(i_control[3:2]),
	.i_mux0(barrel_out),
	.i_mux1({31'b0, slt_out}),
	.i_mux2(adder_out),
	.i_mux3(logic_out),
	.o_mux(o_res)
	);
	
	assign Overflow = adder_overflow;
	assign zero = ~|o_res;
	
endmodule

module ALU_adder (
	input [31:0] i_addera,
	input [31:0] i_adderb,
	input i_cin,	  
	output reg [31:0] o_adderres,
	output reg o_carry,
	output o_overflow
);

	always @*
	begin
		if (~i_cin)
			{o_carry, o_adderres} = i_addera + i_adderb;
		else
			{o_carry, o_adderres} = i_addera - i_adderb;
	end
	
	assign o_overflow = ~i_addera[31] & ~i_adderb[31] & o_adderres[31] | i_addera[31] & i_adderb[31] & ~o_adderres[31];
	
endmodule 

module Mux8
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