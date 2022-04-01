`timescale 1ns / 1ps
`define CMPFROME 3
`define CMPFROMM 2
`define CMPFROMW 1
`define CMPFROMD 0
`define ALUFROMM 2
`define ALUFROMW 1
`define ALUFROME 0



module FWandSCTRL(
    input [4:0] A1D,
    input [4:0] A2D,
    input [4:0] A1E,
    input [4:0] A2E,
    input [4:0] A1M,
    input [4:0] A2M,
    input [4:0] A3E,
    input [4:0] A3M,
    input [4:0] A3W,
    input WEE, 
    input WEM,
    input WEW,
    input [2:0] TuseRs,
    input [2:0] TuseRt,
    input [2:0] TnewE,
    input [2:0] TnewM,
    output [2:0] FWCMPRS,
    output [2:0] FWCMPRT,
    output [2:0] FWALURS,
    output [2:0] FWALURT,
    output [2:0] FWDMRT,
    output Stall 
    );
	// FW
    //FWCMP
    assign FWCMPRS = (A1D==A3E && WEE && A3E)?`CMPFROME:
                     (A1D==A3M && WEM && A3M)?`CMPFROMM:
                     (A1D==A3W && WEW && A3W)?`CMPFROMW:`CMPFROMD; 

    assign FWCMPRT = (A2D==A3E && WEE && A3E)?`CMPFROME:
                     (A2D==A3M && WEM && A3M)?`CMPFROMM:
                     (A2D==A3W && WEW && A3W)?`CMPFROMW:`CMPFROMD;

    //FWALURS
    assign FWALURS = (A1E==A3M && WEM && A3M)?`ALUFROMM:
                     (A1E==A3W && WEW && A3W)?`ALUFROMW:`ALUFROME;

    assign FWALURT = (A2E==A3M && WEM && A3M)?`ALUFROMM:
                     (A2E==A3W && WEW && A3W)?`ALUFROMW:`ALUFROME; 

    //FWDMRT
    assign FWDMRT = (A2M==A3W && WEW && A3W)?1:0;    


    //Stall
    wire StallRsE,StallRsM,StallRtE,StallRtM;
    assign StallRsE = (TuseRs<TnewE) && (A1D) && (A1D==A3E) &&WEE;
    assign StallRsM = (TuseRs<TnewM) && (A1D) && (A1D==A3M) && WEM;
    assign StallRtE = (TuseRt<TnewE) && (A2D) && (A2D==A3E) && WEE;
    assign StallRtM = (TuseRt<TnewM) && (A2D) && (A2D==A3M) && WEM;
    assign Stall = StallRsE|StallRsM|StallRtE|StallRtM;

endmodule
