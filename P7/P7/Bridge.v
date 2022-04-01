`timescale 1ns / 1ps
module Bridge(
    input [31:0] AddrFromCPU,
    input WEFromCPU,
    input [31:0] DataFromCPU,
    input [31:0] DataToCPUFromDM,
    input [31:0] DataToCPUFromTime0,
    input [31:0] DataToCPUFromTime1,
    output DMWE,
    output Time0WE,
    output Time1WE,
    output [31:0] AddrToDM,
    output [31:0] AddrToTime0,
    output [31:0] AddrToTime1,
    output [31:0] DataToDM,
    output [31:0] DataToTime0,
    output [31:0] DataToTime1, 
    output [31:0] DataToCPU
    );

    wire HITDM,HITTIME0,HITTIME1;
    assign HITDM = (AddrFromCPU>=0) && (AddrFromCPU<=32'h2fff);
    assign HITTIME0 = (AddrFromCPU>=32'h7f00) && (AddrFromCPU<=32'h7f0b);
    assign HITTIME1 = (AddrFromCPU>=32'h7f10) && (AddrFromCPU<=32'h7f1b);

    //DM
    assign AddrToDM = AddrFromCPU;
    assign DMWE = WEFromCPU & HITDM;
    assign DataToDM = DataFromCPU;

    //Time0
    assign AddrToTime0 = AddrFromCPU;
    assign Time0WE = WEFromCPU & HITTIME0;
    assign DataToTime0 = DataFromCPU;

    //Time1
    assign AddrToTime1 = AddrFromCPU;
    assign Time1WE = WEFromCPU & HITTIME1;
    assign DataToTime1 = DataFromCPU;

    //DataToCPU
    assign DataToCPU = HITDM?(DataToCPUFromDM):
                       HITTIME0?(DataToCPUFromTime0):
                       HITTIME1?(DataToCPUFromTime1):0;


endmodule
