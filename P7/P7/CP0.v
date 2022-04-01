`timescale 1ns / 1ps
module CP0(
    input clk,
    input Reset,
    input [4:0] ReadAddr,
    input [4:0] WriteAddr,
    input [31:0] DataToCP0,
    input [31:0] IREXPC,
    input [4:0] EXCCODE,
    input [5:0] HWINT,
    input WE,
    input EXLCLR,
    input BD,
    output INTREQ,
    output [31:0] PCFROMEPC,
    output [31:0] DataFromCP0,
    output OUTSIDEINR
    );

    reg [31:0] SR,Cause, EPC,PRID;
    wire Exception, Interrupt;

    assign Exception = ((EXCCODE==4)||(EXCCODE==5)||(EXCCODE==10)||(EXCCODE==12)) && (~SR[1]);
    assign Interrupt = (|(SR[15:10]&HWINT)) && (~SR[1]) && (SR[0]);
    assign INTREQ = Exception|Interrupt;

    assign OUTSIDEINR = Interrupt&HWINT[2]&SR[12];

    assign DataFromCP0 = (ReadAddr==12)?SR:
                         (ReadAddr==13)?Cause:
                         (ReadAddr==14)?EPC:
                         (ReadAddr==15)?PRID:0;

    assign PCFROMEPC = EPC;

    initial begin
        SR<=32'hfc01;
        Cause<=0;
        EPC<=0;
        PRID<=32'd114514;        
    end
    
    always @(posedge clk) begin
        if (Reset) begin
            SR<=32'hfc01;
            Cause<=0;
            EPC<=0;
            PRID<=32'd114514;
        end
        else begin
            Cause[15:10]<=HWINT;
            if (EXLCLR) begin
                SR[1]<=1'b0;
            end
            else if (INTREQ) begin
                SR[1]<=1'b1;
                Cause <= {BD,15'b0,HWINT,3'b0,Interrupt?5'b0:EXCCODE,2'b0};
                if (BD) begin
                    EPC<=IREXPC-4;
                end
                else begin
                    EPC<=IREXPC;
                end
            end
            else if (WE) begin // not interrupt cai write
                if (WriteAddr==12) begin
                    SR<=DataToCP0;
                end
                else if (WriteAddr==14) begin
                    EPC<=DataToCP0;
                end
            end
        end

    end

endmodule
