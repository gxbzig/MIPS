
module MIPS(
input Clk,
input Reset
);

wire [29:0] inPC;
wire [31:0] outPC;
wire [31:0] outSE;
wire [29:0] addPC;
wire [29:0] outNPC;
wire EqualD;
wire PCSrcD;
wire [31:0] BUSB;
wire [31:0] BUSA;
wire ALUSrcD, RegDstD, RegWriteD, MemWriteD, MemtoRegD;
wire [3:0] ALUCtrlD;
wire RegDst;
wire ALUSrc;
wire [3:0]ALUCtrl;
wire [31:0] ALUoutM;
wire MemtoReg;
wire [31:0] SrcAE;
wire [31:0] SrcBE;
wire FlushE, StallD, StallF;
wire [31:0] BUSW;
Mux2 #(.BIT(30)) PCMux(
	.i_way(PCSrcD),
	.i_mux0(addPC), 
	.i_mux1(outNPC),
	.o_mux(inPC)
);

PC PC(
	.PCin(inPC),
	.Clk(Clk),
	.WE_n(StallF),
	.PCout(outPC),
	.Reset(Reset)
);

	assign addPC = outPC[31:2] + 1'b1;
	
wire [31:0] outIM;

InstructionMemory InsMem(
	.i_addr(outPC),
	.o_data(outIM)
);

wire [31:0]InstD;
wire [29:0]PC4D;
RegisterF RegisterF (
	.Reset(Reset),
	.CLR(PCSrcD),
	.i_Clk(Clk),
	.i_Ins(outIM),
	.i_PC4(addPC),
	.WE_n(StallD),
 	.o_Ins(InstD),
	.o_PC4(PC4D)
);

//Decode


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
	
	

wire [4:0] RW;
wire RegWrite;

RegisterFile RF(
	.A1(InstD[25:21]), 
	.A2(InstD[20:16]), 
	.A3(RW), 
	.WD(BUSW), 
	.WE(RegWrite), 
	.Clk(Clk), 
	.RD1(BUSA), 
	.RD2(BUSB)
); 

MainControl MC(
	.i_Op(InstD[31:26]),
	.o_RegDst(RegDstD),
	.o_RegWrite(RegWriteD),
	.o_ExtOp(ExtOp),
	.o_ALUSrc(ALUSrcD),
	.o_MemtoReg(MemtoRegD),
	.o_WE(MemWriteD),
	.o_beq(Beq),
	.o_bne(Bne),
	.o_j(J)
);

ALUControl AC(
	.i_Op(InstD[31:26]),
	.i_funct(InstD[5:0]),
	.ALUCtrl(ALUCtrlD)
);


wire [31:0] SrcA, SrcB;
wire [4:0] RtE, RdE;
wire [31:0]SignImmE;
wire RegWriteE, MemWriteE, MemtoRegE;

wire [25:0] PCImmE;
RegisterD RegD(
	.Reset(Reset),
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


wire [31:0]resALU;
wire Zero;

ALU ALU(
	.i_A(SrcAE), 
	.i_B(MALU),
	.i_control(ALUCtrl), 
	.zero(Zero),
	.Overflow(),
	.o_res(resALU),
	.i_sa(PCImmE[10:6])
);



wire [31:0] WriteDataM;
wire [4:0] WriteRegM;
wire RegWriteM, MemtoRegM;
wire MemWriteM;
RegisterE RegE (
	.Reset(Reset),
	.i_Clk(Clk),
	.i_ALUout(resALU),
	.i_WriteData(SrcBE),
	.i_WriteReg(RWE),
	.i_RegWrite(RegWriteE), 
	.i_MemtoReg(MemtoRegE), 
	.i_MemWrite(MemWriteE),
	.o_ALUout(ALUoutM),
	.o_WriteData(WriteDataM),
	.o_WriteReg(WriteRegM),
	.o_RegWrite(RegWriteM), 
	.o_MemtoReg(MemtoRegM), 
	.o_MemWrite(MemWriteM)
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
	.i_Clk(Clk),
	.i_ReadData(MuxD),
	.i_ALUout(ALUoutM),
	.i_WriteReg(WriteRegM),
	.i_RegWrite(RegWriteM), 
	.i_MemtoReg(MemtoRegM),
	.o_ReadData(ReadDataW),
	.o_ALUout(ALUoutW),
	.o_WriteReg(RW),
	.o_RegWrite(RegWrite), 
	.o_MemtoReg(MemtoReg)
);
// WriteBack


Mux2 #(.BIT(32)) DMMux(
	.i_way(MemtoReg),
	.i_mux0(ALUoutW), 
	.i_mux1(ReadDataW),
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
wire BranchD = J | Bne | Beq;

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
	.MemtoRegE(MemtoRegE),
	.MemtoRegM(MemtoRegM),
	.FlushE(FlushE),
	.StallF(StallF),
	.StallD(StallD),
	.ForwardAD(ForwardAD),
	.ForwardBD(ForwardBD)
);
endmodule 
