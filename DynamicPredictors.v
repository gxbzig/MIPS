module DynamicPredictors(
	input Reset,
	input [9:0] i_addrr,
	input [9:0] i_addrw,
	input Clk,
	input WE,
	input i_next,

	input [29:0] i_data,
	output reg [30:0] o_data
);

reg [31:0] Registers [1023:0];
reg [1:0] State;
reg [31:0] data;
integer i;

always @(posedge Clk, negedge Reset) begin
	 if (~Reset) begin
		for (i=0;i<1024;i=i+1) 
			Registers[i] <= 32'h00000000;
	 end else if(WE) Registers[i_addrw] <= {i_data, State};
end

always @* data =  Registers[i_addrr];

always @* o_data = {data[31:2], data[1]};


always @* begin
	case (data[1:0])
		00: State = (i_next)? 2'b10:2'b01;
		01: State = (i_next)? 2'b00:2'b01;
		10: State = (i_next)? 2'b11:2'b00;
		11: State = (i_next)? 2'b11:2'b10;
			default : State = 2'b00;
	endcase
end
endmodule
