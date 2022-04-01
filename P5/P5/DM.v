`timescale 1ns / 1ps

`define SW 0
`define SB 1

module DM(
    input [2:0] DMOP,
    input [31:0] Address,
    input [31:0] Input,
    input clk,
    input Reset,
    input DMWE,
    input [31:0] PC,
    output [31:0] Data
    );
    reg  [31:0] WriteData;
    reg [31:0] datamem [3071:0];
    integer i;
    initial begin
        for (i = 0;i<3072 ;i=i+1 ) begin
            datamem[i]<=0;
        end
    end

    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0;i<3072 ;i=i+1 ) begin
                datamem[i]<=0;
            end
        end
        else if (DMWE) begin
            datamem[Address[14:2]]<=WriteData;
            $display("%d@%h: *%h <= %h", $time, PC, Address, WriteData);
        end

    end

    always @(*) begin
        if (DMOP==`SW) begin
            WriteData = Input;
        end
        else if (DMOP==`SB) begin
            if (Address[1:0]==0) begin
                WriteData = {datamem[Address[14:2]][31:8],Input[7:0]};
            end
            else if (Address[1:0]==1) begin
                WriteData = {datamem[Address[14:2]][31:16],Input[7:0],datamem[Address[11:2]][7:0]};
            end
            else if (Address[1:0]==2) begin
                WriteData = {datamem[Address[14:2]][31:24],Input[7:0],datamem[Address[11:2]][15:0]};
            end
            else if (Address[1:0]==3) begin
                WriteData = {Input[7:0],datamem[Address[14:2]][23:0]};
            end
        end
        else
            WriteData = 0;
    end



	 assign Data = datamem[Address[14:2]];
endmodule