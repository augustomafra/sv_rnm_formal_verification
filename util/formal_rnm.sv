`ifndef FORMAL_RNM_SV
`define FORMAL_RNM_SV

`ifdef FORMAL
    `ifdef RNM
        `define real real
    `else
        `define real logic
    `endif
`else
    `define real logic
`endif

`ifdef FORMAL
    `ifdef RNM
        `define is_nan(a) (!((a) < 0.0) && !((a) >= 0.0));
        `define is_inf(a) ((a) + 1.0 == (a));
    `else
        `define is_nan(a) 1'b0
        `define is_inf(a) 1'b0
    `endif
`else
    `define is_nan(a) 1'b0
    `define is_inf(a) 1'b0
`endif

`endif
