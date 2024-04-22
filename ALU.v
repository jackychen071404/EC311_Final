`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2024 05:05:03 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [3:0] A,
    input [3:0] B,
    input [3:0] op,
    input rst,
    input clock,
    output reg [6:0] display,
    output reg [7:0] anode,
    output reg overflow
    );
    reg [3:0] result;
    
    reg [1:0] counter;
    reg dig2;
    wire new_clk;
    
    wire [6:0] op_codes;
    wire [6:0] result_codes;
    wire[6:0] tens_codes;
    
    decoder DUT(.number(op),.cathode(op_codes));
    new_decoder DDD(.number(result),.cathode(result_codes));
    tens_decoder DDT(.number(dig2),.cathode(tens_codes));
    Clock_divider(.in_clk(clock), .out_clk(new_clk));
    
    //always #5 clock = ~clock;
    initial begin
        counter <= 0;
    end
    always @(*) begin
        dig2 = result / 4'b1010;
    end

    always @ (posedge new_clk) begin
         case (counter)
            0: begin
                display <= op_codes;
                anode <= 8'b01111111;
                counter <= 1;
            end
            1: begin
                display <= tens_codes;
                anode <= 8'b11111101;
                counter <= 2;
            end
            2: begin
                display <= result_codes;
                anode <= 8'b11111110;
                counter <= 0;
            end
        endcase
    end
    
    always @ (*) begin
        //anode <= 8'b01111111;
        //display <= op_codes;
        overflow <= 0;
        if (rst) begin
            result <= 0;
            overflow <= 0;
        end
        else begin
            case (op)
            4'b0000: begin 
                result <= A + 1;
                overflow <= A > 14;
            end
            4'b0001: begin 
                result <= B + 1;
                overflow <= B > 14;
            end
            4'b0010: begin 
                result <= A - B;
                overflow <= (A[3] & ~B[3] & ~result[3]) | (~A[3] & B[3] & result[3]);
            end
            4'b0011: begin 
                result <= A + B;
                overflow <= (A[3] & B[3] & ~result[3]) | (~A[3] & ~B[3] & result[3]);
            end
            4'b0100: begin 
                result <= A * B;
                overflow <= (A > 4'b1110 || B > 4'b1110) ? 1 : 0;
            end
            4'b0101: result <= A >> 1;
            4'b0110: result <= A << 1;
            4'b0111: result <= B >> 1;
            4'b1000: result <= B << 1;
            4'b1001: result <= A % B;
            4'b1010: result <= A & B;
            4'b1011: result <= A | B;
            4'b1100: result <= A ^ B;
            default: begin
                result <= 0;
                overflow <= 0;
            end
            endcase 
        end
    end
endmodule
