module MainControl(
	input [5:0]i_Op,
	output o_RegDst,
	output o_RegWrite,
	output o_ExtOp,
	output o_ALUSrc,
	output o_WE,
	output o_MemtoReg,
	output o_beq,
	output o_bne,
	output o_j
);

reg Rtype, addi, slti, andi, ori, xori, lw, sw, beq, bne, j;

assign o_RegDst = Rtype;	
assign o_RegWrite = ~(sw | beq | bne | j);
assign o_ExtOp = ~(andi | ori | xori | Rtype);
assign o_ALUSrc = ~(Rtype | beq | bne);
assign o_WE = sw;
assign o_MemtoReg = lw;
assign o_beq = beq;
assign o_bne = bne;
assign o_j = j;

reg [10:0] control;

always @* begin
	{Rtype, addi, slti, andi, ori, xori, lw, sw, beq, bne, j} = control;
end


always @* begin
casez(i_Op)
	6'b000000: control = 11'b10000000000; //Rtype
	6'b001000: control = 11'b01000000000; //addi
	6'b001010: control = 11'b00100000000; //slti
	6'b001100: control = 11'b00010000000; //andi
	6'b001101: control = 11'b00001000000; //ori
	6'b001110: control = 11'b00000100000; //xori
	6'b100011: control = 11'b00000010000; //lw 
	6'b101011: control = 11'b00000001000; //sw
	6'b000100: control = 11'b00000000100; // beq
	6'b000101: control = 11'b00000000010; // bne
	6'b000010: control = 11'b00000000001; // j
	
	  default   :  control = 11'b0;
           
endcase
end
endmodule
