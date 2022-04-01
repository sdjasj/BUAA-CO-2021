`timescale 1ns / 1ps

//PCAS == PC+4
//Rd1FromGrf == RS
//Rd2FromGrf == Rt
module mips(
    input clk,
    input reset
    );
	 wire [31:0] PcOut,NpcToPc,Instr,RfwdFromMux,
					 Rd1FromGrf, Rd2FromGrf,ALUBFromMux,
					 ALUOUT,EXTOUT,DataFromDM,PCA4;
	 wire RFWE,DMWE;
	 wire [5:0] InstrOpcode,InstrFunc;
	 wire[4:0] InstrRs,InstrRt,InstrRd,Shamt,A3FromMux,ZeroFromALU;
	 wire [15:0] InstrImm16;
	 wire [25:0] InstrImm26;
	 wire [3:0] ALUOP;
	 wire [2:0] RFA3OP,RFWDOP,ALUBOP,NPCOP,DMOP;
	 wire [1:0] EXTOP;
	 assign InstrOpcode = Instr[31:26];
	 assign InstrRs = Instr[25:21];
	 assign InstrRt = Instr[20:16];
	 assign InstrRd = Instr[15:11];
	 assign Shamt = Instr[10:6];
	 assign InstrFunc = Instr[5:0];
	 assign InstrImm16 = Instr[15:0];
	 assign InstrImm26 = Instr[25:0];

	 
	 PC CPUPC (.clk(clk), .reset(reset), .npc(NpcToPc),.pc(PcOut));
	 
	 IM CPUIM(.Addr(PcOut), .instr(Instr));
	 
	 RFA3MUX CPURFA3MUX(.RFA3OP(RFA3OP), .rd(InstrRd), .rt(InstrRt), .A3(A3FromMux));
	 
	 RFWDMUX CPURFWDMUX(.RFWDOP(RFWDOP),.ALUOUT(ALUOUT), 
								.DMOUT(DataFromDM), .PCA4(PCA4), .RFWD(RfwdFromMux));
	 
	 
	 GRF CPUGRF(.clk(clk), .reset(reset), .WE(RFWE), .A1(InstrRs), .A2(InstrRt), .A3(A3FromMux), 
					.WD(RfwdFromMux), .PC(PcOut), .RD1(Rd1FromGrf), .RD2(Rd2FromGrf));
					
	 ALUBMUX CPUALUBMUX(.ALUBOP(ALUBOP), .rt(Rd2FromGrf), .IMM16(EXTOUT), .ALUB(ALUBFromMux));
	 
	 ALU CPUALU(.A(Rd1FromGrf), .B(ALUBFromMux), .ALUOP(ALUOP), 
					.SHAMT(Shamt), .Zero(ZeroFromALU), .ALUOUT(ALUOUT));
	 
	 EXT CPUEXT(.EXTOP(EXTOP), .IMM16(InstrImm16), .EXTOUT(EXTOUT));
	 
	 
	 DM CPUDM(.DMOP(DMOP), .Address(ALUOUT), .Input(Rd2FromGrf), .clk(clk), 
					.Reset(reset), .DMWE(DMWE), .PC(PcOut), .Data(DataFromDM));
					
	 NPC CPUNPC(.PC(PcOut), .IMM26(InstrImm26), .IMM16(InstrImm16), .IMM32(Rd1FromGrf),
						.NPCOP(NPCOP), .Zero(ZeroFromALU), .NPC(NpcToPc), .PCA4(PCA4));			
	 
	 CTRL CPUCTRL(.OPCODE(InstrOpcode), .FUNC(InstrFunc), .RFWE(RFWE), .EXTOP(EXTOP), .DMWE(DMWE),
						.RFA3MUX(RFA3OP), .RFWDMUX(RFWDOP), .ALUBMUX(ALUBOP), .ALUOP(ALUOP), .NPCOP(NPCOP), .DMOP(DMOP));

endmodule
