`timescale 1ns / 1ps
module gray (
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow
);
    reg [2:0] res;
    always @(posedge Clk) begin
        if (Reset) begin
            Overflow <= 0;
            res <= 0;
        end
        else begin
            if(En) begin
                if (res == 3'b111) begin
                    Overflow <= 1;
                    res <= res + 3'b001;
                end
                else res <= res + 3'b001;
            end
            else begin
                Overflow <= Overflow;
                res <= res;
            end
        end 
    end
    always @(*) begin
        case (res)
            3'b000: Output = 3'b000; 
            3'b001: Output = 3'b001; 
            3'b010: Output = 3'b011; 
            3'b011: Output = 3'b010; 
            3'b100: Output = 3'b110; 
            3'b101: Output = 3'b111; 
            3'b110: Output = 3'b101; 
            3'b111: Output = 3'b100;
            default: Output = 0; 
        endcase

    end
endmodule