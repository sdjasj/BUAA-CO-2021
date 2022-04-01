`timescale 1ns / 1ps

module RFWDMUX (input [2:0] RFWDOP,
                input [31:0] ALUOUT,
                input [31:0] DMOUT,
                input [31:0] PCA8,
                output [31:0] RFWD
    
);
        assign RFWD =   (RFWDOP==0)?ALUOUT:
                        (RFWDOP==1)?DMOUT:
                        (RFWDOP==2)?PCA8:
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



module  FWCMPRS(input [2:0] FWOP,
                input [31:0] DataFromM,
                input [31:0] DataFromW,
                input [31:0] DataFromD,
                output [31:0] RsToCmp  
);
        assign RsToCmp = (FWOP==2)?DataFromM:
                         (FWOP==1)?DataFromW:DataFromD;
endmodule //MUX

module FWCMPRT(input [2:0] FWOP,
                input [31:0] DataFromM,
                input [31:0] DataFromW,
                input [31:0] DataFromD,
                output [31:0] RtToCmp  
);
        assign RtToCmp = (FWOP==2)?DataFromM:
                         (FWOP==1)?DataFromW:DataFromD;
endmodule //MUX


module FWALURS (input [2:0] FWOP,
                input [31:0] DataFromM,
                input [31:0] DataFromW,
                input [31:0] DataFromE,
                output [31:0] RsToAlu 
        
);     
        assign RsToAlu = (FWOP==2)?(DataFromM):
                         (FWOP==1)?DataFromW:DataFromE;

endmodule //MUX



module FWALURT(input [2:0] FWOP,
                input [31:0] DataFromM,
                input [31:0] DataFromW,
                input [31:0] DataFromE,
                output [31:0] RtToAlu 
        
);
        assign RtToAlu = (FWOP==2)?(DataFromM):
                         (FWOP==1)?DataFromW:DataFromE;

endmodule //MUX


module FWDRT (input [2:0] FWOP,
              input [31:0] DataFromM,
              input [31:0] DataFromW,
              output [31:0] WDToDM 
        
);
        assign WDToDM = (FWOP==1)?DataFromW:DataFromM;


endmodule //MUX
