`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:53:48 10/21/2021
// Design Name:   string
// Module Name:   D:/Verilog/P1_after_class/string_tb.v
// Project Name:  P1_after_class
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: string
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module string_tb;

	// Inputs
	reg clk;
	reg clr;
	reg [7:0] in;
	wire out;

	// Instantiate the Unit Under Test (UUT)
	string uut (
		.clk(clk), 
		.clr(clr), 
		.in(in), 
		.out(out)
	);

	initial begin
	clk = 0;
	clr = 0;
	#5 in = "1";
	#10 in = "+";
	#10 in = "1";
	#10 in = "*";
	#10 in = "2";
	#10 in = "2";
	#5 clr = 1;
	#5 clr = 0;
	#10 in = "1";
	#10 in = "*";
	#10 in = "2";
	end
    always #5 clk = ~clk;
endmodule

