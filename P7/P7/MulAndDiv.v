`timescale 1ns / 1ps

`define MULT 4'b0001
`define MULTU 4'b0010
`define MTHI 4'b0011
`define MTLO 4'b0100
`define DIV 4'b0101
`define DIVU 4'b0110



module MulAndDiv(
    input clk,
    input reset,
    input [3:0] MADOP,
    input [31:0] RS,
    input [31:0] RT,
    output reg [31:0] HI,
    output reg [31:0] LO,
    output START,
    output BUSY
    );

    reg [31:0] tempHI,tempLO;
    integer DelayTime;

    // signal
    assign START = 0|(MADOP==`MULT)|(MADOP==`MULTU)|(MADOP==`DIV)|(MADOP==`DIVU);
    assign BUSY = (DelayTime>0)?1:0;

    initial begin
        HI<=0;
        LO<=0;
        tempHI<=0;
        tempLO<=0;
        DelayTime<=0;
    end


    //MUL AND DIV
    always @(posedge clk) begin
        if (reset) begin
            HI<=0;
            LO<=0; 
			tempHI<=0;
			tempLO<=0;
			DelayTime<=0;
        end
        else if (DelayTime>0) begin
            DelayTime <= DelayTime - 1;
            if (DelayTime==1) begin
                HI<=tempHI;
                LO<=tempLO;
            end
        end
        else if (MADOP==0) begin
            HI<=HI;
            LO<=LO;
        end        
        else if (MADOP==`MULT) begin
            {tempHI,tempLO} <= $signed(RS) * $signed(RT);
            DelayTime<=5;
        end
        else if (MADOP==`MULTU) begin
            {tempHI,tempLO} <= RS * RT;
            DelayTime <= 5;
        end
        else if (MADOP==`MTHI) begin
            HI<=RS;
        end
        else if (MADOP==`MTLO) begin
            LO<=RS;
        end
        else if (MADOP==`DIV) begin
            if (RT==0) begin
                HI<=HI;
                LO<=LO;
                DelayTime<=10;
            end
            else begin
                tempHI <= $signed(RS) % $signed(RT);
                tempLO <= $signed(RS) / $signed(RT);
                DelayTime <= 10;                
            end
        end
        else if (MADOP==`DIVU) begin
            if (RT==0) begin
                HI<=HI;
                LO<=LO;
                DelayTime<=10;
            end
            else begin
                tempHI <= RS % RT;
                tempLO <= RS / RT;
                DelayTime <= 10;
            end
        end
        else begin
            tempHI<=tempHI;
            tempLO<=tempLO;
            HI<=HI;
            LO<=LO;
        end
    end



endmodule
