`timescale 1ns / 1ps
module RFA3MUX ( input [2:0] RFA3OP,
                 input [4:0] rd,
                 input [4:0] rt,
                 output [4:0] A3
);
        assign A3 = (RFA3OP==0)?rd:
                    (RFA3OP==1)?rt:
                    (RFA3OP==2)?31:0;
endmodule 





module RFWDMUX (input [2:0] RFWDOP,
                input [31:0] ALUOUT,
                input [31:0] DMOUT,
                input [31:0] PCA4,
                output [31:0] RFWD
    
);
        assign RFWD =   (RFWDOP==0)?ALUOUT:
                        (RFWDOP==1)?DMOUT:
                        (RFWDOP==2)?PCA4:
                        (RFWDOP==3)?({{24{DMOUT[8]}},DMOUT[7:0]}):0;
                        
endmodule 





module ALUBMUX (input [2:0]ALUBOP,
                input [31:0] rt,
                input [31:0] IMM16,
                output [31:0] ALUB 
    
);
        assign ALUB =   (ALUBOP==0)?rt:
                        (ALUBOP==1)?IMM16:0;
endmodule //Untitled-2

