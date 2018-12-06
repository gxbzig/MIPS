module barrel (
input [31:0]i_Data,
input [4:0]sh,
input [1:0]mod,
output [31:0] o_Data
);
reg [31:0] Data;
always @* Data = i_Data;
reg [62:0] split63;
wire [46:0] split47;
wire [38:0] split39;
wire [34:0] split35;
wire [32:0] split33;

wire [4:0] sa;
assign sa= (|mod)?(~sh):(sh);

always @* begin
	case(mod)
		2'b00: split63 = {Data, 31'h00000000};
		2'b01: split63 = {31'h00000000, Data};
		2'b10: split63 = {{31{Data[31]}}, Data};
		2'b11: split63 = {Data[30:0], Data};
	endcase
end

Mux2 #(.BIT(47)) Mux4(
	.i_way(sa[4]),
	.i_mux0(split63[62:16]), 
	.i_mux1(split63[46:0]),
	.o_mux(split47)
);

Mux2 #(.BIT(39)) Mux3(
	.i_way(sa[3]),
	.i_mux0(split47[46:8]), 
	.i_mux1(split47[38:0]),
	.o_mux(split39)
);

Mux2 #(.BIT(35)) Mux2(
	.i_way(sa[2]),
	.i_mux0(split39[38:4]), 
	.i_mux1(split39[34:0]),
	.o_mux(split35)
);

Mux2 #(.BIT(33)) Mux1(
	.i_way(sa[1]),
	.i_mux0(split35[34:2]), 
	.i_mux1(split35[32:0]),
	.o_mux(split33)
);

Mux2 #(.BIT(32)) Mux0(
	.i_way(sa[0]),
	.i_mux0(split33[32:1]), 
	.i_mux1(split33[31:0]),
	.o_mux(o_Data)
);
endmodule
