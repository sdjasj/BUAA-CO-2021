`timescale 1ns / 1ps
module PC(
    input [31:0] npc,
	 input reset,
	 input clk,
    output reg[31:0] pc
    );
	 initial pc<=32'h00003000;
	 always @(posedge clk) begin
		if (reset) begin
			pc<=32'h00003000;
		end
		else begin
			pc<=npc;
		end
	 end
endmodule
