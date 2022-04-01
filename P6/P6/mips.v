`timescale 1ns / 1ps

//PCAS == PC+4
// == RS
// == Rt
module mips(
    input clk,
    input reset,
    input [31:0] i_inst_rdata, //i_inst_addr 对应的 32 位指令
    input [31:0] m_data_rdata, //m_data_addr 对应的 32 位数据
    output [31:0] i_inst_addr, //需要进行取指操作的流水级 PC（一般为 F 级）
    output [31:0] m_data_addr, //数据存储器待写入地址
    output [31:0] m_data_wdata, //数据存储器待写入数据
    output [3 :0] m_data_byteen, //字节使能信号
    output [31:0] m_inst_addr, //M 级 PC
    output w_grf_we, //grf 写使能信号
    output [4:0] w_grf_addr, //grf 中待写入寄存器编号
    output [31:0] w_grf_wdata, //grf 中待写入数据
    output [31:0] w_inst_addr //W 级 PC
    );


	///wire
	//F

	
	 wire [31:0] PCF,PCA4InF,NpcToPc,InstrInF;
	 wire StallDandPCandClearE;
	//D
	wire [31:0] PCD,PCA4D,InstrD,EXTOUTD,RsInD,RtInD,RsToCmpD,RtToCmpD;
	wire RFWED,DMWED,ZeroFromCmp,InsrtMADInD,condBinD,condWinD;
	wire [1:0] EXTOPD;
	wire [2:0] RFWDOPD,ALUBOPD,DMOPD,FWCMPRSSEL,FWCMPRTSEL,SELOPIND;
	wire [3:0] ALUOPD,CMPOPD,MADOPD;
	wire [4:0] A3D;
	wire [2:0] TuseRsD,TuseRtD,TnewDE,NPCOPD,EXTDMOPIND;
	//E
	wire [31:0] ALUBFromMux,ALUOUTINE,PCE,InstrE,EXTOUTE,RsInE,RtInE,RsFromFW,RtFromFW,HIFROMMAD,LOFROMMAD,DATATOGRFINE;
	wire RFWEE,DMWEE,STARTINE,BUSYINE,condWinE;
	wire [2:0] TnewE,ALUBOPE,RFWDOPE,DMOPE,FWALURSSEL,FWALURTSEL,EXTDMOPINE,SELOPINE;
	wire [4:0] A3E;
	wire [3:0] ALUOPE,MADOPE;
	wire [1:0] EXTOPE;
	//M
	wire [31:0] PCM,InstrM,RtInM,ALUOUTINM,DMDATA,DMOUTM,DATATOGRFINM,DataAfterDecodeInM;
	wire RFWEM,DMWEM,condWinM;
	wire [4:0] A3M;
	wire [2:0] TnewM,DMOPM,RFWDOPM,FWDMRTSEL,EXTDMOPINM;
	wire [3:0] DMOPTODMINM;
	//W
	wire [31:0] PCW,InstrW,ALUOUTINW,DMOUTW,RfwdInMuxInW,DATATOGRFINW;
	wire RFWEW;
	wire [4:0] A3W;
	wire [2:0] RFWDOPW;

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
							 .condWinE(condWinE), //不定向写
							 .condWinM(condWinM),
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
				.NPC(NpcToPc), 
				.PCA4F(PCA4InF));	//F PCA4

	 PC CPUPC (.clk(clk),
	 		   .en(~StallDandPCandClearE),
	 		   .reset(reset),
			   .npc(NpcToPc),
			   .pc(PCF));	


	assign  i_inst_addr = PCF;
	assign  InstrInF = i_inst_rdata;


	PipeD CPUPipeD(.clk(clk),
				   .reset(reset),
				   .stall(StallDandPCandClearE),
				   .InstrInF(InstrInF),
				   .PCA4F(PCA4InF),
				   .PCF(PCF),
				   .PCD(PCD),//out
				   .PCA4D(PCA4D),
				   .InstrInD(InstrD)
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
				  .condW(condWinD)			  
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
				    .reset(StallDandPCandClearE|reset),
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
					.condWinE(condWinE)

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
				.ALUOUT(ALUOUTINE));




	MulAndDiv CPUMulAndDiv(.clk(clk),
						   .reset(reset),
						   .MADOP(MADOPE),
						   .RS(RsFromFW),
						   .RT(RtFromFW),
						   .HI(HIFROMMAD),
						   .LO(LOFROMMAD),
						   .START(STARTINE),
						   .BUSY(BUSYINE)

	);
	

	DataToGrfMux CPUDataToGrfMuxINE(.S0(ALUOUTINE),
									.S1(PCE+8),
									.S2(HIFROMMAD),
									.S3(LOFROMMAD),
									.S4(0),
									.S5(0),
									.S6(0),
									.S7(0),
									.SELOP(SELOPINE),
									.DATATOGRF(DATATOGRFINE)

	);


	



	PipeM CPUPipeM(.clk(clk),
			  		.reset(reset),
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
					.condWinM(condWinM)		
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
	assign m_data_addr = ALUOUTINM;
	assign m_data_wdata = DataAfterDecodeInM;
	assign m_data_byteen = DMOPTODMINM;
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
