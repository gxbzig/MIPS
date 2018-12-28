
module MIPS(
	input Clk,
	input [3:0]KEY,
	input Reset
);

wire [29:0] inPC;
wire [29:0] inPCB;
wire [31:0] outPC;
wire [31:0] outSE;
wire [29:0] addPC;
wire [29:0] outNPC;
wire EqualD;
wire PCSrcD;
wire [31:0] BUSB;
wire [31:0] BUSA;
wire ALUSrcD, RegDstD, RegWriteD, MemWriteD;
wire [1:0] MemtoRegD;
wire [3:0] ALUCtrlD;
wire RegDst;
wire ALUSrc;
wire [3:0]ALUCtrl;
wire [31:0] ALUoutM;
wire [1:0] MemtoReg;
wire [31:0] SrcAE;
wire [31:0] SrcBE;
wire FlushE, StallD, StallF;
wire [31:0] BUSW;
wire BranchD;
wire [31:0]InstD;
wire [30:0] outDBP;
wire nEqualBP;
reg noutDBP;
reg [29:0] rNPC;
wire [31:0] outEPC;
wire [31:0] MCause, outCause;
wire Interrupt;
wire [1:0] IntCause;
wire [31:0] outc0;
wire [29:0] outMPC;
wire [31:0] outStatus;
wire nInstr;
wire mtc0;
wire [31:0] BUSWM;
wire IntIO;
wire [1:0]int12;
wire eret;
wire [1:0]int1;
wire Overflow;
wire [4:0] RtM, RtW;
reg [1:0] Forwardc0;
wire [31:0] i_Status;
wire [25:0] PCImmE;
wire [31:0]resALU;
assign int1[0] = KEY[0] & outStatus[8];
assign int1[1] = KEY[1] & outStatus[9];
assign int12[0] = int1[0];
assign int12[1] = int1[1] & (~int1[0]);
assign IntIO = |int12;

Mux4 #(.BIT(30)) PC1Mux(
	.i_way({noutDBP & (~PCSrcD) | (~PCSrcD) & outDBP[0] & (~noutDBP) | PCSrcD & outDBP[0] & noutDBP, nEqualBP}),
	.i_mux0(addPC),
	.i_mux1(outNPC),
	.i_mux2(outDBP[30:1]),
	.i_mux3(rNPC),
	.o_mux(outMPC)
);

Mux3 #(.BIT(30)) PC2Mux(
	.i_way({eret, Interrupt & (~eret)}),
	.i_mux0(outMPC), 
	.i_mux1(30'b000000000000000000000001100000),
	.i_mux2(outEPC[31:2]),
	.o_mux(inPC)
);

PC PC(
	.PCin(inPC),
	.Clk(Clk),
	.WE_n(StallF),
	.PCout(outPC),
	.Reset(Reset)
);
//assign Interrupt = (int1[0] || int1[1] || (Overflow && (ALUCtrlD[3] & (~ALUCtrlD[2]))) || nInstr) && outStatus[0]; 
assign Interrupt = (int1[0] || int1[1]) && outStatus[0]; 
EPC EPC (
	.i_data(outPC),
	.EPCWrite(Interrupt),
	.Reset(Reset),
	.Clk(Clk),
	.o_data(outEPC)
);

always @(posedge Clk, negedge Reset) begin
	if (~Reset) rNPC <= 0;
	else if (~StallF) rNPC <= addPC; 
end

assign addPC = outPC[31:2] + 1'b1;

wire [31:0] outIM;

InstructionMemory InsMem(
	.i_addr(outPC),
	.o_data(outIM)
);

assign nEqualBP = PCSrcD ^ noutDBP;

always @(posedge Clk,negedge Reset) begin
	if (~Reset) noutDBP <= 0;
	else if (~StallF) noutDBP <= outDBP[0];
 end
 
DynamicPredictors DBP(
	.Reset(Reset),
	.i_addrr(outIM[9:0]),
	.i_addrw(InstD[9:0]),
	.Clk(Clk),
	.WE(nEqualBP & (~StallD)),
	.i_next(PCSrcD),
	.i_data(outNPC),
	.o_data(outDBP)
);


wire [29:0]PC4D;

RegisterF RegisterF (
	.Reset(Reset),
	.CLR(nEqualBP),
	.i_Clk(Clk),
	.i_Ins(outIM),
	.i_PC4(addPC),
	.WE_n(StallD),
 	.o_Ins(InstD),
	.o_PC4(PC4D)
);

//Decode
assign IntCause[0] = nInstr;
assign IntCause[1] = IntIO;

