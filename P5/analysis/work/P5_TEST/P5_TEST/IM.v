`timescale 1ns / 1ps
module IM(
    input [31:0] Addr,
    output [31:0] instr
    );
	 reg [31:0] instrmem [4095:0];
	 assign instr = instrmem[(Addr-32'h00003000)>>2];
	 
	 initial begin
			$readmemh("code.txt" , instrmem);
	 end
endmodule
