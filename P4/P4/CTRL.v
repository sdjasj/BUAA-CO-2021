`timescale 1ns / 1ps
`define ADDU 6'b100001
`define SUBU 6'b100011
`define ORI 6'b001101
`define LW 6'b100011
`define SW 6'b101011
`define BEQ 6'b000100
`define LUI 6'b001111
`define SLL 6'b000000
`define J 6'b000010
`define JAL 6'b000011
`define JR 6'b001000
`define ADDIU 6'b001001
`define BGEZ 6'b000001
`define JALR 6'b001001
`define SLTI 6'b001010
`define LB 6'b100000
`define SB 6'b101000

module CTRL(
    input [5:0] OPCODE,
    input [5:0] FUNC,
    output [2:0] NPCOP,
    output RFWE,
    output [1:0] EXTOP,
    output DMWE,
    output [2:0] RFA3MUX,
    output [2:0] RFWDMUX,
    output [2:0] ALUBMUX,
	output [3:0] ALUOP,
    output [2:0] DMOP
    );
    wire R,ADDU,SUBU,ORI,LW,SW,BEQ,LUI,SLL,J,JAL,JR,ADDIU,BGEZ,JALR;
    wire SLTI,LB,SB;
    assign R = ~(|OPCODE);
    assign ADDU = (FUNC==`ADDU)&R;
    assign SUBU = (FUNC==`SUBU)&R;
    assign ORI = OPCODE==`ORI;
    assign LW = OPCODE==`LW;
    assign SW = OPCODE==`SW;
    assign BEQ = OPCODE==`BEQ;
    assign LUI = OPCODE==`LUI;
    assign SLL = (FUNC==`SLL)&R;
    assign J = OPCODE==`J;
    assign JAL = OPCODE==`JAL;
    assign JR = (FUNC==`JR)&R;
    assign ADDIU = OPCODE==`ADDIU;
    assign BGEZ = OPCODE==`BGEZ;
    assign JALR = (FUNC==`JALR)&R;
    assign SLTI = (OPCODE==`SLTI);
    assign LB = OPCODE==`LB;
    assign SB = OPCODE==`SB;

    //NPCOP
    assign NPCOP[2] = 0|BGEZ;
    assign NPCOP[1] = 0|J|JAL|JR|JALR;
    assign NPCOP[0] = 0|BEQ|JR|JALR;

    //RFWE
    assign RFWE = 0|ADDU|SUBU|ORI|LW|LUI|SLL|JAL|ADDIU|JALR|SLTI|LB;

    //EXTOP
    assign EXTOP[1] = 0;
    assign EXTOP[0] = 0|ORI|LUI;

    //DMWE
    assign DMWE = 0|SW|SB;


    //RFA3MUX
    assign RFA3MUX[2] = 0;
    assign RFA3MUX[1] = 0|JAL;
    assign RFA3MUX[0] = 0|ORI|LW|LUI|ADDIU|SLTI|LB;

    //RFWDMUX
    assign RFWDMUX[2] = 0;
    assign RFWDMUX[1] = 0|JAL|JALR|LB;
    assign RFWDMUX[0] = 0|LW|LB;

    //ALUBMUX
    assign ALUBMUX[2] = 0;
    assign ALUBMUX[1] = 0;
    assign ALUBMUX[0] = 0|ORI|LW|SW|LUI|ADDIU|SLTI|LB|SB;
	 
	 //ALUOP
	assign ALUOP[3] = 0;
	assign ALUOP[2] = 0|LUI|SLL|SLTI;
	assign ALUOP[1] = 0|ORI|SLTI;
	assign ALUOP[0] = 0|SUBU|SLL;

     //DMOP
     assign DMOP[2] = 0;
     assign DMOP[1] = 0;
     assign DMOP[0] = 0|SB;
endmodule