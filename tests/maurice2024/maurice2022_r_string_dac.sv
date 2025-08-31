// Mariam Maurice, 2022, Modeling Analog Devices using SV-RNM

module r_string_dac #(parameter n = 3)
(
    input reg [n-1:0] Q,
    input real vref,
    output real VOUT_A
);
    real vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8;
    resis_div#(.n(3)) resis_div_i
    (
        vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8, 
        vref, 0.0
    );

    logic D1, D2, D3, D4, D5, D6, D7;
    decoder_3_to_8#(.n(3)) dec_i
    (
        Q,
        D1, D2, D3, D4, D5, D6, D7
    );

    switch_buffer sw_i
    (
        vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8,
        D1, D2, D3, D4, D5, D6, D7,
        VOUT_A
    );
endmodule

module decoder_3_to_8 #(parameter n = 3)
(
    input reg [n-1:0] Q,
    output logic D1, D2, D3, D4, D5, D6, D7
);
/*
    D___|_Range_____|_Q[2:0]_
    none| 0-1/8     | 000
    D1  | 1/8-2/8   | 001
    D2  | 2/8-3/8   | 010
    D3  | 3/8-4/8   | 011
    D4  | 4/8-5/8   | 100
    D5  | 5/8-6/8   | 101
    D6  | 6/8-7/8   | 110
    D7  | 7/8-1     | 111
*/
    always @(Q) begin
        D1 = ~Q[2]  & ~Q[1] & Q[0];
        D2 = ~Q[2]  & Q[1]  & ~Q[0];
        D3 = ~Q[2]  & Q[1]  & Q[0];
        D4 = Q[2]   & ~Q[1] & ~Q[0];
        D5 = Q[2]   & ~Q[1] & Q[0];
        D6 = Q[2]   & Q[1]  & ~Q[0];
        D7 = Q[2]   & Q[1]  & Q[0];
    end
endmodule

module switch_buffer
(
    input real vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8,
    input logic D1, D2, D3, D4, D5, D6, D7,
    output real VOUT_A,
);
    always_comb begin
        if (D7) VOUT_A = vref7;
        else if (D6) VOUT_A = vref6;
        else if (D5) VOUT_A = vref5;
        else if (D4) VOUT_A = vref4;
        else if (D3) VOUT_A = vref3;
        else if (D2) VOUT_A = vref2;
        else if (D1) VOUT_A = vref1;
        else VOUT_A = 0.0;
    end
endmodule