Mux3 MuxCause (
	.i_way(IntCause),
	.i_mux0(32'h30), 
	.i_mux1(32'h28), 
	.i_mux2({22'b0, int12, 8'h0}),
	.o_mux(MCause)
);

Cause Cause (
	.i_data(MCause),
	.CWrite(Interrupt),
	.Reset(Reset),
	.Clk(Clk),
	.o_data(outCause)
);

always @* begin
	if (mtc0 & (InstD[20:16] == RtW))  Forwardc0 = 2'b11;
	else if (mtc0 & (InstD[20:16] == RtM)) Forwardc0 = 2'b10;
	else if (mtc0 & (InstD[20:16] == PCImmE[20:16])) Forwardc0 = 2'b01;
	else Forwardc0 = 2'b00;
end

Mux4 #(.BIT(32)) MuxStatus(
	.i_way(Forwardc0),
	.i_mux0(BUSB), 
	.i_mux1(resALU),
	.i_mux2(ALUoutM),
	.i_mux3(BUSW),
	.o_mux(i_Status)
);

Status Status (
	.i_data(i_Status),
	.SWrite(mtc0 & (~InstD[15]) & InstD[14] & InstD[13] & (~InstD[12]) & (~InstD[11]) ),
	.Reset(Reset),
	.Clk(Clk),
	.srst(Interrupt & (~eret)),
	.o_data(outStatus)
);

Mux14 Muxc0(
	.i_way(InstD[14:11]),
	.i_mux0(), 
	.i_mux1(), 
	.i_mux2(), 
	.i_mux3(), 
	.i_mux4(), 
	.i_mux5(), 
	.i_mux6(), 
	.i_mux7(), 
	.i_mux8(), 
	.i_mux9(), 
	.i_mux10(), 
	.i_mux11(), 
	.i_mux12(outStatus), 
	.i_mux13(outCause), 
	.i_mux14(outEPC),
	.o_mux(outc0)
);

wire J;
wire Beq;
wire Bne;

NextPC NextPC(
	.i_PC(PC4D), 
	.i_immPC(InstD[25:0]), 
	.i_Zero(EqualD),
	.i_J(J),
	.i_Bne(Bne),
	.i_Beq(Beq),
	.o_PC(outNPC),
	.o_PCSrc(PCSrcD)
);

wire ForwardAD, ForwardBD;

wire [31:0] EqualA, EqualB;
assign EqualD = EqualA == EqualB;

Mux2 MuxEq1 (
	.i_way(ForwardAD),
	.i_mux0(BUSA), 
	.i_mux1(ALUoutM),
	.o_mux(EqualA)
);

Mux2 MuxEq2(
	.i_way(ForwardBD),
	.i_mux0(BUSB), 
	.i_mux1(ALUoutM),
	.o_mux(EqualB)
);


wire ExtOp;

SignExtender SE(
	.out(outSE), 
	.in(InstD[15:0]), 
	.ExtOp(ExtOp)
);
	
wire [4:0] RW, RWF;
wire RegWrite;
Mux2 #(.BIT(5)) Mux1mfc0(
	.i_way(MemtoRegD[1]),
	.i_mux0(RW), 
	.i_mux1(InstD[20:16]),
	.o_mux(RWF)
);	

Mux2 #(.BIT(32)) Mux2mfc0(
	.i_way(MemtoRegD[1]),
	.i_mux0(BUSW), 
	.i_mux1(outc0),
	.o_mux(BUSWM)
);	


RegisterFile RF(
	.A1(InstD[25:21]), 
	.A2(InstD[20:16]), 
	.A3(RWF), 
	.WD(BUSWM), 
	.WE(RegWrite || MemtoRegD[1]), 
	.Clk(Clk), 
	.RD1(BUSA), 
	.RD2(BUSB)
); 

MainControl MC(
	.i_Op(InstD[31:26]),
	.i_co0(InstD[25:21]),
	.o_RegDst(RegDstD),
	.o_RegWrite(RegWriteD),
	.o_ExtOp(ExtOp),
	.o_ALUSrc(ALUSrcD),
	.o_MemtoReg(MemtoRegD),
	.o_WE(MemWriteD),
	.o_beq(Beq),
	.o_bne(Bne),
	.o_j(J),
	.o_mtc0(mtc0),
	.o_eret(eret)
);

assign nInstr = ~(RegDstD | RegWriteD | ExtOp | ALUSrcD | MemtoRegD[0] | MemtoRegD[0] | MemWriteD | Beq | Bne | J | mtc0 | eret);

ALUControl AC(
	.i_Op(InstD[31:26]),
	.i_funct(InstD[5:0]),
	.ALUCtrl(ALUCtrlD)
);


wire [31:0] SrcA, SrcB;
wire [4:0] RtE, RdE;
wire [31:0]SignImmE;
wire RegWriteE, MemWriteE;
wire [1:0] MemtoRegE;


