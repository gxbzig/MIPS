`timescale 1ns / 1ns

module MIPS_tb;
reg CLOCK_50;
reg [3:0] KEY;

MIPS bs( .CLOCK_50, .KEY);

initial #5 KEY = 4'b1111;
initial #1910 KEY = 4'b1110;
initial #1950 KEY = 4'b1111;
initial #3000 KEY = 4'b1110;
initial #4000 KEY = 4'b1111;
initial #5115 KEY = 4'b1110;
initial #5200 KEY = 4'b1111;
initial begin
#10 forever  #10 CLOCK_50=~CLOCK_50;
end

initial #10000 $finish;

initial begin
	KEY = 4'b1011;
	CLOCK_50 = 0;
end

endmodule
