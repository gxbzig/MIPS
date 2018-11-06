module NextPC(
	input [29:0] i_PC, 
	input [25:0] i_immPC, 
	input i_Zero,
	input i_J,
	input i_Bne,
	input i_Beq,
	output [29:0] o_PC,
	output o_PCSrc
);

reg [29:0]SE;

always @(i_PC, i_immPC) begin
	if(i_immPC[15]) SE <= {14'b11111111111111 , i_immPC[15:0]};
	else SE <= {14'b00000000000000 , i_immPC[15:0]};
end

wire [29:0]sum;
assign sum = i_PC + $signed(SE);	

Mux2 #(.BIT(30)) MuxNPC(
	.i_way(J),
	.i_mux0(sum), 
	.i_mux1({i_PC[29:26],i_immPC}),
	.o_mux(o_PC)
);

assign o_PCSrc = J | (i_Beq & i_Zero) | (i_Bne & (~i_Zero));

endmodule
