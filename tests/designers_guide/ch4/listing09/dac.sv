// SV RNM adaptation of original Designer's Guide Verilog-AMS model

// Fully Event Driven Digital to Analog Converter
//
// Version 1a, 1 June 04
//
// Olaf Zinke
//
// Downloaded from The Designer's Guide Community (www.designers-guide.org).
// Post any questions on www.designers-guide.org/Forum.
// Taken from "The Designer's Guide to Verilog-AMS" by Kundert & Zinke.
// Chapter 4, Listing 9.

`ifndef FORMAL
`timescale 1ns / 1ps
`include "disciplines.vams"
`endif

module dac (out, in, clk);
    `ifndef FORMAL
    parameter integer bits = 8 from [1:24];	// resolution (bits)
    `else
    parameter integer bits = 8;	// resolution (bits)
    `endif
    parameter real fullscale = 1.0;		// output range is from 0 to fullscale (V)
    parameter real td = 0.0;			// delay from clock edge to output (s)
    `ifndef FORMAL
    parameter integer dir = 1 from [-1:1] exclude 0;
						// +1 triggers on rising clock edge, -1 on falling
    `else
    parameter integer dir = 1;
						// +1 triggers on rising clock edge, -1 on falling    
    `endif
    output out;
    `ifndef FORMAL
    wreal out;
    `else
    real out;
    `endif
    input [0:bits-1] in;
    input clk;
    `ifndef FORMAL
    logic in, clk;
    `else
    logic clk;
    `endif
    real result, aout;
    integer weight;
    integer i;
    parameter integer idir = (dir == 1 ? 1 : 0);

    `ifndef FORMAL
    always @(clk) begin
    `else
    always @(posedge clk) begin
    `endif
	if (clk == idir) begin
	    aout=0.0;
	    weight = 2;
	    for (i=bits-1; i>=0; i=i-1) begin
		if (in[i]) aout = aout + fullscale / weight;
		weight = weight * 2;
	    end
	    result = #(td / 1.0E-9) aout;
    end
    end
    assign out = result;
endmodule
