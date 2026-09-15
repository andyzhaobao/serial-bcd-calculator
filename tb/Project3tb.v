// -----------------------------------------------------------------------------
// File    : Project3tb.v
// Brief   : Testbench for Project3: two 41-bit packets (5050+5050, 7777-7776) on a 10 ns clock
// Modules : Project3tb
// Author  : Bao Zhao
// Created : 2026-04-22
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

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
