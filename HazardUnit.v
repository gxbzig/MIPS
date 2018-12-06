
module HazardUnit(
	input [4:0] RsE, RsD,
	input [4:0] RtE, RtD,
	input [4:0] WriteRegM, WriteRegE, WriteRegW,
	input RegWriteM,
	input RegWrite,
	input MemtoRegE, MemtoRegM,
	input BranchD,
	input RegWriteE,
	output reg [1:0] ForwardAE,
	output reg [1:0] ForwardBE,
	output FlushE, StallD, StallF,
	output reg ForwardAD, ForwardBD
);

wire lwstall, branchstall;

assign lwstall = ((RsD == RtE) | (RtD == RtE)) & MemtoRegE;
assign branchstall = BranchD & RegWriteE & ((WriteRegE == RsD) | (WriteRegE == RtD)) | BranchD & MemtoRegM & ((WriteRegM == RsD) | (WriteRegM == RtD)); 
assign FlushE = lwstall | branchstall;
assign StallF = lwstall | branchstall;
assign StallD = lwstall | branchstall;

always @* begin
	if ((|RsE) & ((RsE == WriteRegM)) & RegWriteM)  ForwardAE = 2'b10;
	else if ((|RsE) & ((RsE == WriteRegW)) & RegWrite) ForwardAE = 2'b01;
	else ForwardAE = 2'b00;
end

always @* begin
	if ((|RtE) & ((RtE == WriteRegM)) & RegWriteM)  ForwardBE = 2'b10;
	else if ((|RtE) & ((RtE == WriteRegW)) & RegWrite) ForwardBE = 2'b01;
	else ForwardBE = 2'b00;
end

always @* begin
	ForwardAD = (RsD != 0) & (RsD == WriteRegM) & RegWriteM;
	ForwardBD = (RtD != 0) & (RtD == WriteRegM) & RegWriteM;
end
endmodule
