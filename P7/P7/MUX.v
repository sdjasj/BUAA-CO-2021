`timescale 1ns / 1ps

module RFWDMUX (input [2:0] RFWDOP,
                input [31:0] DataToGrfFromMInW, 
                input [31:0] DMOUT,
                output [31:0] RFWD
    
);
        assign RFWD =   (RFWDOP==0)?DataToGrfFromMInW:
                        (RFWDOP==1)?DMOUT:0;
                        
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
                input [31:0] DataFromE, 
                input [31:0] DataFromM,
                input [31:0] DataFromW,
                input [31:0] DataFromD,
                output [31:0] RsToCmp  
);
        assign RsToCmp = (FWOP==3)?DataFromE:
                         (FWOP==2)?DataFromM:
                         (FWOP==1)?DataFromW:DataFromD;
endmodule //MUX





module  FWCMPRT(input [2:0] FWOP,
                input [31:0] DataFromE,
                input [31:0] DataFromM,
                input [31:0] DataFromW,
                input [31:0] DataFromD,
                output [31:0] RtToCmp  
);
        assign RtToCmp = (FWOP==3)?DataFromE:
                         (FWOP==2)?DataFromM:
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





module DMMUX (input DMWE,
              input [1:0] Addr,
              input [2:0] DMMUXOP,
              input [31:0] DataWaitToDecode,
              output reg [3:0] DMOPTODM,
              output reg [31:0] DataAfterDecode 

);
        always @(*) begin
                if (DMWE==0) begin
                       DMOPTODM = 0;
                       DataAfterDecode= DataWaitToDecode;
                end
                else begin
                        if (DMMUXOP==0) begin
                                DMOPTODM = 4'b1111;
                                DataAfterDecode = DataWaitToDecode;                
                        end
                        else if (DMMUXOP==1) begin
                                DMOPTODM = (Addr==0)?(4'b0001):
                                       (Addr==1)?(4'b0010):
                                       (Addr==2)?(4'b0100):
                                       (Addr==3)?(4'b1000):0;


                                DataAfterDecode = (Addr==0)?(DataWaitToDecode):
                                                  (Addr==1)?(DataWaitToDecode<<8):
                                                  (Addr==2)?(DataWaitToDecode<<16):
                                                  (Addr==3)?(DataWaitToDecode<<24):0;
                        end
                        else if (DMMUXOP==2) begin
                                DMOPTODM = (Addr==0)?(4'b0011):
                                       (Addr==2)?(4'b1100):0;


                                DataAfterDecode = (Addr==0)?(DataWaitToDecode):
                                                  (Addr==2)?(DataWaitToDecode<<16):0;
                        end
                        else begin // Invaild
                                DMOPTODM = 0;
                                DataAfterDecode= DataWaitToDecode;
                        end
                end
        end
endmodule //MUX




module EXTDMMUX ( input [1:0] Addr,
                  input [31:0] DataFromDM,
                  input [2:0] EXTDMOP,
                  output reg [31:0] Dout 
);

        reg [31:0] tempData;
        always @(*) begin
                if (EXTDMOP==0) begin
                        Dout = DataFromDM;
                end
                else if (EXTDMOP==1) begin
                        tempData = (Addr==0)?({{24{1'b0}},DataFromDM[7:0]}):
                                   (Addr==1)?({{24{1'b0}},DataFromDM[15:8]}):
                                   (Addr==2)?({{24{1'b0}},DataFromDM[23:16]}):
                                   (Addr==3)?({{24{1'b0}},DataFromDM[31:24]}):0;


                        Dout = {{24{1'b0}},tempData[7:0]};
                end
                else if (EXTDMOP==2) begin
                        tempData = (Addr==0)?({{24{1'b0}},DataFromDM[7:0]}):
                                   (Addr==1)?({{24{1'b0}},DataFromDM[15:8]}):
                                   (Addr==2)?({{24{1'b0}},DataFromDM[23:16]}):
                                   (Addr==3)?({{24{1'b0}},DataFromDM[31:24]}):0;

                        Dout = {{24{tempData[7]}},tempData[7:0]};
                end
                else if (EXTDMOP==3) begin
                        tempData = (Addr==0)?({{16{1'b0}},DataFromDM[15:0]}):
                                   (Addr==2)?({{16{1'b0}},DataFromDM[31:16]}):0;


                        Dout = {{16{1'b0}},tempData[15:0]};
                end
                else if (EXTDMOP==4) begin
                        tempData = (Addr==0)?({{16{1'b0}},DataFromDM[15:0]}):
                                   (Addr==2)?({{16{1'b0}},DataFromDM[31:16]}):0;


                        Dout = {{16{tempData[15]}},tempData[15:0]};
                end
                else begin
                        Dout = 0;
                end
        end
endmodule //MUX



module DataToGrfMux ( input [31:0] S0,
                      input [31:0] S1,
                      input [31:0] S2,
                      input [31:0] S3,
                      input [31:0] S4,
                      input [31:0] S5,
                      input [31:0] S6,
                      input [31:0] S7,
                      input [2:0] SELOP,
                      output[31:0] DATATOGRF    
        
);
        assign DATATOGRF = (SELOP==0)?S0:
                           (SELOP==1)?S1:
                           (SELOP==2)?S2:
                           (SELOP==3)?S3:
                           (SELOP==4)?S4:
                           (SELOP==5)?S5:
                           (SELOP==6)?S6:
                           (SELOP==7)?S7:0;
        


endmodule 