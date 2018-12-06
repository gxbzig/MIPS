module GPIO(
	input [31:0] i_DD,
	input i_Clk,
	inout [31:0] IO,
	input i_rst_n,
	input i_WER,
	input i_WEO,
	output [31:0] o_DIN,
	output reg [31:0] o_DDIR
);
reg [31:0] DIN;
reg [31:0] DOUT;
reg [31:0] DDIR;

assign o_DIN = DIN;

genvar a;
generate
		for (a=0; a < 32; a=a+1) begin : zIO
			assign IO[a] = (~DDIR[a]) ? DOUT[a] : 1'bZ;
		end
endgenerate

	
always @(posedge i_Clk, negedge i_rst_n) begin 
	if(~i_rst_n) DIN <= 32'b0;
	else DIN <= IO;
end

always @(posedge i_Clk,negedge i_rst_n) begin
	if(~i_rst_n) 
		DOUT <= 0;
	else if (i_WEO) DOUT <= i_DD;
end
	
always @(posedge i_Clk, negedge i_rst_n) begin
	if(~i_rst_n) 
		DDIR <= 0;
	else if(i_WER) DDIR <= i_DD;
end

always @* begin
	o_DDIR = DDIR;
end

endmodule
