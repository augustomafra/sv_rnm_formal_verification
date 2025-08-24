`include "formal_rnm.sv"

module main;
    parameter integer bits = 8;
    real out;
    logic [0:bits-1] in;
    logic clk;

    dac dac_fv(out, in, clk);

    logic rst;

    `REG_PAST(real, out, clk, rst, 0.0)
    `REG_PAST(real, past_out, clk, rst, 0.0)

    localparam real UPPER_BOUND = 255.0 / 256.0;
    localparam real RESOLUTION = 1.0 / 256.0;

    prop_bounds: assert property (past_out >= 0.0 && past_out <= UPPER_BOUND);
    prop_resolution: assert property (past_past_out <= past_out || past_past_out - past_out >= RESOLUTION);
endmodule
