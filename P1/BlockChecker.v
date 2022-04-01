`timescale 1ns / 1ps
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );
	 localparam S0 = 0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13;
	reg [3:0] cs;
	reg[31:0] cbegin,cend;
	reg flag;
	assign result = (flag==1)?0:
						 (cbegin==cend)?1:0;
	always @(cbegin or cend or cs)begin
		if ((cend>cbegin)&&(cs==S0))
			flag <=1;
		else 
			flag <= flag;
	end
	always @(posedge clk or posedge reset)begin
		if (reset)begin
			cbegin <= 0;
			cend<=0;
			cs<=S0;
			flag<=0;
		end
		else begin
			case(cs)
				S0:begin
					if (in==" ")
						cs<=S0;
					else if (in=="b"||in=="B")
						cs<=S1;
					else if (in=="E"||in=="e")
						cs<=S8;
					else
						cs<=S7;
				
				end
				S1:begin
					if (in=="E"||in=="e")
						cs<=S2;
					else if (in==" ")
						cs<=S0;
					else
						cs<=S7;
				
				end
				S2:begin
					if (in=="g"||in=="G")
						cs<=S3;
					else if (in==" ")
						cs<=S0;
					else 
						cs<=S7;
				
				end
			   S3:begin
					if (in=="i"||in=="I")
						cs<=S4;
					else if (in==" ")
						cs<=S0;
					else 
						cs<= S7;
				
				end
				S4:begin
					if (in=="n"||in==="N")begin
						cbegin<=cbegin+1;
						cs<=S5;
					end
					else if (in==" ")
						cs<=S0;
					else 
						cs<=S7;
				end
				S5:begin
					if (in==" ")
						cs<=S0;
					else begin
						cbegin<=cbegin-1;
						cs<=S6;
					end
				end
				S6:begin
					if (in==" ")
						cs<=S0;
					else
						cs<=S13;
				end
				S13:begin
					if (in==" ")
						cs<=S0;
					else
						cs<=S13;
				end
				S7:begin
					if (in==" ")
						cs<=S0;
					else
						cs<=S7;
				end
				S8:begin
					if (in=="n"||in=="N")
						cs<=S9;
					else if (in==" ")
						cs<=S0;
					else
						cs<=S7;
				end
				S9:begin
					if (in=="d"||in=="D")begin
						cend<=cend+1;
						cs<=S10;
					end
					else if (in==" ")
						cs<=S0;
					else
						cs<=S7;
				
				end
				S10:begin
					if (in==" ")
						cs<=S0;
					else begin
						cs<=S11;
						cend<=cend-1;
					end
				end
				S11:begin
					if (in==" ")
						cs<=S0;
					else
						cs<=S12;
				end
				S12:begin
					if (in==" ")
						cs<=S0;
					else
						cs<=S12;
				end
			endcase
		
		end
	
	
	end
	
	
endmodule
