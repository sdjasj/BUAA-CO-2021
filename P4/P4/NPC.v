`timescale 1ns / 1ps

`define PCADD4 0
`define BEQ 1
`define JAL 2
`define JR 3
`define BGEZ 4


module NPC(
    input [31:0] PC,
    input [25:0] IMM26,
    input [15:0] IMM16,
    input [31:0] IMM32,
    input [2:0] NPCOP,
    input [4:0] Zero,
    output reg [31:0] NPC,
    output [31:0] PCA4
    );

    wire[31:0] IMM16_TO_IMM32 = {{16{IMM16[15]}},IMM16[15:0]};
    
    wire [31:0] IMM26_TO_IMM32 = {PC[31:28],IMM26[25:0],{2{1'b0}}};
    //pc+4
    assign PCA4 = PC + 4;

    //npc
    always @(*) begin
        if (NPCOP==`PCADD4) begin
            NPC <= PC + 4;
        end
        else if (NPCOP==`BEQ) begin
            NPC <= Zero[0]?(PC+4+(IMM16_TO_IMM32<<2)):(PC+4);
        end
        else if (NPCOP==`JAL) begin
            NPC <= IMM26_TO_IMM32;
        end
        else if (NPCOP==`JR) begin
            NPC <= IMM32;
        end
        else if (NPCOP==`BGEZ) begin
            NPC <= Zero[1]?(PC+4+(IMM16_TO_IMM32<<2)):(PC+4);
        end
    end
endmodule