// SV RNM adaptation of original Designer's Guide Verilog-AMS model

// Analog to Digital Converter
//
// Version 1a, 1 June 04
//
// Olaf Zinke
//
// Downloaded from The Designer's Guide Community (www.designers-guide.org).
// Post any questions on www.designers-guide.org/Forum.
// Taken from "The Designer's Guide to Verilog-AMS" by Kundert & Zinke.
// Chapter 4, Listing 12.

`ifndef FORMAL
`include "disciplines.vams"
`timescale 1ns / 1ps
`endif

module adc (out, in, clk);
    `ifndef FORMAL
    parameter integer bits = 8 from [1:24];	// resolution (bits)
    `else
    parameter integer bits = 8;	// resolution (bits)
    `endif
    parameter real fullscale = 1.0;		// input range is from 0 to fullscale (V)
    parameter real td = 0;			// delay from clock to output (ns)
    input in, clk;
    `ifndef FORMAL
    output out;
    voltage in;
    reg [0:bits-1] out;
    `else
    real in;
    output [0:bits-1] out;
    `endif
    reg over;
    real sample, midpoint;
    integer i;

    always @(posedge clk) begin
	`ifndef FORMAL
    sample = V(in);
    `else
    sample = in;
    `endif
	midpoint = fullscale/2.0;
	for (i = bits - 1; i >= 0; i = i - 1) begin
	    over = (sample > midpoint);
	    if (over)
		sample = sample - midpoint;
	    sample = 2.0*sample;
	    out[i] <= #(td) over;
	end
    end
endmodule
