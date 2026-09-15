// -----------------------------------------------------------------------------
// File    : Project3.v
// Brief   : Serial-in/serial-out 4-digit BCD add/subtract unit with framed packets
// Modules : Project3, packetchecker, sipo_store, BCD_ALU, BCDadd_4d, BCDsub_4d,
//           BCDadd_1d, RCA, FA, outputmux, piso_out
// Author  : Bao Zhao
// Created : 2026-04-21
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module Project3(
    input din,
    input reset,
    input clock,
    output result
    );
    
    wire [7:0] packet_check;
    wire packet_match;
    
    wire op;
    wire [15:0] A;
    wire [15:0] B;
    wire sipo_done;
    wire sipo_busy;
    
    wire [19:0] sum;
    wire [19:0] diff;
    
    wire [19:0] out;
    wire out_done;
    
    packetchecker u_packetchecker (
        .din(din),
        .reset(reset),
        .hold_off(sipo_busy),
        .clock(clock),
        .packet_check(packet_check),
        .packet_match(packet_match)
    );

    sipo_store u_sipo_store (
        .din(din),
        .reset(reset),
        .finish(1'b0),
        .clock(clock),
        .packet_match(packet_match),
        .op(op),
        .A(A),
        .B(B),
        .sipo_done(sipo_done),
        .capture_active(sipo_busy)
    );

    BCD_ALU u_bcd_alu (
        .A(A),
        .B(B),
        .op(op),
        .result(out)
    );

    piso_out u_piso_out (
        .out(out),
        .reset(reset),
        .clock(clock),
        .sipo_done(sipo_done),
        .finish(out_done),
        .result(result)
    );
    
    
    
endmodule

module packetchecker(
    input din,
    input reset,
    input hold_off,
    input clock,
    output reg [7:0] packet_check,
    output reg packet_match
    );
    parameter STARTPACKET = 8'h67;

    // packet match checker
    always @(posedge clock) begin
        if (reset) begin
            packet_check <= 8'd0;
            packet_match <= 1'b0;
        end
        else if (hold_off) begin
            packet_check <= 8'd0;
            packet_match <= 1'b0;
        end
        else begin
            packet_check <= {packet_check[6:0], din};
            packet_match <= ({packet_check[6:0], din} == STARTPACKET);
        end
    end
endmodule

module sipo_store(
    input din,
    input reset,
    input finish, 
    input clock,
    input packet_match,
    output reg op,
    output reg [15:0] A,
    output reg [15:0] B,
    output reg sipo_done,
    output capture_active
    );
    
    reg [5:0] sipo_counter;
    reg capturing;
    assign capture_active = capturing;
    
    always @(posedge clock) begin
        if (reset || finish) begin
            sipo_counter <= 6'd0;
            capturing <= 1'b0;
            op <= 1'b0;
            A <= 16'd0;
            B <= 16'd0;
            sipo_done <= 1'b0;
        end
        else begin
            sipo_done <= 1'b0;
            if (packet_match && !capturing) begin
                capturing <= 1'b1;
            end
            if (capturing || packet_match) begin
                {op, A, B} <= {A, B, din};
                if (sipo_counter == 6'd32) begin
                    capturing <= 1'b0;
                    sipo_done <= 1'b1;
                    sipo_counter <= 6'd0;
                end
                else begin
                    sipo_counter <= sipo_counter + 1'b1;
                end
            end
            else begin
                sipo_counter <= 6'd0;
            end
        end
    end
    
endmodule

module BCDadd_4d(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] Sum,
    output [3:0] Cout
    );

    
    BCDadd_1d BCD1 (A[3:0], B[3:0], Cin, Sum[3:0], Cout[0]);
    BCDadd_1d BCD2 (A[7:4], B[7:4], Cout[0], Sum[7:4], Cout[1]);
    BCDadd_1d BCD3 (A[11:8], B[11:8], Cout[1], Sum[11:8], Cout[2]);
    BCDadd_1d BCD4 (A[15:12], B[15:12], Cout[2], Sum[15:12], Cout[3]);


endmodule

module BCDsub_4d(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] Diff,
    output [3:0] Cout
    );
    
    wire [15:0] B9c;
    wire [3:0] garbage;
    assign B9c = {4'd9 - B[15:12], 4'd9 - B[11:8], 4'd9 - B[7:4], 4'd9 - B[3:0]};
    assign Cout = 4'd0;
    BCDadd_4d u_bcd_sub_add (
        .A(A),
        .B(B9c),
        .Cin(1'b1),
        .Sum(Diff),
        .Cout(garbage)
    );

endmodule

module BCDadd_1d(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
    );
    
    wire [3:0] SumA, SumB;
    wire Couta, Coutb;
    
    RCA RCA1 (A, B, Cin, SumA, Couta);
    RCA RCA2 (SumA, 4'b0110, 1'b0, SumB, Coutb);
    assign Sum = ((SumA > 4'd9) | Couta) ? SumB : SumA;
    assign Cout = ((SumA > 4'd9) | Couta) ? 1'b1 : 1'b0;
endmodule

module RCA(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
    );
    wire [2:0] C;
    FA FA1 (A[0], B[0], Cin, S[0], C[0]);
    FA FA2 (A[1], B[1], C[0], S[1], C[1]);
    FA FA3 (A[2], B[2], C[1], S[2], C[2]);
    FA FA4 (A[3], B[3], C[2], S[3], Cout);
endmodule

module FA (
    input A,
    input B,
    input Cin,
    output S,
    output Cout
    );
    assign S = A ^ B ^ Cin;
    assign Cout = ((A ^ B) & Cin) | (A & B);
endmodule 

module outputmux(
    input [19:0] sum,
    input [19:0] diff,
    input op,
    output [19:0] out
    );
    assign out = op ? diff : sum;
endmodule

module BCD_ALU(
    input [15:0] A,
    input [15:0] B,
    input op,
    output [19:0] result
    );
    
    wire [15:0] sum_low;
    wire [3:0] add_cout;
    wire [15:0] diff_low;
    wire [3:0] sub_cout;
    wire [19:0] sum;
    wire [19:0] diff;
    
    BCDadd_4d u_bcd_add (
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Sum(sum_low),
        .Cout(add_cout)
    );

    BCDsub_4d u_bcd_sub (
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Diff(diff_low),
        .Cout(sub_cout)
    );

    assign sum = {3'b000, add_cout[3], sum_low};
    assign diff = {4'b0000, diff_low};

    outputmux u_outputmux (
        .sum(sum),
        .diff(diff),
        .op(op),
        .out(result)
    );
endmodule

module piso_out(
    input [19:0] out,
    input reset,
    input clock,
    input sipo_done,
    output reg finish,
    output reg result
    );
    
    parameter OUTPUTPACKET = 8'hA5;
    reg [27:0] shift_reg;
    reg [5:0] shift_count;
    reg busy;
    
    always @(posedge clock) begin
        if (reset) begin
            shift_reg <= 28'd0;
            shift_count <= 6'd0;
            busy <= 1'b0;
            finish <= 1'b0;
            result <= 1'b0;
        end
        else begin
            finish <= 1'b0;
            if (!busy) begin
                result <= 1'b0;
                if (sipo_done) begin
                    shift_reg <= {OUTPUTPACKET, out};
                    shift_count <= 6'd28;
                    busy <= 1'b1;
                end
            end
            else begin
                result <= shift_reg[27];
                shift_reg <= {shift_reg[26:0], 1'b0};
                if (shift_count == 6'd1) begin
                    shift_count <= 6'd0;
                    busy <= 1'b0;
                    finish <= 1'b1;
                end
                else begin
                    shift_count <= shift_count - 1'b1;
                end
            end
        end
    end
    
endmodule














