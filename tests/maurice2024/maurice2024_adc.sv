// Mariam Maurice, 2024, Functional Verification of Analog Devices modeled using SV-RNM

`define RNM
`include "formal_rnm.sv"

// ADC
module main(
    input `real VIN,
);

`real VSUP = 1.0;

// PARAMETERS
parameter n = 3; 
parameter `real nlevels = $pow(2.0,n); // number levels of conversion

// VARIABLES
`real vsuplow = 0.0; // low supply voltage
`real clk_period = 2.0;
`real delta; // step of converter
reg [n-1:0] q; // output code of ADC
// output from Mariam Maurice, 2022, Modeling Analog Devices using SV-RNM
reg [n-1:0] Q;

flash_adc #(.n(3)) dut(VIN, VSUP, Q);

// ASSIGNATION
`ifndef FORMAL
always @(VSUP)
    delta = VSUP / nlevels; // vsup is supply voltage or full scale voltage
                            // vsup is considered as an input to converter
`else
    assign delta = VSUP / nlevels; // vsup is supply voltage or full scale voltage
                                   // vsup is considered as an input to converter
`endif
                            

`ifndef FORMAL
always @(VIN) begin
`else
always_comb begin
    q = '0;
`endif
    if (VIN >= vsuplow && VIN < delta) #(clk_period) q = '0;
    else if (VIN >= ((nlevels-1)*delta) && VIN <= VSUP) #(clk_period) q = '1;
    else if (VIN >= delta && VIN < ((nlevels-1)*delta)) #(clk_period) q = $floor(VIN / delta);
end

// ASSERTION
//ADC: assert property (@(posedge CLK) ((VIN >= vsuplow) && (VIN <= VSUP)) |-> Q == q);
ADC: assert property (!(((VIN >= vsuplow) && (VIN <= VSUP))) || Q == q);

endmodule