RegisterD RegD(
	.Reset(Reset),
	.WE_n(RegWrite & MemtoRegD[1]),
	.i_Clk(Clk),
	.i_RD1(BUSA),
	.i_RD2(BUSB),
	.i_SignImm(outSE),
	.i_ALUSrc(ALUSrcD), 
	.i_RegDst(RegDstD), 
	.i_RegWrite(RegWriteD), 
	.i_MemWrite(MemWriteD), 
	.i_MemtoReg(MemtoRegD),
	.i_ALUCtrl(ALUCtrlD),
	.i_PCImm(InstD[25:0]),
	.CLR(FlushE),
	.o_RD1(SrcA),
	.o_RD2(SrcB),
	.o_SignImm(SignImmE),
	.o_ALUSrc(ALUSrc), 
	.o_RegDst(RegDst), 
	.o_RegWrite(RegWriteE), 
	.o_MemWrite(MemWriteE), 
	.o_MemtoReg(MemtoRegE),
	.o_ALUCtrl(ALUCtrl),
	.o_PCImm(PCImmE)
);

//Execute

wire [4:0] RWE;
Mux2 #(.BIT(5)) RdMux(
	.i_way(RegDst),
	.i_mux0(PCImmE[20:16]), 
	.i_mux1(PCImmE[15:11]),
	.o_mux(RWE)
);


wire [31:0]MALU;
Mux2 #(.BIT(32)) ALUMux(
	.i_way(ALUSrc),
	.i_mux0(SrcBE), 
	.i_mux1(SignImmE),
	.o_mux(MALU)
);



wire Zero;

ALU ALU(
	.i_A(SrcAE), 
	.i_B(MALU),
	.i_control(ALUCtrl), 
	.zero(Zero),
	.Overflow(Overflow),
	.o_res(resALU),
	.i_sa(PCImmE[10:6])
);



wire [31:0] WriteDataM;
wire [4:0] WriteRegM;
wire RegWriteM;
wire [1:0] MemtoRegM;
wire MemWriteM;
RegisterE RegE (
	.Reset(Reset),
	.WE_n(RegWrite & MemtoRegD[1]),
	.i_Clk(Clk),
	.i_ALUout(resALU),
	.i_WriteData(SrcBE),
	.i_WriteReg(RWE),
	.i_RegWrite(RegWriteE), 
	.i_MemtoReg(MemtoRegE), 
	.i_MemWrite(MemWriteE),
	.i_Rt(PCImmE[20:16]),
	.o_ALUout(ALUoutM),
	.o_WriteData(WriteDataM),
	.o_WriteReg(WriteRegM),
	.o_RegWrite(RegWriteM), 
	.o_MemtoReg(MemtoRegM), 
	.o_MemWrite(MemWriteM),
	.o_Rt(RtM)
);

//Memory

wire [31:0] MuxD;

GDataMemory DM(
	.Reset(Reset),
	.i_A(ALUoutM), 
	.i_WE(MemWriteM), 
	.o_D(MuxD),
	.i_D(WriteDataM), 
	.Clk(Clk)
);

wire [31:0] ALUoutW;
wire [31:0] ReadDataW;
RegisterM RegM (
	.Reset(Reset),
	.WE_n(RegWrite & MemtoRegD[1]),
	.i_Clk(Clk),
	.i_ReadData(MuxD),
	.i_ALUout(ALUoutM),
	.i_WriteReg(WriteRegM),
	.i_RegWrite(RegWriteM), 
	.i_MemtoReg(MemtoRegM),
	.i_Rt(RtM),
	.o_ReadData(ReadDataW),
	.o_ALUout(ALUoutW),
	.o_WriteReg(RW),
	.o_RegWrite(RegWrite), 
	.o_MemtoReg(MemtoReg),
	.o_Rt(RtW)
);
// WriteBack


Mux3 #(.BIT(32)) DMMux(
	.i_way(MemtoReg),
	.i_mux0(ALUoutW), 
	.i_mux1(ReadDataW),
	.i_mux2(outc0),
	.o_mux(BUSW)
);

//Hazard
wire [1:0] ForwardAE;

Mux3 MHaz1(
	.i_way(ForwardAE),
	.i_mux0(SrcA), 
	.i_mux1(BUSW), 
	.i_mux2(ALUoutM),
	.o_mux(SrcAE)
);


wire [1:0] ForwardBE;
Mux3 MHaz2(
	.i_way(ForwardBE),
	.i_mux0(SrcB), 
	.i_mux1(BUSW), 
	.i_mux2(ALUoutM),
	.o_mux(SrcBE)
);

assign BranchD = J | Bne | Beq;

HazardUnit HU(
	.RsE(PCImmE[25:21]),
	.RtE(PCImmE[20:16]),
	.RsD(InstD[25:21]),
	.RtD(InstD[20:16]),
	.WriteRegM(WriteRegM),
	.WriteRegE(RWE),
	.WriteRegW(RW),
	.RegWriteM(RegWriteM),
	.RegWrite(RegWrite),
	.BranchD(BranchD),
	.RegWriteE(RegWriteE),
	.ForwardAE(ForwardAE),
	.ForwardBE(ForwardBE),
	.MemtoRegE(MemtoRegE[0]),
	.MemtoRegM(MemtoRegM[0]),
	.FlushE(FlushE),
	.StallF(StallF),
	.StallD(StallD),
	.ForwardAD(ForwardAD),
	.ForwardBD(ForwardBD)
);

endmodule 
