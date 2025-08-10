`ifndef FORMAL_RNM_SV
`define FORMAL_RNM_SV

// Map `real macro to 'real' type if and only if FORMAL and RNM are defined
`ifdef FORMAL
    `ifdef RNM
        `define real real
    `else
        `define real logic
    `endif
`else
    `define real logic
`endif

// Utilities for checking Floating-Point special values
`ifdef FORMAL
    `ifdef RNM
        `define is_nan(a) (!((a) < 0.0) && !((a) >= 0.0))
        `define is_inf(a) ((a) + 1.0 == (a))
    `else
        `define is_nan(a) 1'b0
        `define is_inf(a) 1'b0
    `endif
`else
    `define is_nan(a) 1'b0
    `define is_inf(a) 1'b0
`endif

// Utility for declaring a 'past_sig' variable equivalent to '$past(sig)' when 
// full SV language support is not provided.
//
// Usage:
//  Instantiate a `REG_PAST macro to create an always block describing a 
//  register intended for storing the past value of a variable. It will declare
//  a variable called 'past_sig' in the enclosing scope, where 'sig' is the 
//  second argument passed to the macro.
//
//  `REG_PAST(ty, sig, clk, rst, rst_val)
//      . ty: The type of the created register (e.g. logic or real)
//      . sig: The signal name to apply '$past' to
//      . clk: Clock signal for the created register
//      . rst: Synchronous reset signal for the created register
//      . rst_val: Synchronous reset value for the created register
// 
// Example:
//  `REG_PAST(`real, myvar, clk, rst, 3.14) 
//  Creates a new 'past_myvar' variable equivalent to $past(myvar) clocked on
//  'clk' and initialized with 3.14 on reset.
`ifdef FORMAL
    `ifdef RNM
        `define REG_PAST(ty, sig, clk, rst, rst_val) \
            ty past_``sig; \
            always @(posedge (clk)) \
                if (rst) past_``sig <= (rst_val); \
                else past_``sig <= (sig);
    `else
        `define REG_PAST(ty, sig, clk, rst, rst_val)
    `endif
`else
    `define REG_PAST(ty, sig, clk, rst, rst_val)
`endif

`endif
