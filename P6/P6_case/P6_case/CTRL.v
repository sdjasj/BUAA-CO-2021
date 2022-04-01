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
`define BLTZ 6'b000001
`define BGTZ 6'b000111
`define BLEZ 6'b000110
`define BNE 6'b000101
`define AND 6'b100100
`define NOR 6'b100111
`define OR 6'b100101
`define SLT 6'b101010
`define SLLV 6'b000100
`define SLTU 6'b101011
`define SRAV 6'b000111
`define SRLV 6'b000110
`define SUB 6'b100010
`define XOR 6'b100110
`define SLTIU 6'b001011 




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
    output condB,
    output condW     
    );


    wire R,ADDU,SUBU,ORI,LW,SW,BEQ,LUI,SLL,J,JAL,JR,ADDIU,BGEZ,JALR;
    wire SLTI,LB,SB,ADD,ADDI,BLTZ,BGTZ,BLEZ,BNE,AND,NOR,OR,SLT,SLLV;
    wire SLTU,SRAV,SRLV,SUB,XOR,SLTIU;
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
    assign BGEZ = (OPCODE==`BGEZ)&&(InstrD[20:16]==1);
    assign JALR = (FUNC==`JALR)&R;
    assign SLTI = (OPCODE==`SLTI);
    assign LB = OPCODE==`LB;
    assign SB = OPCODE==`SB;
    assign ADD = (FUNC==`ADD)&R;
    assign ADDI = OPCODE==`ADDI;
    assign BLTZ = (OPCODE==`BLTZ)&&(InstrD[20:16]==0);
    assign BGTZ = OPCODE==`BGTZ;
    assign BLEZ = OPCODE==`BLEZ;
    assign BNE = OPCODE==`BNE;
    assign AND = (FUNC==`AND)&R;
    assign NOR = (FUNC==`NOR)&R;
    assign OR = (FUNC==`OR)&R;
    assign SLT = (FUNC==`SLT)&R;
    assign SLLV = (FUNC==`SLLV)&R;
    assign SLTU = (FUNC==`SLTU)&R;
    assign SRAV = (FUNC==`SRAV)&R;
    assign SRLV = (FUNC==`SRLV)&R;
    assign SUB = (FUNC==`SUB)&R;
    assign XOR = (FUNC==`XOR)&R;
    assign SLTIU = OPCODE==`SLTIU;

    //A3
    always @(*) begin
        if (ORI|LW|LUI|ADDIU|SLTI|LB|SLTI|ADDI|SLTIU) begin
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
    assign NPCOPD[0] = 0|BEQ|JR|JALR|BLTZ|BGTZ|BLEZ|BNE|BGEZ;

    //RFWE
    assign RFWE = 0|ADDU|SUBU|ORI|LW|LUI|SLL|JAL|ADDIU|JALR|SLTI|LB|ADD|ADDI|AND|NOR|SLT|SLLV|SLTU|SRAV|SRLV|SUB|XOR|OR|SLTIU;

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
    assign ALUBMUX[0] = 0|ORI|LW|SW|LUI|ADDIU|SLTI|LB|SB|ADDI|SLTIU;
	 
	 //ALUOP
	assign ALUOP[3] = 0|SLLV|SLTU|SRAV|SRLV|XOR|SLTIU;
	assign ALUOP[2] = 0|LUI|SLL|SLTI|NOR|SLT|XOR;
	assign ALUOP[1] = 0|ORI|SLTI|AND|NOR|OR|SLT|SRAV|SRLV;
	assign ALUOP[0] = 0|SUBU|SLL|AND|NOR|SLTU|SRLV|SUB|SLTIU;

     //DMOP
     assign DMOP[2] = 0;
     assign DMOP[1] = 0;
     assign DMOP[0] = 0|SB;

    //CMPOP
    assign CMPOP= (BEQ)?0:
                  (BGEZ)?1:
                  (BLTZ)?2:
                  (BGTZ)?3:
                  (BLEZ)?4:
                  (BNE)?5:6;

    assign TuseRs = (ADDU|SUBU|ORI|LW|SW|LUI|SLTI|ADDIU|ADD|ADDI|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUBU|XOR|SLTIU)?1:
                    (BEQ|JR|JALR|BGEZ|BLTZ|BGTZ|BLEZ|BNE)?0:4;
    
    assign TuseRt = (ADDU|SUBU|SLL|ADD|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUBU|XOR)?1:
                    (SW)?2:
                    (BEQ|BNE)?0:4;
    assign TnewE = (LW|JAL|JALR)?2:
                    (ADDU|SUBU|ORI|LUI|SLL|SLTI|ADDIU|ADD|ADDI|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUBU|XOR|SLTIU)?1:0;

endmodule