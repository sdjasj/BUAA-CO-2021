`define LW 6'b100011
`define SW 6'b101011
`define LB 6'b100000
`define SB 6'b101000
`define LBU 6'b100100
`define LH 6'b100001
`define LHU 6'b100101
`define SH 6'b101001

module ERRORDECODE(
    input [31:0] Instr,
    input ADELOFPC,
    input RI,
    input OVINS,
    input OVFROMALU,
    input [31:0] ALUOUT,
    output [4:0] ERRORCODE
    );
    
    wire HalfWordAddrErr,WordAddrErr,TimeAddr,DMAddr,StoreToCount,AddrErr;
    wire ADELOFLOAD,ADES;
    wire LW,SW,LB,SB,LBU,LH,LHU,SH;

    assign LW = (Instr[31:26]==`LW)?1:0;
    assign SW = (Instr[31:26]==`SW)?1:0;
    assign LB = (Instr[31:26]==`LB)?1:0;
    assign SB = (Instr[31:26]==`SB)?1:0;
    assign LBU = (Instr[31:26]==`LBU)?1:0;
    assign LH = (Instr[31:26]==`LH)?1:0;
    assign LHU = (Instr[31:26]==`LHU)?1:0;
    assign SH = (Instr[31:26]==`SH)?1:0;

    assign WordAddrErr = ((ALUOUT[1:0] & 3)!=0)?1:0;
    assign HalfWordAddrErr = (ALUOUT[0]!=0)?1:0;
    assign TimeAddr = ((ALUOUT>=32'h7f00)&&(ALUOUT<=32'h7f0b))||((ALUOUT>=32'h7f10)&&(ALUOUT<=32'h7f1b));
    assign DMAddr = (ALUOUT>=0) && (ALUOUT<=32'h2fff);
    assign StoreToCount = TimeAddr && (ALUOUT[3:0]==8);
    assign AddrErr = ~(TimeAddr|DMAddr);


    assign ADELOFLOAD = (LW && (WordAddrErr || AddrErr || OVFROMALU))||
                        (LB && (OVFROMALU || AddrErr || TimeAddr))||
                        (LBU && (OVFROMALU || AddrErr || TimeAddr))||
                        (LH && (OVFROMALU || HalfWordAddrErr || AddrErr || TimeAddr))||
                        (LHU && (OVFROMALU || HalfWordAddrErr || AddrErr || TimeAddr));
    
    assign ADES = (SW && (OVFROMALU || AddrErr || WordAddrErr || StoreToCount))||
                  (SB && (OVFROMALU || AddrErr || TimeAddr))||
                  (SH && (OVFROMALU || AddrErr || TimeAddr || HalfWordAddrErr));
    

    

    assign ERRORCODE = (ADELOFPC)?5'h4:
                       (RI)?5'ha:
                       (OVINS && OVFROMALU)?5'hc:
                       (ADELOFLOAD)?5'h4:
                       (ADES)?5'h5:0;



endmodule