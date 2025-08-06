module main(input clk, rst, input real incr, output real q);
    real past_q;
    real past_incr;

    always @(posedge clk) begin
        if (rst) begin
            q <= 0.0;
            past_q <= 0.0;
            past_incr <= 0.0;
        end else begin 
            q <= q + incr;
            past_q <= q;
            past_incr <= incr;
        end
    end

    // Problem assumptions:
    wire increasing = past_incr > 0.0;

    // (Negated) assumptions constraining NaN and Inf Floating-Point values:
    wire q_is_NaN = !(past_q < 0.0) && !(past_q >= 0.0);
    wire q_is_Inf = past_q + 1.0 == past_q;
    
    // Assertion: (increasing && !isNaN && !isInf) |=> past_q <= q
    assert property (!increasing || q_is_NaN || q_is_Inf || past_q <= q);
endmodule
