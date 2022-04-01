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
`define ANDI 6'b001100
`define SRL 6'b000010
`define SRA 6'b000011
`define XORI 6'b001110
`define LBU 6'b100100
`define LH 6'b100001
`define LHU 6'b100101
`define SH 6'b101001
`define MFHI 6'b010000
`define MFLO 6'b010010
`define MULT 6'b011000
`define MULTU 6'b011001
`define MTHI 6'b010001
`define MTLO 6'b010011
`define DIV 6'b011010
`define DIVU 6'b011011
`define MFC0 6'b010000
`define MTC0 6'b010000
`define ERET 6'b010000



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
    output [2:0] EXTDMOP,
    output [2:0] SELOP,
    output [3:0] MADOP, 
    output InsrtMAD,  
    output condB,
    output condW,
    output InsOfJump,
    output OVINS,
    output UNKNOWNINS,
    output CPZEROWE,
    output EXLCLR
    );


    wire RFWETEMP;

    wire R,ADDU,SUBU,ORI,LW,SW,BEQ,LUI,SLL,J,JAL,JR,ADDIU,BGEZ,JALR;   
    wire SLTI,LB,SB,ADD,ADDI,BLTZ,BGTZ,BLEZ,BNE,AND,NOR,OR,SLT,SLLV; 
    wire SLTU,SRAV,SRLV,SUB,XOR,SLTIU,ANDI,SRL,SRA,XORI,LBU,LH,LHU;
    wire SH,MFHI,MFLO,MULT,MULTU,MTHI,MTLO,DIV,DIVU,MFC0,MTC0,ERET;
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
    assign ANDI = OPCODE==`ANDI;
    assign SRL = (FUNC==`SRL)&R;
    assign SRA = (FUNC==`SRA)&R;
    assign XORI = OPCODE==`XORI;
    assign LBU = OPCODE==`LBU;
    assign LH = OPCODE==`LH;
    assign LHU = OPCODE ==`LHU;
    assign SH = OPCODE==`SH;
    assign MFHI = (FUNC==`MFHI)&R;
    assign MFLO = (FUNC==`MFLO)&R;
    assign MULT = (FUNC==`MULT)&R;
    assign MULTU = (FUNC==`MULTU)&R;
    assign MTHI = (FUNC==`MTHI)&R;
    assign MTLO = (FUNC==`MTLO)&R;
    assign DIV = (FUNC==`DIV)&R;
    assign DIVU = (FUNC==`DIVU)&R;
    assign MFC0 = (OPCODE==`MFC0)&&(InstrD[25:21]==5'b00000);
    assign MTC0 = (OPCODE==`MTC0)&&(InstrD[25:21]==5'b00100);
    assign ERET = (OPCODE==`ERET)&&(FUNC==6'b011000);

    //A3
    always @(*) begin
        if (ORI|LW|LUI|ADDIU|SLTI|LB|SLTI|ADDI|SLTIU|ANDI|XORI|LBU|LH|LHU|MFC0) begin
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
    assign RFWE = 0|ADDU|SUBU|ORI|LW|LUI|SLL|JAL|ADDIU|JALR|SLTI|LB|ADD|ADDI|AND|NOR|SLT|SLLV|SLTU|SRAV|SRLV|SUB|XOR|OR|SLTIU|RFWETEMP;
    assign RFWETEMP = 0|ANDI|SRA|SRL|XORI|LBU|LH|LHU|MFHI|MFLO|MFC0;


    //ExtopInD
    assign ExtopInD[1] = 0;
    assign ExtopInD[0] = 0|ORI|LUI|ANDI|XORI;

    //DmweToM
    assign DmweToM = 0|SW|SB|SH;

    //RFWDMUX
    assign RFWDMUX[2] = 0;
    assign RFWDMUX[1] = 0;
    assign RFWDMUX[0] = 0|LW|LB|LBU|LH|LHU;

    //ALUBMUX
    assign ALUBMUX[2] = 0;
    assign ALUBMUX[1] = 0;
    assign ALUBMUX[0] = 0|ORI|LW|SW|LUI|ADDIU|SLTI|LB|SB|ADDI|SLTIU|ANDI|XORI|LBU|LH|LHU|SH;
	 
	 //ALUOP
	assign ALUOP[3] = 0|SLLV|SLTU|SRAV|SRLV|XOR|SLTIU|SRL|SRA|XORI;
	assign ALUOP[2] = 0|LUI|SLL|SLTI|NOR|SLT|XOR|SRL|SRA|XORI;
	assign ALUOP[1] = 0|ORI|SLTI|AND|NOR|OR|SLT|SRAV|SRLV|ANDI|SRL;
	assign ALUOP[0] = 0|SUBU|SLL|AND|NOR|SLTU|SRLV|SUB|SLTIU|ANDI|SRA;

     //DMOP
     assign DMOP[2] = 0;
     assign DMOP[1] = 0|SH;
     assign DMOP[0] = 0|SB;

    //CMPOP
    assign CMPOP= (BEQ)?0:
                  (BGEZ)?1:
                  (BLTZ)?2:
                  (BGTZ)?3:
                  (BLEZ)?4:
                  (BNE)?5:6;
    
    //EXTDMOP
    assign EXTDMOP[2] = 0|LH;
    assign EXTDMOP[1] = 0|LB|LHU;
    assign EXTDMOP[0] = 0|LBU|LHU;


    //SELOP
    assign SELOP[2] = 0|MFC0;
    assign SELOP[1] = 0|MFHI|MFLO;
    assign SELOP[0] = 0|JAL|JALR|MFLO;

    //MADOP
    assign MADOP[3] = 0;
    assign MADOP[2] = 0|MTLO|DIV|DIVU;
    assign MADOP[1] = 0|MULTU|MTHI|DIVU;
    assign MADOP[0] = 0|MULT|MTHI|DIV;


    //condB
    assign condB = 0;


    //condW
    assign condW = 0;

    //InsrtMAD
    assign InsrtMAD = 0|MFHI|MFLO|MULT|MULTU|MTHI|MTLO|DIV|DIVU;


    //InsOfJump
    assign InsOfJump = 0|J|JAL|BEQ|JR|BGEZ|JALR|BLTZ|BGTZ|BLEZ|BNE;


    //OVINS
    assign OVINS = ADD|ADDI|SUB;


    //UNKNOWNINS
    assign UNKNOWNINS = ~(ADDU|SUBU|ORI|LW|SW|BEQ|LUI|SLL|J|JAL|JR|ADDIU|BGEZ|JALR|SLTI|LB|SB|ADD|ADDI|BLTZ|BGTZ|BLEZ|BNE|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUB|XOR|SLTIU|ANDI|SRL|SRA|XORI|LBU|LH|LHU|SH|MFHI|MFLO|MULT|MULTU|MTHI|MTLO|DIV|DIVU|MFC0|MTC0|ERET);

    assign CPZEROWE = 0|MTC0;

    assign EXLCLR = 0|ERET;

    //T
    assign TuseRs = (ADDU|SUBU|ORI|LW|SW|LUI|SLTI|ADDIU|ADD|ADDI|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUB|XOR|SLTIU|ANDI|LB|LBU|LH|LHU|SH|SB|MULT|MULTU|MTHI|MTLO|DIV|DIVU|XORI)?1:
                    (BEQ|JR|JALR|BGEZ|BLTZ|BGTZ|BLEZ|BNE)?0:4;
    
    assign TuseRt = (ADDU|SUBU|SLL|ADD|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUB|XOR|SRL|SRA|MULT|MULTU|DIV|DIVU|MTC0)?1:
                    (SW|SB|SH)?2:
                    (BEQ|BNE)?0:4;

    assign TnewE = (LW|LB|LBU|LH|LHU)?2:
                   (ADDU|SUBU|LUI|SLL|SLTI|ADDIU|ADD|ADDI|AND|NOR|OR|SLT|SLLV|SLTU|SRAV|SRLV|SUB|XOR|SLTIU|ANDI|ORI|SRL|SRA|XORI|MFHI|MFLO|MFC0)?1:0;

endmodule