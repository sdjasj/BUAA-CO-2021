`timescale 1ns / 1ps
module PipeD (
    input  clk,
    input reset,
    input stall, 
    input [31:0] InstrInF,
    input [31:0] PCA4F,
    input [31:0] PCF,
    input ADELOFPCINF,
    input BDINF,
    output reg [31:0] PCD,
    output reg [31:0] PCA4D,
    output reg [31:0] InstrInD,
    output reg  ADELOFPCIND,
    output reg  BDIND
);
    initial begin
        PCD<=0;
        PCA4D<=0;
        InstrInD<=0;
        ADELOFPCIND<=0;
        BDIND<=0;        
    end



    always @(posedge clk) begin
        if (reset) begin
            PCD<=0;
            PCA4D<=0;
            InstrInD<=0;
            ADELOFPCIND<=0;
            BDIND<=0;
        end
        else if (!stall) begin
            PCD<=PCF;
            PCA4D<=PCA4F;
            InstrInD<=InstrInF;
            ADELOFPCIND<=ADELOFPCINF;
            BDIND<=BDINF;
        end
        else begin
            PCD<=PCD;
            PCA4D<=PCA4D;
            InstrInD<=InstrInD;
            ADELOFPCIND<=ADELOFPCIND;
            BDIND<=BDIND;
        end
    end

endmodule //PipeLineReg


module PipeE (
    input clk,
    input reset,
    input [31:0] PCD,
    input [31:0] InstrD,
    input RFWEInD,
    input DMWEInD,
    input [4:0] A3InD,
    input [31:0] IMM16EXTD,
    input [2:0] TnewEinD,
    input [2:0] RFWDMUXIND,
    input [2:0] ALUBMUXIND,
    input [3:0] ALUOPIND,
    input [1:0] EXTOPIND,
    input [2:0] DMOPIND,
    input [31:0] RsInD,
    input [31:0] RtInD,
    input [2:0] EXTDMOPIND,
    input [2:0] SELOPIND,
    input [3:0] MADOPD, 
    input condWinD,
    input ADELOFPCIND,
    input BDIND,
    input OVINSIND,
    input UNKNOWNINSIND,
    input CPZEROWEIND,
    input EXLCLRIND, 
    output reg [31:0] PCE,
    output reg [31:0] InstrE,
    output reg RFWEInE,
    output reg DMWEInE,
    output reg [4:0] A3InE,
    output reg [31:0] IMM16EXTE, 
    output reg [2:0] TnewE,
    output reg [2:0] RFWDMUXINE,
    output reg [2:0] ALUBMUXINE,
    output reg [3:0] ALUOPINE,
    output reg [1:0] EXTOPINE,
    output reg [2:0] DMOPINE,
    output reg [31:0] RsInE,
    output reg [31:0] RtInE,
    output reg [2:0] EXTDMOPINE, 
    output reg [2:0] SELOPINE, 
    output reg [3:0] MADOPE, 
    output reg condWinE,
    output reg ADELOFPCINE,
    output reg BDINE,
    output reg OVINSINE,
    output reg UNKNOWNINSINE,
    output reg CPZEROWEINE,
    output reg EXLCLRINE  
);
    initial begin
        PCE<=0;
        InstrE<=0;
        RFWEInE<=0;
        DMWEInE<=0;
        A3InE<=0;
        IMM16EXTE<=0;
        TnewE<=0;
        RFWDMUXINE<=0;
        ALUBMUXINE<=0;
        ALUOPINE<=0;
        EXTOPINE<=0;
        DMOPINE<=0;
        RsInE<=0;
        RtInE<=0;
        condWinE<=0;
        EXTDMOPINE<=0;
        SELOPINE<=0;
        MADOPE<=0;
        ADELOFPCINE<=0;
        BDINE<=0;
        OVINSINE<=0;
        UNKNOWNINSINE<=0;
        CPZEROWEINE<=0;
        EXLCLRINE<=0;       
    end
    always @(posedge clk) begin
        if (reset) begin
            PCE<=0;
            InstrE<=0;
            RFWEInE<=0;
            DMWEInE<=0;
            A3InE<=0;
            IMM16EXTE<=0;
            TnewE<=0;
            RFWDMUXINE<=0;
            ALUBMUXINE<=0;
            ALUOPINE<=0;
            EXTOPINE<=0;
            DMOPINE<=0;
            RsInE<=0;
            RtInE<=0;
            condWinE<=0;
            EXTDMOPINE<=0;
            SELOPINE<=0;
            MADOPE<=0;
            ADELOFPCINE<=0;
            BDINE<=0;
            OVINSINE<=0;
            UNKNOWNINSINE<=0;
            CPZEROWEINE<=0;
            EXLCLRINE<=0; 
        end
        else begin
            PCE<=PCD;
            InstrE<=InstrD;
            RFWEInE<=RFWEInD;
            DMWEInE<=DMWEInD;
            A3InE<=A3InD;
            IMM16EXTE<=IMM16EXTD;
            TnewE<=TnewEinD;
            RFWDMUXINE<=RFWDMUXIND;
            ALUBMUXINE<=ALUBMUXIND;
            ALUOPINE<=ALUOPIND;
            EXTOPINE<=EXTOPIND;
            DMOPINE<=DMOPIND;
            RsInE<=RsInD;
            RtInE<=RtInD;
            condWinE<=condWinD;
            EXTDMOPINE<=EXTDMOPIND;
            SELOPINE<=SELOPIND; 
            MADOPE<=MADOPD;
            ADELOFPCINE<=ADELOFPCIND;
            BDINE<=BDIND;
            OVINSINE<=OVINSIND;
            UNKNOWNINSINE<=UNKNOWNINSIND;
            CPZEROWEINE<=CPZEROWEIND;
            EXLCLRINE<=EXLCLRIND; 
        end
    end
endmodule //PipeLineReg

module PipeM (
    input clk,
    input reset,
    input [31:0] PCE,
    input [31:0] InstrE,
    input RFWEInE,
    input DMWEInE,
    input [4:0] A3InE,
    input [2:0] TnewE,
    input [2:0] RFWDMUXINE,
    input [2:0] DMOPINE,
    input [31:0] RtFromE,
    input [31:0] ALUOUTINE,
    input [2:0] EXTDMOPINE, 
    input [31:0] DATATOGRFINE,
    input condWinE,
    input OUTSIDEINRINE,
    output reg [31:0] PCM,
    output reg [31:0] InstrM,
    output reg RFWEInM,
    output reg DMWEInM,
    output reg [4:0] A3InM,
    output reg [2:0] TnewM,
    output reg [2:0] RFWDMUXINM,
    output reg [2:0] DMOPINM,
    output reg [31:0] RtInM,
    output reg [31:0] ALUOUTINM,
    output reg [2:0] EXTDMOPINM,
    output reg [31:0] DATATOGRFINM,  
    output reg condWinM,
    output reg OUTSIDEINRINM    
);
    initial begin
        PCM<=0;
        InstrM<=0;
        RFWEInM<=0;
        DMWEInM<=0;
        A3InM<=0;
        TnewM<=0;
        RFWDMUXINM<=0; 
        DMOPINM<=0;
        RtInM<=0;
        ALUOUTINM<=0;
        condWinM<=0;
        EXTDMOPINM<=0;
        DATATOGRFINM<=0;
        OUTSIDEINRINM<=0;       
    end


    always @(posedge clk) begin
        if (reset) begin
            PCM<=0;
            InstrM<=0;
            RFWEInM<=0;
            DMWEInM<=0;
            A3InM<=0;
            TnewM<=0;
            RFWDMUXINM<=0;
            DMOPINM<=0;
            RtInM<=0;
            ALUOUTINM<=0;
            condWinM<=0;
            EXTDMOPINM<=0;
            DATATOGRFINM<=0;
            OUTSIDEINRINM<=OUTSIDEINRINE;
        end
        else begin
            PCM<=PCE;
            InstrM<=InstrE;
            RFWEInM<=RFWEInE;
            DMWEInM<=DMWEInE;
            A3InM<=A3InE;
            TnewM<=(TnewE)?(TnewE-1):0;
            RFWDMUXINM<=RFWDMUXINE;
            DMOPINM<=DMOPINE;
            RtInM<=RtFromE;
            ALUOUTINM<=ALUOUTINE;
            condWinM<=condWinE;
            EXTDMOPINM<=EXTDMOPINE;
            DATATOGRFINM<=DATATOGRFINE;
            OUTSIDEINRINM<=OUTSIDEINRINE;
        end
    end
endmodule //PipeLineReg

module PipeW (
    input clk,
    input reset,
    input [31:0] PCM,
    input [31:0] InstrM,
    input RFWEInM,
    input [4:0] A3InM,
    input [2:0] RFWDMUXINM,
    input [31:0] ALUOUTINM,
    input [31:0] DMOUTM, 
    input [31:0] DATATOGRFINM,
    output reg [31:0] PCW,
    output reg [31:0] InstrW,
    output reg RFWEInW,
    output reg [4:0] A3InW,
    output reg [2:0] RFWDMUXINW,
    output reg [31:0] ALUOUTINW,
    output reg [31:0] DMOUTW,
    output reg [31:0] DATATOGRFINW   
);
    initial begin
        PCW<=0;
        InstrW<=0;
        RFWEInW<=0;
        A3InW<=0;
        RFWDMUXINW<=0;
        ALUOUTINW<=0;
        DMOUTW<=0;
        DATATOGRFINW<=0;        
    end
    always @(posedge clk) begin
        if (reset) begin
            PCW<=0;
            InstrW<=0;
            RFWEInW<=0;
            A3InW<=0;
            RFWDMUXINW<=0;
            ALUOUTINW<=0;
            DMOUTW<=0;
            DATATOGRFINW<=0;
        end
        else begin
            PCW<=PCM;
            InstrW<=InstrM;
            RFWEInW<=RFWEInM;
            A3InW<=A3InM;
            RFWDMUXINW<=RFWDMUXINM;
            ALUOUTINW<=ALUOUTINM;
            DMOUTW<=DMOUTM;
            DATATOGRFINW<=DATATOGRFINM;
        end
    end
endmodule //PipeLineReg
