`timescale 1ns / 1ps

`define ADD 0
`define SUB 1
`define OR 2
`define AND 3
`define LUI 4
`define SLL 5
`define SLTI 6
`define NOR 7
`define SLLV 8
`define SLTU 9
`define SRAV 10
`define SRLV 11
`define XOR 12



module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOP,
	input [4:0] SHAMT,
    output reg [31:0] ALUOUT
    );
    // aluout
	always @(*) begin
        if (ALUOP==`ADD) begin
            ALUOUT = A+B;
        end
        else if (ALUOP==`SUB) begin
            ALUOUT = A - B;
        end
        else if (ALUOP==`OR) begin
            ALUOUT = A|B;
        end
        else if (ALUOP==`AND) begin
            ALUOUT = A&B;
        end
        else if (ALUOP==`LUI) begin
            ALUOUT = B<<16;
        end
		  else if (ALUOP==`SLL) begin
			   ALUOUT = B<<SHAMT;
		  end
        else if (ALUOP==`SLTI) begin
            ALUOUT = ($signed(A)<$signed(B))?32'd1:32'd0;
        end
        else if (ALUOP==`NOR) begin
            ALUOUT = ~(A|B);
        end
        else if (ALUOP==`SLLV) begin
            ALUOUT = B<<A[4:0];
        end
        else if (ALUOP==`SLTU) begin
            ALUOUT = (A<B)?32'd1:32'd0;
        end
        else if (ALUOP==`SRAV) begin
            ALUOUT = $signed($signed(B)>>>$signed(A[4:0]));
        end
        else if (ALUOP==`SRLV) begin
            ALUOUT = B>>A[4:0];
        end
        else if (ALUOP==`XOR) begin
            ALUOUT = A^B;
        end
        else begin
            ALUOUT = 0;
        end
    end

endmodule
