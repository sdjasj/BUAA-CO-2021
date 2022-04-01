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
`define ADD 6'b100000
`define ADDI 6'b001000



module CTRL(
    input [31:0] InstrD,
    output [2:0] NPCOPD,
    output RFWE,
    output [1:0] ExtopInD,
    output DmweToM,
    output [2:0] RFWDMUX,
    output [2:0] ALUBMUX,
	output [3:0] ALUOP,
    output [2:0] DMOP,
    output reg [4:0] A3,
    output [2:0] TuseRs,
    output [2:0] TuseRt,
    output [2:0] TnewE,
    output [3:0] CMPOP,
    output [1:0] DATATORFSEL,
    output condB,
    output condW     
    );


    wire R,ADDU,SUBU,ORI,LW,SW,BEQ,LUI,SLL,J,JAL,JR,ADDIU,BGEZ,JALR;
    wire SLTI,LB,SB,ADD,ADDI;
    wire [5:0] OPCODE,FUNC;
    assign OPCODE = InstrD[31:26];
    assign FUNC = InstrD[5:0];
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
    assign ADD = (FUNC==`ADD)&R;
    assign ADDI = OPCODE==`ADDI;

    //A3
    always @(*) begin
        if (ORI|LW|LUI|ADDIU|SLTI|LB|SLTI|ADDI) begin
            A3 = InstrD[20:16];
        end
        else if (JAL) begin
            A3 = 31;
        end
        else begin
            A3 = InstrD[15:11];
        end
    end

    //NPCOPD
    assign NPCOPD[2] = 0;
    assign NPCOPD[1] = 0|J|JAL|JR|JALR;
    assign NPCOPD[0] = 0|BEQ|JR|JALR;

    //RFWE
    assign RFWE = 0|ADDU|SUBU|ORI|LW|LUI|SLL|JAL|ADDIU|JALR|SLTI|LB|ADD|ADDI;

    //ExtopInD
    assign ExtopInD[1] = 0;
    assign ExtopInD[0] = 0|ORI|LUI;

    //DmweToM
    assign DmweToM = 0|SW|SB;

    //RFWDMUX
    assign RFWDMUX[2] = 0;
    assign RFWDMUX[1] = 0|JAL|JALR|LB;
    assign RFWDMUX[0] = 0|LW|LB;

    //ALUBMUX
    assign ALUBMUX[2] = 0;
    assign ALUBMUX[1] = 0;
    assign ALUBMUX[0] = 0|ORI|LW|SW|LUI|ADDIU|SLTI|LB|SB|ADDI;
	 
	 //ALUOP
	assign ALUOP[3] = 0;
	assign ALUOP[2] = 0|LUI|SLL|SLTI;
	assign ALUOP[1] = 0|ORI|SLTI;
	assign ALUOP[0] = 0|SUBU|SLL;

     //DMOP
     assign DMOP[2] = 0;
     assign DMOP[1] = 0;
     assign DMOP[0] = 0|SB;

    assign DATATORFSEL[1] = 0;
    assign DATATORFSEL[0] = 0|JAL|JALR;

    //CMPOP
    assign CMPOP= (BEQ)?0:
                  (BGEZ)?1:2;

    assign TuseRs = (ADDU|SUBU|ORI|LW|SW|LUI|SLTI|ADDIU|ADD|ADDI)?1:
                    (BEQ|JR|JALR)?0:4;
    
    assign TuseRt = (ADDU|SUBU|SLL|ADD)?1:
                    (SW)?2:
                    (BEQ)?0:4;
    assign TnewE = (LW)?2:
                    (ADDU|SUBU|ORI|LUI|SLL|SLTI|ADDIU|ADD|ADDI)?1:0;

endmodule