module ALU (
	input [31:0] i_A, i_B,
	input [3:0] i_control,
	output zero,Overflow,
	output [31:0] o_res,
	input [4:0] i_sa
);
	wire slt_out;
	wire adder_overflow;
	wire [31:0] adder_out, and_out, or_out, nor_out, xor_out, barrel_out, logic_out;

	ALU_adder adder (
		.i_addera(i_A),
		.i_adderb(i_B),
		.i_cin(i_control[0]),
		.o_adderres(adder_out),
		.o_overflow(adder_overflow)
	);
	
	barrel Barrel (
		.i_Data(i_B),
		.sh(i_sa),
		.mod(i_control[1:0]),
		.o_Data(barrel_out)
	);

	assign slt_out= i_A[31] ^ adder_overflow;
	assign and_out= i_A & i_B;
	assign or_out= i_A | i_B;
	assign nor_out= ~(i_A | i_B);
	assign xor_out= i_A ^ i_B;
	
	Mux4 mux1(
	.i_way(i_control[1:0]),
	.i_mux0(and_out),
	.i_mux1(or_out),
	.i_mux2(nor_out),
	.i_mux3(xor_out),
	.o_mux(logic_out)
	);
	
	Mux4 mux2(
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
	output o_overflow
);

reg o_carry;

assign o_overflow = ~i_addera[31] & ~i_adderb[31] & o_adderres[31] | i_addera[31] & i_adderb[31] & ~o_adderres[31];
wire [31:0] op1 = i_adderb ^ {32{i_cin}};
wire [32:0] aluout = $signed(i_addera) + op1 + i_cin;

	always @*
	begin
			{o_carry, o_adderres} = aluout;
	end
endmodule 
