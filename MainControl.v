module MainControl(
	input [5:0] i_Op,
	input [4:0]i_co0,
	output o_RegDst,
	output o_RegWrite,
	output o_ExtOp,
	output o_ALUSrc,
	output o_WE,
	output [1:0] o_MemtoReg,
	output o_beq,
	output o_bne,
	output o_j,
	output o_mtc0,
	output o_eret
);
reg [1:0] MemtoReg;
reg Rtype, addi, slti, andi, ori, xori, lw, sw, beq, bne, j, mfc0, mtc0, eret;

assign o_RegDst = Rtype;	
assign o_RegWrite = ~(sw | beq | bne | j);
assign o_ExtOp = ~(andi | ori | xori | Rtype);
assign o_ALUSrc = ~(Rtype | beq | bne);
assign o_WE = sw;
assign o_MemtoReg = MemtoReg;
assign o_beq = beq;
assign o_bne = bne;
assign o_j = j;
assign o_mtc0 = mtc0;
assign o_eret = eret;
reg [13:0] control;


always @* begin
	MemtoReg[0] = lw;
	MemtoReg[1] = mfc0;
end

always @* begin
	{Rtype, addi, slti, andi, ori, xori, lw, sw, beq, bne, j, mfc0, mtc0, eret} = control;
end


always @* begin
casez({i_Op, i_co0})
	11'b000000?????: control = 14'b10000000000000; //Rtype
	11'b001000?????: control = 14'b01000000000000; //addi
	11'b001010?????: control = 14'b00100000000000; //slti
	11'b001100?????: control = 14'b00010000000000; //andi
	11'b001101?????: control = 14'b00001000000000; //ori
	11'b001110?????: control = 14'b00000100000000; //xori
	11'b100011?????: control = 14'b00000010000000; //lw 
	11'b101011?????: control = 14'b00000001000000; //sw
	11'b000100?????: control = 14'b00000000100000; // beq
	11'b000101?????: control = 14'b00000000010000; // bne
	11'b000010?????: control = 14'b00000000001000; // j
	11'b01000000000: control = 14'b00000000000100; // mfc0
	11'b01000000100: control = 14'b00000000000010; // mtc0
	11'b01000010000: control = 14'b00000000000001; // ERET
								
	  default   :  control = 14'b0;
           
endcase
end
endmodule
