module PC(PCin, PCout, Clk);

	input       [29:0]  PCin;
	input               Clk;
	output reg  [31:0]  PCout;

  
    always @(posedge Clk) begin
		PCout <= {PCin, 2'b00};	
    end

endmodule
