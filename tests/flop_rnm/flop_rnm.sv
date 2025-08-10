`include "formal_rnm.sv"

module main(input clk, rst, input real incr, output real q);
    always @(posedge clk) begin
        if (rst) begin
            q <= 0.0;
        end else begin 
            q <= q + incr;
        end
    end

    `REG_PAST(real, q, clk, rst, 0.0)
    `REG_PAST(real, incr, clk, rst, 0.0)

    // Problem assumptions:
    wire increasing = past_incr > 0.0;

    // Assumptions constraining NaN and Inf Floating-Point values:
    // Assertion: (increasing && !isNaN && !isInf) |=> past_q <= q
    assert property (!increasing || `is_nan(past_q) || `is_inf(past_q) || past_q <= q);
endmodule
