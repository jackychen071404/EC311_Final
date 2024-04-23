`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 09:11:05 PM
// Design Name: 
// Module Name: tens_decoder
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


module tens_decoder(
        input number,
        output reg [6:0] cathode
    );
    
    initial begin
        cathode = 7'b0000001;
    end
    
    always @(number)
    begin
        case(number)
            0:cathode<=7'b0000001;
            1:cathode<=7'b1001111;
            default: cathode<=7'b1111111;
        endcase
    end
endmodule
