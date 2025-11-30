// Nathan Fulton et al., 2015, KeYmaera X: An Axiomatic Tactical Theorem Prover
// for Hybrid Systems

/* Exported from KeYmaera X v5.1.2 */

//Theorem "LFCPS Textbook/11: Damped Oscillator"
//Description "Example 11.8: Damped oscillator".
//
//Definitions      /* function symbols cannot change their value */
//  Real w;        /* undamped angular frequency */
//  Real c;        /* level of ellipse */
//  Real d;        /* constant damping ratio */
//End.
//
//ProgramVariables /* program variables may change their value over time */
//  Real x, y;     /* position and velocity of spring/mass system */
//End.
//
//Problem
//    w^2*x^2 + y^2 <= c^2
//->
//  [{x'=y, y'=-w^2*x-2*d*w*y & w>=0 & d>=0}]w^2*x^2 + y^2 <= c^2
//End.

`include "formal_rnm.sv"

module main
(
    input logic clk, rst,
    input real nondet_w,
    input real nondet_c,
    input real nondet_d
);
    parameter real CLK_FREQ = 1e6;

    real w;        /* undamped angular frequency */
    real c;        /* level of ellipse */
    real d;        /* constant damping ratio */

    real x, y;     /* position and velocity of spring/mass system */

    always @(posedge clk) begin
        if (rst) begin
            w <= nondet_w;
            c <= nondet_c;
            d <= (-10.0 <= nondet_d && nondet_d <= 10.0) ? nondet_d : 0.0;
        end else begin
            w <= w;
            c <= c;
            d <= d;

            x <= (w>=0.0 && d>=0.0) ? x + y / CLK_FREQ : x;
            y <= (w>=0.0 && d>=0.0) ? y + ((0.0 - w*w)*x - 2.0*d*w*y) / CLK_FREQ : y;
        end
    end

    `REG_PAST(logic, rst, clk, rst, 1'b1)
    `REG_PAST(real, x, clk, rst, 0.0)
    `REG_PAST(real, y, clk, rst, 0.0)

    assert property (rst || past_rst || ~(w>=0.0 && d>=0.0)
        || past_x > 10.0 || x > 10.0
        || past_x < -10.0 || past_x < -10.0
        || (0.0 < past_x && past_x < 0.1) || (0.0 < x && x < 0.1)
        || (-0.1 < past_x && past_x < 0.0) || (-0.1 < x && x < 0.0)
        || ~(w * w * past_x * past_x + past_y * past_y <= c * c)
        || w * w * x * x + y * y <= c * c
    );
endmodule
