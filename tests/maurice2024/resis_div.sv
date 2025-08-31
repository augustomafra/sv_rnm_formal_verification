// Mariam Maurice, 2022, Modeling Analog Devices using SV-RNM

module resis_div #(parameter n = 3)
(
    output real vref1, vref2, vref3, vref4, vref5, vref6, vref7, vref8,
    input real vref,
    input real GND
);
    always_comb begin
    vref1 = (1.0) / $pow(2.0,n);
    vref2 = (2.0) / $pow(2.0,n);
    vref3 = (3.0) / $pow(2.0,n);
    vref4 = (4.0) / $pow(2.0,n);
    vref5 = (5.0) / $pow(2.0,n);
    vref6 = (6.0) / $pow(2.0,n);
    vref7 = (7.0) / $pow(2.0,n);
    vref8 = (8.0) / $pow(2.0,n);
    end
endmodule
