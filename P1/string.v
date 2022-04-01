`timescale 1ns / 1ps

module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );
	 reg [2:0] cs;
	 reg myout;
	 assign out = myout;
	 localparam S0 = 0,S1 = 1,S2=2,S3=3,S4=4;
	 initial begin
		myout=0;
		cs=S0;
	 end
	 always @(posedge clk or posedge clr)begin
		if (clr) begin
			cs <= S0;
		end
		else begin
			case(cs)
				S0:begin
					if ("0"<=in&&in<="9")begin
						cs<=S1;
					end
					else
						cs<=S2;
				end
				S1:begin
					if ("0"<=in&&in<="9")
						cs<=S2;
					else
						cs<=S3;
				end
				S2:begin
					cs<=S2;
				end
				S3:begin
					if ("0"<=in&&in<="9")
						cs<=S4;
					else
						cs<=S2;
				end
				S4:begin
					if("0"<=in&&in<="9")
						cs<=S2;
					else
						cs<=S3;
				end
			endcase
		end
	 end
	 always @(cs)begin
		if ((cs==S1)||(cs==S4))
			myout<=1;
		else
			myout <=0;
	 end
	
endmodule
