`include "formal_rnm.sv"

module main;
    parameter integer bits = 8;
    logic clk, rst;

    real nondet;
    real positive;
    assign positive = nondet < 0.0 ? 0.0 - nondet : nondet;
    real adc_in;
    assign adc_in = positive > 1.0 ? 1.0 : positive;

    logic [0:bits-1] adc_out;
    real dac_out;

    adc iadc(adc_out, adc_in, clk);
    dac idac(dac_out, adc_out, clk);

    `REG_PAST(real, adc_in, clk, rst, 0.0)
    `REG_PAST(real, past_adc_in, clk, rst, 0.0)
    `REG_PAST(logic, rst, clk, rst, 1'b1)

    localparam real RESOLUTION = 1.0 / 256.0;

    equal_output: assert property (
        rst || past_rst // ##2 (equivalent to waiting 2 cycles) 
        || past_past_adc_in < dac_out || past_past_adc_in - dac_out <= RESOLUTION
    );
endmodule
