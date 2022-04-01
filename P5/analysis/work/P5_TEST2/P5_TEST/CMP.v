`timescale 1ns / 1ps
`define BEQ 4'b0000
`define BGEZ 4'b0001



module CMP(
    input [3:0] CMPOP,
    input [31:0] Rs,
    input [31:0] Rt,
    output reg Zero
    );
    always @(*) begin
        if (CMPOP==`BEQ) begin
            Zero = (Rs==Rt)?1:0;
        end
        else if (CMPOP==`BGEZ) begin
            Zero = ($signed(Rs)>=0)?1:0;
        end
        else
            Zero = 0;
    end

endmodule
