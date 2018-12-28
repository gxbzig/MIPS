module InstructionMemory
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(ADDR_WIDTH-1):0] i_addr,
	output reg [(DATA_WIDTH-1):0] o_data
);
	reg [DATA_WIDTH-1:0] rom[2**15-1:0];

	initial begin
		$readmemb("pr21.bin", rom);
	end

	always @ (i_addr)
	begin
		o_data = rom[i_addr];
	end

endmodule
