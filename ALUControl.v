module ALUControl(
	input [5:0] i_Op,
	input [5:0] i_funct,
	output reg [3:0]ALUCtrl
);

reg [11:0]control;

always @* begin
control = {i_Op, i_funct};
casez(control)
	12'b000000_100000: ALUCtrl = 4'b1000;
	12'b000000_100010: ALUCtrl = 4'b1001;
	12'b000000_100100: ALUCtrl = 4'b1100;
	12'b000000_100101: ALUCtrl = 4'b1101;
	12'b000000_100110: ALUCtrl = 4'b1111;
	12'b000000_101010: ALUCtrl = 4'b0101;
	12'b000000_000000: ALUCtrl = 4'b0001;
	12'b001000??????: ALUCtrl = 4'b1000;
	12'b001010??????: ALUCtrl = 4'b0101;
	12'b001100??????: ALUCtrl = 4'b1100;
	12'b001101??????: ALUCtrl = 4'b1101;
	12'b001110??????: ALUCtrl = 4'b1111;
	12'b100011??????: ALUCtrl = 4'b1000;
	12'b101011??????: ALUCtrl = 4'b1000;
	12'b000100??????: ALUCtrl = 4'b1001;
	12'b000101??????: ALUCtrl = 4'b1001;
	12'b000010??????: ALUCtrl = 4'b0;

	
	  default   :  ALUCtrl = 4'b0;
           
endcase
end
endmodule
