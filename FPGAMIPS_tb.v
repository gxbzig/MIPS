`timescale 1ns / 1ns

module FPGAMIPS_tb;
reg CLOCK_50;
reg [3:0] KEY;

FPGAMIPS bs( .CLOCK_50, .KEY);


initial #5 KEY = 4'b0100;
initial #10 KEY = 4'b0000;
initial #3000 KEY = 4'b0001;
initial begin
#10 forever  #10 CLOCK_50=~CLOCK_50;
end

initial #10000 $finish;

initial begin
	KEY = 0;
	CLOCK_50 = 0;
end

endmodule
