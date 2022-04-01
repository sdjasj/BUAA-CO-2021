`timescale 1ns / 1ps

module GRF(
    input clk,
    input reset,
    input WE,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
	 input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 integer i;
	 reg [31:0] regis [31:0];
	 assign RD1 = ((A1==A3)&&WE&&A3)?WD:regis[A1];
	 assign RD2 = ((A2==A3)&&WE&&A3)?WD:regis[A2];
	 initial begin
			for (i = 0;i<=31;i=i+1) begin
				regis[i]<=0;
			end		 
	 end
	 
	 //$1--$31
	 always @(posedge clk) begin
		if (reset) begin
			for (i = 1;i<=31;i=i+1) begin
				regis[i]<=0;
			end
		end
		else if (WE&&(A3!=0)) begin
			regis[A3]<=WD;
		end
		else begin
			for (i = 1;i<=31;i=i+1) begin
				regis[i]<=regis[i];
			end
		end
	 end
	 
	 //$0
	 always @(posedge clk) begin
		if (reset)
			regis[0]<=0;
		else
			regis[0]<=0;
	 end
	 
	 
	 
endmodule