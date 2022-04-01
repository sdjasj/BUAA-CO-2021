`timescale 1ns / 1ps

`define PCADD4 0
`define B 1 //tyoe of Beq
`define JAL 2 //Type of Jal
`define JR 3 //Type of JR


module NPC(
    input [31:0] PC,
    input [31:0] PCIND,
    input [25:0] IMM26,//D
    input [15:0] IMM16,//D
    input [31:0] IMM32,//D
    input [2:0] NPCOP,//D
    input Zero,
    output reg [31:0] NPC,
    output [31:0] PCA4F
    );

    wire[31:0] IMM16_TO_IMM32 = {{16{IMM16[15]}},IMM16[15:0]};
    
    wire [31:0] IMM26_TO_IMM32 = {PCIND[31:28],IMM26[25:0],{2{1'b0}}};
    //pc+4
    assign PCA4F = PC + 4;

    //npc
    always @(*) begin
        if (NPCOP==`B) begin
            NPC = Zero?(PCIND+4+(IMM16_TO_IMM32<<2)):(PC+4);
        end
        else if (NPCOP==`JAL) begin
            NPC = IMM26_TO_IMM32;
        end
        else if (NPCOP==`JR) begin
            NPC = IMM32;
        end
        else
            NPC = PC+4;
    end
endmodule