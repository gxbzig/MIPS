 module SignExtender(out, in, ExtOp);
	output reg [31:0] out;
	input   [15:0] in;
	input ExtOp;

always@* begin
	casez({ExtOp, in[15]})
		2'b11: 	out = {16'hffff , in};
		default: out = {16'h0000 , in};
	endcase
end
		
endmodule 