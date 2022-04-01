`timescale 1ns / 1ps

//PCAS == PC+4
// == RS
// == Rt
module mips(
    input clk,
    input reset
    );
	///wire
	//F
	 wire [31:0] PCF,PCA4InF,NpcToPc,InstrInF;
	 wire StallDandPCandClearE;
	//D
	wire [31:0] PCD,PCA4D,InstrD,EXTOUTD,RsInD,RtInD,RsToCmpD,RtToCmpD;
	wire RFWED,DMWED,ZeroFromCmp;
	wire [1:0] EXTOPD;
	wire [2:0] RFWDOPD,ALUBOPD,DMOPD,FWCMPRSSEL,FWCMPRTSEL;
	wire [3:0] ALUOPD,CMPOPD;
	wire [4:0] A3D;
	wire [2:0] TuseRsD,TuseRtD,TnewDE,NPCOPD;
	//E
	wire [31:0] ALUBFromMux,ALUOUTINE,PCE,InstrE,EXTOUTE,RsInE,RtInE,RsFromFW,RtFromFW;
	wire RFWEE,DMWEE;
	wire [2:0] TnewE,ALUBOPE,RFWDOPE,DMOPE,FWALURSSEL,FWALURTSEL;
	wire [4:0] A3E;
	wire [3:0] ALUOPE;
	wire [1:0] EXTOPE;
	//M
	wire [31:0] PCM,InstrM,RtInM,ALUOUTINM,DMDATA,DMOUTM;
	wire RFWEM,DMWEM;
	wire [4:0] A3M;
	wire [2:0] TnewM,DMOPM,RFWDOPM,FWDMRTSEL;
	//W
	wire [31:0] PCW,InstrW,ALUOUTINW,DMOUTW,RfwdInMuxInW;
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
							 .TuseRs(TuseRsD),
							 .TuseRt(TuseRtD),
							 .TnewE(TnewE),
							 .TnewM(TnewM),
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


	 

	IM CPUIM(.Addr(PCF),
	 		 .instr(InstrInF));	


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
				  .condB(),
				  .condW()			  
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
						.PCA8(PCE+8),
						.DataFromM(ALUOUTINM),
						.DataFromW(RfwdInMuxInW),
						.DataFromD(RsInD),
						.RsToCmp(RsToCmpD)
	);

	FWCMPRT CPUFWCMPRT (.FWOP(FWCMPRTSEL),
						.PCA8(PCE+8),
						.DataFromM(ALUOUTINM),
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
					.RsInD(RsInD),
					.RtInD(RtInD),
					.condWinD(0),
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
					.condWinE()

	);

	//E
	FWALURS CPUFWALURS (.FWOP(FWALURSSEL),
						.DataFromM(ALUOUTINM),
						.DataFromW(RfwdInMuxInW),
						.DataFromE(RsInE),
						.RsToAlu(RsFromFW)
	);


	FWALURT CPUFWALURT(.FWOP(FWALURTSEL),
						.DataFromM(ALUOUTINM),
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
					.condWinE(0),
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
					.condWinM()		
	);


	//M
	FWDRT CPUFWDRT (.FWOP(FWDMRTSEL),
					.DataFromM(RtInM),
					.DataFromW(RfwdInMuxInW),
					.WDToDM(DMDATA)
	);


	 DM CPUDM(.clk(clk), 
	 		  .Reset(reset), 
		 	  .DMOP(DMOPM), 
	 		  .Address(ALUOUTINM), 
			  .Input(DMDATA),
			  .DMWE(DMWEM), 
			  .PC(PCM), 
			  .Data(DMOUTM));

	PipeW CPUPipeW(.clk(clk),
					.reset(reset),
					.PCM(PCM),
					.InstrM(InstrM),
					.RFWEInM(RFWEM),
					.A3InM(A3M),
					.RFWDMUXINM(RFWDOPM),
					.ALUOUTINM(ALUOUTINM),
					.DMOUTM(DMOUTM),
					.PCW(PCW),//OUT
					.InstrW(InstrW),
					.RFWEInW(RFWEW),
					.A3InW(A3W),
					.RFWDMUXINW(RFWDOPW),
					.ALUOUTINW(ALUOUTINW),
					.DMOUTW(DMOUTW) 

	);

	
	//W				
	RFWDMUX CPURFWDMUX(.RFWDOP(RFWDOPW),
	 					.ALUOUT(ALUOUTINW), 
						.DMOUT(DMOUTW), 
						.PCA8(PCW+8), 
						.RFWD(RfwdInMuxInW));
	 
	



	 

endmodule
