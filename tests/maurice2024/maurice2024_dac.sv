// Mariam Maurice, 2024, Functional Verification of Analog Devices modeled using SV-RNM

// ADC
module main(Q);
real VSUP = 1.0;

// PARAMETERS
parameter n = 3;
parameter real nlevels = $pow(2.0,n);

input reg [n-1:0] Q;

// output from Mariam Maurice, 2022, Modeling Analog Devices using SV-RNM
real VOUT_A;

// VARIABLES
real delta;
real vout_a;

//ASSIGNATION
`ifndef FORMAL
always @(VSUP)
    delta = VSUP / nlevels;
`else
    assign delta = VSUP / nlevels;
`endif

`ifndef FORMAL
always @(Q) begin
`else
always_comb begin
    vout_a = 0.0;
`endif
    if (Q > '0 && Q < '1) vout_a = Q * delta;
    else if (Q == '1) vout_a = ((nlevels-1)*delta);
    else if (Q == '0) vout_a = 0.0;
end

//DAC: assert property (@(Q) ((Q >= '0) && (Q <= '1)) |-> VOUT_A == vout_a);
DAC: assert property (!((Q >= '0) && (Q <= '1)) || VOUT_A == vout_a);
endmodule
