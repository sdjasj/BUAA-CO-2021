`timescale 1ns / 1ps

`define SIGN16 0
`define UNSIGN16 1


module EXT(
    input [1:0] EXTOP,
    input [15:0] IMM16,
    output [31:0] EXTOUT
    );
    assign EXTOUT = (EXTOP==`SIGN16)?({{16{IMM16[15]}},IMM16}):
                    (EXTOP==`UNSIGN16)?({{16{1'b0}},IMM16}):0;
						  
						  
endmodule