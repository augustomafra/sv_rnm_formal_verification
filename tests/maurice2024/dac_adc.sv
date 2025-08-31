module main;
    real VSUP = 1.0;

    parameter n = 3;
    parameter real nlevels = $pow(2.0,n);

    reg [n-1:0] Q, Q_out;
    real VOUT_A;

    r_string_dac #(.n(n)) dac(Q, VSUP, VOUT_A);
    flash_adc #(.n(3)) adc(VOUT_A, VSUP, Q_out);

    equal_output: assert property (Q == Q_out);
endmodule
