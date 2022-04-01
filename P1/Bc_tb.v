`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:28:37 10/21/2021
// Design Name:   BlockChecker
// Module Name:   D:/Verilog/P1_after_class/Bc_tb.v
// Project Name:  P1_after_class
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlockChecker
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Bc_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] in;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	BlockChecker uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		in = 0;
		#1 reset=1;
		#1 reset = 0;
		#3 in="b";
		#10 in=" ";
		#10 in="B";
		#10 in="E";
		#10 in="g";
		#10 in="i";
		#10 in="n";
		#10 in=" ";
		#10 in="e";
		#10 in ="n";
		#10 in ="d";
		#10 in ="e";
		#10 in = " ";
		#10 in="e";
		#10 in ="n";
		#10 in ="d";
		#10 in =" ";
		#10 in="e";
		#10 in ="n";
		#10 in ="d";
		#10 in=" ";
		#10 in=" ";
		#10 in="B";
		#10 in="E";
		#10 in="g";
		#10 in="i";
		#10 in="n";
		#10 in = " ";
	end
   always #5 clk=~clk; 
endmodule

