module main;
    real VSUP = 1.0;

    parameter n = 3;
    parameter real nlevels = $pow(2.0,n);

    real nondet;
    real VIN, VOUT_A;

    real positive;
    assign positive = nondet >= 0.0 ? nondet : 0.0;
    assign less_than_1 = positive <= 1.0 ? positive : 1.0;
    assign VIN = less_than_1;

    reg [n-1:0] Q;

    flash_adc #(.n(n)) adc(VIN, VSUP, Q);
    r_string_dac #(.n(n)) dac(Q, VSUP, VOUT_A);

    real delta;
    assign delta = VSUP / nlevels;

    equal_output: assert property (VIN - VOUT_A <= delta || VOUT_A - VIN <= delta);
endmodule
