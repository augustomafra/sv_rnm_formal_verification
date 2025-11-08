`include "formal_rnm.sv"

module main;
    parameter integer bits = 8;
    logic [0:bits-1] out;
    real nondet;
    real positive;
    assign positive = nondet < 0.0 ? 0.0 - nondet : nondet;
    real less_than_1;
    assign less_than_1 = positive > 1.0 ? 1.0 : positive;
    real in = `is_nan(less_than_1) || `is_inf(less_than_1) ? 0.0 : less_than_1;
    logic clk;

    adc adc_fv(out, in, clk);

    logic rst;
    `REG_PAST(logic [0:bits-1], out, clk, rst, 8'b0)
    `REG_PAST(logic, rst, clk, rst, 1'b1)
    `REG_PAST(logic, past_rst, clk, rst, 1'b1)
    `REG_PAST(real, in, clk, rst, 0.0)
    `REG_PAST(real, past_in, clk, rst, 0.0)

    localparam real RESOLUTION = 1.0 / 256.0;

    prop_adc: assert property (
        rst || past_rst || past_past_rst // ##3 (equivalent to waiting 3 cycles)
        || out != past_out || past_in < past_past_in || past_in - past_past_in <= RESOLUTION
    );
endmodule
