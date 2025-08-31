module main;
    real VSUP = 1.0;

    parameter n = 3;
    parameter real nlevels = $pow(2.0,n);

    real VIN, VOUT_A;
    reg [n-1:0] Q;

    flash_adc #(.n(n)) adc(VIN, VSUP, Q);
    r_string_dac #(.n(n)) dac(Q, VSUP, VOUT_A);

    real delta;
    assign delta = VSUP / nlevels;

    equal_output: assert property (VIN - VOUT_A <= delta || VOUT_A - VIN <= delta);
endmodule
