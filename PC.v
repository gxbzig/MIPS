module PC(PCin, PCout, Clk, Reset, WE_n);

input [29:0]  PCin;
input Clk;
input Reset;
input WE_n;
output reg [31:0]  PCout;


always @(posedge Clk,negedge Reset) begin
	if (~Reset) PCout <= 32'b0;
	else if(~WE_n) PCout <= {PCin, 2'b00};	
end

endmodule
