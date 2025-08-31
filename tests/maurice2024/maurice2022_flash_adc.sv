// Mariam Maurice, 2022, Modeling Analog Devices using SV-RNM

module flash_adc #(parameter n = 3)
(
    input real VIN,
    input real vref,
    output reg [n-1:0] Q
);
    real vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8;
    resis_div#(.n(3)) resis_div_i
    (
        vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8, 
        vref, 0.0
    );

    logic D1, D2, D3, D4, D5, D6, D7;
    comparator comp_i
    (
        vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8,
        D1, D2, D3, D4, D5, D6, D7,
        VIN, vref
    );

    encoder_8_to_3#(.n(3)) enc_i
    (
        D1, D2, D3, D4, D5, D6, D7,
        Q
    );
endmodule

module comparator
(
    input real vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8,
    output logic D1, D2, D3, D4, D5, D6, D7,
    input real VIN,
    input real vref
);
    always_comb begin
        D1 = 1'b0;
        D2 = 1'b0;
        D3 = 1'b0;
        D4 = 1'b0;
        D5 = 1'b0;
        D6 = 1'b0;
        D7 = 1'b0;
        if ((0.0 <= VIN) && (VIN < vref1)) begin
            D1 = 1'b0;
        end else if ((vref1 <= VIN) && (VIN < vref2)) begin
            D1 = 1'b1;
        end else if ((vref2 <= VIN) && (VIN < vref3)) begin
            D2 = 1'b1;
        end else if ((vref3 <= VIN) && (VIN < vref4)) begin
            D3 = 1'b1;
        end else if ((vref4 <= VIN) && (VIN < vref5)) begin
            D4 = 1'b1;
        end else if ((vref5 <= VIN) && (VIN < vref6)) begin
            D5 = 1'b1;
        end else if ((vref6 <= VIN) && (VIN < vref7)) begin
            D6 = 1'b1;
        end else if ((vref7 <= VIN) && (VIN <= vref8)) begin
            D7 = 1'b1;
        end
    end
endmodule

module encoder_8_to_3 #(parameter n = 3)
(
    input logic D1, D2, D3, D4, D5, D6, D7,
    output reg [n-1:0] Q
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

    logic [2:0] Q_a;
    always @(D1, D2, D3, D4, D5, D6, D7) begin
        Q_a[2] = D4 | D5 | D6 | D7;
        Q_a[1] = D2 | D3 | D6 | D7;
        Q_a[0] = D1 | D3 | D5 | D7;
    end
    assign Q[2:0] = Q_a;
endmodule
