module DynamicPredictors(
	input Reset,
	input [4:0] i_addrr,
	input [4:0] i_addrw,
	input Clk,
	input WE,
	input i_next,

	input [29:0] i_data,
	output reg [30:0] o_data
);

reg [31:0] Registers [31:0];
reg [1:0] State;
reg [31:0] data;
integer i;

always @(posedge Clk, negedge Reset) begin
	 if (~Reset) begin
		for (i=0;i<32;i=i+1) 
			Registers[i] <= 32'h00000000;
	 end else if(WE) Registers[i_addrw] <= {i_data, State};
end

always @* data =  Registers[i_addrr];

always @* o_data = {data[31:2], data[1]};


always @* begin
	casez (data[1:0])
		2'b00: State = (i_next)? 2'b10:2'b01;
		2'b01: State = (i_next)? 2'b00:2'b01;
		2'b10: State = (i_next)? 2'b11:2'b00;
		2'b11: State = (i_next)? 2'b11:2'b10;
			default : State = 2'bxx;
	endcase
end
endmodule
