`timescale 1ns / 1ps

//PCAS == PC+4
// == RS
// == Rt
module CPU(
    input clk,
    input reset,
	input [5:0] HWINT,
    input [31:0] i_inst_rdata, 
    input [31:0] m_data_rdata, 
    output [31:0] i_inst_addr, 
    output [31:0] m_data_addr, 
    output [31:0] m_data_wdata, 
    output [3 :0] m_data_byteen, 
    output [31:0] m_inst_addr, 
    output w_grf_we, 
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
	output [31:0] macroscopic_pc 
    );


	///wire
	//F

	
	wire [31:0] PCF,PCA4InF,NpcToPc,InstrInF;
	wire StallDandPCandClearE,ADELOFPCINF;
	//D
	wire [31:0] PCD,PCA4D,InstrD,EXTOUTD,RsInD,RtInD,RsToCmpD,RtToCmpD;
	wire RFWED,DMWED,ZeroFromCmp,InsrtMADInD,condBinD,condWinD,ADELOFPCIND,InsOfJumpIND,OVINSIND,UNKNOWNINSIND,CPZEROWEIND,EXLCLRIND,BDIND;
	wire [1:0] EXTOPD;
	wire [2:0] RFWDOPD,ALUBOPD,DMOPD,FWCMPRSSEL,FWCMPRTSEL,SELOPIND;
	wire [3:0] ALUOPD,CMPOPD,MADOPD;
	wire [4:0] A3D;
	wire [2:0] TuseRsD,TuseRtD,TnewDE,NPCOPD,EXTDMOPIND;
	//E
	wire [31:0] ALUBFromMux,ALUOUTINE,PCE,InstrE,EXTOUTE,RsInE,RtInE,RsFromFW,RtFromFW,HIFROMMAD,LOFROMMAD,DATATOGRFINE,PCFROMEPCINE,DataFromCP0INE,TruePCTOCP0;
	wire RFWEE,DMWEE,STARTINE,BUSYINE,condWinE,ADELOFPCINE,BDINE,OVINSINE,OverFlowINALUINE,EXLCLRINE,CPZEROWEINE,UNKNOWNINSINE,INTREQFROMCP0,TrueBDTOCP0;
	wire OUTSIDEINRINE;
	wire [2:0] TnewE,ALUBOPE,RFWDOPE,DMOPE,FWALURSSEL,FWALURTSEL,EXTDMOPINE,SELOPINE;
	wire [4:0] A3E,ERRORCODEINE;
	wire [3:0] ALUOPE,MADOPE;
	wire [1:0] EXTOPE;
	//M
	wire [31:0] PCM,InstrM,RtInM,ALUOUTINM,DMDATA,DMOUTM,DATATOGRFINM,DataAfterDecodeInM;
	wire RFWEM,DMWEM,condWinM,InsOfJumpINM,OUTSIDEINRINM;
	wire [4:0] A3M;
	wire [2:0] TnewM,DMOPM,RFWDOPM,FWDMRTSEL,EXTDMOPINM;
	wire [3:0] DMOPTODMINM;
	//W
	wire [31:0] PCW,InstrW,ALUOUTINW,DMOUTW,RfwdInMuxInW,DATATOGRFINW;
	wire RFWEW;
	wire [4:0] A3W;
	wire [2:0] RFWDOPW;


	assign macroscopic_pc = TruePCTOCP0;


	///module
	FWandSCTRL CPUFWandSCTRL(.A1D(InstrD[25:21]),
	 						 .A2D(InstrD[20:16]),
							 .A1E(InstrE[25:21]),
							 .A2E(InstrE[20:16]),
							 .A1M(InstrM[25:21]),
							 .A2M(InstrM[20:16]),
							 .A3E(A3E),
							 .A3M(A3M),
							 .A3W(A3W),
							 .WEE(RFWEE),
							 .WEM(RFWEM),
							 .WEW(RFWEW),
							 .InsrtMADInD(InsrtMADInD),
							 .BusyOrStart(STARTINE|BUSYINE),
							 .TuseRs(TuseRsD),
							 .TuseRt(TuseRtD),
							 .TnewE(TnewE),
							 .TnewM(TnewM),
							 .condWinE(condWinE), //涓嶅畾鍚戝啓
							 .condWinM(condWinM),
							 .INTEXC(EXLCLRINE|INTREQFROMCP0),
							 .FWCMPRS(FWCMPRSSEL), //OUT
							 .FWCMPRT(FWCMPRTSEL),
							 .FWALURS(FWALURSSEL),
							 .FWALURT(FWALURTSEL),
							 .FWDMRT(FWDMRTSEL),
							 .Stall(StallDandPCandClearE)
	);



	//F
	 NPC CPUNPC(.PC(PCF),
	 			.PCIND(PCD), 
	 			.IMM26(InstrD[25:0]), //D
				.IMM16(InstrD[15:0]), //D
				.IMM32(RsToCmpD),//D FROM FWMUX
				.NPCOP(NPCOPD), //D
				.Zero(ZeroFromCmp), // FROM CMP
				.PCFROMEPC(PCFROMEPCINE),
				.INTREQ(INTREQFROMCP0),
				.EXLCLR(EXLCLRINE),
				.NPC(NpcToPc), 
				.PCA4F(PCA4InF));	//F PCA4

	 PC CPUPC (.clk(clk),
	 		   .en(~StallDandPCandClearE),
	 		   .reset(reset),
			   .npc(NpcToPc),
			   .pc(PCF));	

	//EXCEPT OF PC
	assign ADELOFPCINF = (PCF[1:0]!=0) || (PCF<32'h3000) || (PCF>32'h6fff);



	assign  i_inst_addr = PCF;
	assign  InstrInF = i_inst_rdata;


	PipeD CPUPipeD(.clk(clk),
				   .reset(reset|EXLCLRIND|EXLCLRINE|INTREQFROMCP0),
				   .stall(StallDandPCandClearE),
				   .InstrInF(InstrInF),
				   .PCA4F(PCA4InF),
				   .PCF(PCF),
				   .ADELOFPCINF(ADELOFPCINF),
				   .BDINF(InsOfJumpIND),
				   .PCD(PCD),//out
				   .PCA4D(PCA4D),
				   .InstrInD(InstrD),
				   .ADELOFPCIND(ADELOFPCIND),
				   .BDIND(BDIND)
	);
	 //D
	 CTRL CPUCTRL(.InstrD(InstrD),//in
	 			  .NPCOPD(NPCOPD), // out
				  .RFWE(RFWED), 
				  .ExtopInD(EXTOPD), 
				  .DmweToM(DMWED),
				  .RFWDMUX(RFWDOPD), 
				  .ALUBMUX(ALUBOPD), 
				  .ALUOP(ALUOPD), 
				  .DMOP(DMOPD),
				  .A3(A3D),
				  .TuseRs(TuseRsD),
				  .TuseRt(TuseRtD),
				  .TnewE(TnewDE),
				  .CMPOP(CMPOPD),
				  .EXTDMOP(EXTDMOPIND),
				  .SELOP(SELOPIND),
				  .MADOP(MADOPD),
				  .InsrtMAD(InsrtMADInD),
				  .condB(condBinD),
				  .condW(condWinD),
				  .InsOfJump(InsOfJumpIND),
				  .OVINS(OVINSIND),
				  .UNKNOWNINS(UNKNOWNINSIND),
				  .CPZEROWE(CPZEROWEIND),
				  .EXLCLR(EXLCLRIND)		  
	);	   


	 EXT CPUEXT(.EXTOP(EXTOPD), 
	 			.IMM16(InstrD[15:0]), 
				.EXTOUT(EXTOUTD));



	 GRF CPUGRF(.clk(clk), 
	 			.reset(reset), 
				.WE(RFWEW),//W 
				.A1(InstrD[25:21]), 
				.A2(InstrD[20:16]), 
				.A3(A3W), //W
				.WD(RfwdInMuxInW), //W
				.PC(PCW), //W
				.RD1(RsInD), 
				.RD2(RtInD));



	FWCMPRS CPUFWCMPRS (.FWOP(FWCMPRSSEL),
						.DataFromE(PCE+8),
						.DataFromM(DATATOGRFINM),
						.DataFromW(RfwdInMuxInW),
						.DataFromD(RsInD),
						.RsToCmp(RsToCmpD)
	);

	FWCMPRT CPUFWCMPRT (.FWOP(FWCMPRTSEL),
						.DataFromE(PCE+8),
						.DataFromM(DATATOGRFINM),
						.DataFromW(RfwdInMuxInW),
						.DataFromD(RtInD),
						.RtToCmp(RtToCmpD)
	);


	
	 
	CMP CPUCMP(.CMPOP(CMPOPD),
			   .Rs(RsToCmpD),
			   .Rt(RtToCmpD),
			   .Zero(ZeroFromCmp)
	);

	PipeE CPUPipeE(.clk(clk),
				    .reset(StallDandPCandClearE|reset|EXLCLRINE|INTREQFROMCP0),
				    .PCD(PCD),
				    .InstrD(InstrD),
				    .RFWEInD(RFWED),
					.DMWEInD(DMWED),
					.A3InD(A3D),
					.IMM16EXTD(EXTOUTD),
					.TnewEinD(TnewDE),
					.RFWDMUXIND(RFWDOPD),
					.ALUBMUXIND(ALUBOPD),
					.ALUOPIND(ALUOPD),
					.EXTOPIND(EXTOPD),
					.DMOPIND(DMOPD),
					.RsInD(RsToCmpD),
					.RtInD(RtToCmpD),
					.EXTDMOPIND(EXTDMOPIND),
					.SELOPIND(SELOPIND),
					.MADOPD(MADOPD),
					.condWinD(condWinD),
					.ADELOFPCIND(ADELOFPCIND),
					.BDIND(BDIND),
					.OVINSIND(OVINSIND),
					.UNKNOWNINSIND(UNKNOWNINSIND),
					.CPZEROWEIND(CPZEROWEIND),
					.EXLCLRIND(EXLCLRIND),
					.PCE(PCE), //OUT
					.InstrE(InstrE),
					.RFWEInE(RFWEE),
					.DMWEInE(DMWEE),
					.A3InE(A3E),
					.IMM16EXTE(EXTOUTE),
					.TnewE(TnewE),
					.RFWDMUXINE(RFWDOPE),
					.ALUBMUXINE(ALUBOPE),
					.ALUOPINE(ALUOPE),
					.EXTOPINE(EXTOPE),
					.DMOPINE(DMOPE),
					.RsInE(RsInE),
					.RtInE(RtInE),
					.EXTDMOPINE(EXTDMOPINE),
					.SELOPINE(SELOPINE),
					.MADOPE(MADOPE),
					.condWinE(condWinE),
					.ADELOFPCINE(ADELOFPCINE),
					.BDINE(BDINE),
					.OVINSINE(OVINSINE),
					.UNKNOWNINSINE(UNKNOWNINSINE),
					.CPZEROWEINE(CPZEROWEINE),
					.EXLCLRINE(EXLCLRINE)

	);

	//E
	FWALURS CPUFWALURS (.FWOP(FWALURSSEL),
						.DataFromM(DATATOGRFINM),
						.DataFromW(RfwdInMuxInW),
						.DataFromE(RsInE),
						.RsToAlu(RsFromFW)
	);


	FWALURT CPUFWALURT(.FWOP(FWALURTSEL),
						.DataFromM(DATATOGRFINM),
						.DataFromW(RfwdInMuxInW),
						.DataFromE(RtInE),
						.RtToAlu(RtFromFW)
	);

	
	
	 ALUBMUX CPUALUBMUX(.ALUBOP(ALUBOPE), 
	 					.rt(RtFromFW), 
						.IMM16(EXTOUTE), 
						.ALUB(ALUBFromMux));
		 

		 
	 ALU CPUALU(.A(RsFromFW), 
	 			.B(ALUBFromMux), 
				.ALUOP(ALUOPE), 
				.SHAMT(InstrE[10:6]), 
				.ALUOUT(ALUOUTINE),
				.OverFlowINALU(OverFlowINALUINE)
);




	MulAndDiv CPUMulAndDiv(.clk(clk),
						   .reset(reset),
						   .MADOP(INTREQFROMCP0?4'b0:MADOPE),
						   .RS(RsFromFW),
						   .RT(RtFromFW),
						   .HI(HIFROMMAD),
						   .LO(LOFROMMAD),
						   .START(STARTINE),
						   .BUSY(BUSYINE)

	);
	

	ERRORDECODE CPUERRORDECODE(.Instr(InstrE),
							   .ADELOFPC(ADELOFPCINE),
							   .RI(UNKNOWNINSINE),
							   .OVINS(OVINSINE),
							   .OVFROMALU(OverFlowINALUINE),
							   .ALUOUT(ALUOUTINE),
							   .ERRORCODE(ERRORCODEINE) //OUT
	);




	assign TruePCTOCP0 = ((PCE!=0) || ADELOFPCINE)?PCE:
						 ((PCD!=0) || ADELOFPCIND)?PCD:PCF;


	assign TrueBDTOCP0 = ((PCE!=0) || ADELOFPCINE)?BDINE:
						 ((PCD!=0) || ADELOFPCIND)?BDIND:InsOfJumpIND;



	CP0 CPUCP0(.clk(clk),
			   .Reset(reset),
			   .ReadAddr(InstrE[15:11]),
			   .WriteAddr(InstrE[15:11]),
			   .DataToCP0(RtFromFW),
			   .IREXPC(TruePCTOCP0),
			   .EXCCODE(ERRORCODEINE),
			   .HWINT(HWINT),
			   .WE(CPZEROWEINE),
			   .EXLCLR(EXLCLRINE),
			   .BD(TrueBDTOCP0),
			   .INTREQ(INTREQFROMCP0),
			   .PCFROMEPC(PCFROMEPCINE),
			   .DataFromCP0(DataFromCP0INE),
			   .OUTSIDEINR(OUTSIDEINRINE)
	);




	DataToGrfMux CPUDataToGrfMuxINE(.S0(ALUOUTINE),
									.S1(PCE+8),
									.S2(HIFROMMAD),
									.S3(LOFROMMAD),
									.S4(DataFromCP0INE),
									.S5(0),
									.S6(0),
									.S7(0),
									.SELOP(SELOPINE),
									.DATATOGRF(DATATOGRFINE)

	);





	PipeM CPUPipeM(.clk(clk),
			  		.reset(reset|INTREQFROMCP0|EXLCLRINE),
					.PCE(PCE),
					.InstrE(InstrE),
					.RFWEInE(RFWEE),
					.DMWEInE(DMWEE),
					.A3InE(A3E),
					.TnewE(TnewE),
					.RFWDMUXINE(RFWDOPE),
					.DMOPINE(DMOPE),
					.RtFromE(RtFromFW),
					.ALUOUTINE(ALUOUTINE),
					.EXTDMOPINE(EXTDMOPINE),
					.DATATOGRFINE(DATATOGRFINE),
					.condWinE(condWinE),
					.OUTSIDEINRINE(OUTSIDEINRINE),
					.PCM(PCM),//OUT
					.InstrM(InstrM),
					.RFWEInM(RFWEM),
					.DMWEInM(DMWEM),
					.A3InM(A3M),
					.TnewM(TnewM),
					.RFWDMUXINM(RFWDOPM),
					.DMOPINM(DMOPM),
					.RtInM(RtInM),
					.ALUOUTINM(ALUOUTINM),
					.EXTDMOPINM(EXTDMOPINM),
					.DATATOGRFINM(DATATOGRFINM),
					.condWinM(condWinM),
					.OUTSIDEINRINM(OUTSIDEINRINM)
	);


	//M
	FWDRT CPUFWDRT (.FWOP(FWDMRTSEL),
					.DataFromM(RtInM),
					.DataFromW(RfwdInMuxInW),
					.WDToDM(DMDATA)
	);

	


	DMMUX CPUDMMUX (.DMWE(DMWEM),
					.Addr(ALUOUTINM[1:0]),
					.DMMUXOP(DMOPM),
					.DataWaitToDecode(DMDATA),
					.DMOPTODM(DMOPTODMINM),
					.DataAfterDecode(DataAfterDecodeInM)
	);



	//DM
	assign m_data_addr = OUTSIDEINRINM?32'h7f20:ALUOUTINM;
	assign m_data_wdata = DataAfterDecodeInM;
	assign m_data_byteen = OUTSIDEINRINM?1:DMOPTODMINM;
	assign m_inst_addr = PCM;




	EXTDMMUX CPUEXTDMMUX (.Addr(ALUOUTINM[1:0]),
						  .DataFromDM(m_data_rdata),
						  .EXTDMOP(EXTDMOPINM),
						  .Dout(DMOUTM)

	);

	


	PipeW CPUPipeW(.clk(clk),
					.reset(reset),
					.PCM(PCM),
					.InstrM(InstrM),
					.RFWEInM(RFWEM),
					.A3InM(A3M),
					.RFWDMUXINM(RFWDOPM),
					.ALUOUTINM(ALUOUTINM),
					.DMOUTM(DMOUTM),
					.DATATOGRFINM(DATATOGRFINM),
					.PCW(PCW),//OUT
					.InstrW(InstrW),
					.RFWEInW(RFWEW),
					.A3InW(A3W),
					.RFWDMUXINW(RFWDOPW),
					.ALUOUTINW(ALUOUTINW),
					.DMOUTW(DMOUTW),
					.DATATOGRFINW(DATATOGRFINW) 

	);

	
	//W				
	RFWDMUX CPURFWDMUX(.RFWDOP(RFWDOPW),
						.DMOUT(DMOUTW),
						.DataToGrfFromMInW(DATATOGRFINW),
						.RFWD(RfwdInMuxInW));
	

	// W GRF
	assign w_grf_we = RFWEW;
	assign w_grf_addr = A3W;
	assign w_grf_wdata = RfwdInMuxInW;
	assign w_inst_addr = PCW;
	 

endmodule
