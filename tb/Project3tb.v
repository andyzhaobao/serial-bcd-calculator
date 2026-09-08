`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2026 09:08:32 PM
// Design Name: 
// Module Name: Project3tb
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


module Project3tb();
    
    reg din;
    reg reset;
    reg clock;
    wire result;
    Project3 uut(din, reset, clock, result);
    always #5 clock = ~clock;

    initial begin
        din = 1'b0;
        reset = 1'b1;
        clock = 1'b0;
        #10
        reset = 1'b0;
        #10;
        // input packet
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        // add
        din = 1'b0;     #10
        // A = 5050
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        din = 1'b1;     #10

        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        // B = 5050
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        
        #420
        
        // input packet
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        // sub
        din = 1'b1;     #10
        // A = 7777
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10

        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        // B = 7776
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        
        din = 1'b0;     #10
        din = 1'b1;     #10
        din = 1'b1;     #10
        din = 1'b0;     #10
        
        #420;
        reset = 1'b0;
        $finish;
    end

endmodule
