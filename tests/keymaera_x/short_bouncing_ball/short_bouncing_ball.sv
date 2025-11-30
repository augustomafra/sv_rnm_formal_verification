// Nathan Fulton et al., 2015, KeYmaera X: An Axiomatic Tactical Theorem Prover
// for Hybrid Systems

/* Exported from KeYmaera X v5.1.2 */

//Theorem "Beginner Safety Tutorial/07: Bouncing Ball"
//  Description "Quantum the acrophobic bouncing ball, as in chapter 7".
//  Title "Bouncing ball".
//  Link "http://symbolaris.com/course/fcps16/07-loops.pdf#page=13".
//
//Definitions         /* function symbols cannot change their value */
//  Real H;            /* initial height */
//  Real g;            /* gravity */
//  Real c;            /* damping coefficient */
//End.
//
//ProgramVariables  /* program variables may change their value over time */
//  Real x;            /* height */
//  Real v;            /* velocity */
//End.
//
//Problem
//  x>=0 & x=H
//  & v=0 & g>0 & 1=c&c>=0
// ->
//  [
//    {
//      {x'=v,v'=-g&x>=0}
//      {?x=0; v:=-c*v;  ++  ?x!=0;}
//    }*@invariant(2*g*x=2*g*H-v^2 & x>=0)
//  ] (x>=0 & x<=H)
//End.

`include "formal_rnm.sv"

module main
(
    input logic clk, rst,
    input real nondet_H, nondet_g, nondet_c
);
    parameter real CLK_FREQ = 1e6;

    real H;            /* initial height */
    real g;            /* gravity */
    real c;            /* damping coefficient */

    real x;            /* height */
    real v;            /* velocity */

    always @(posedge clk) begin
        if (rst) begin
            H <= (nondet_H >= 0.1) ? nondet_H : 1.0;
            g <= (nondet_g > 0.0 && nondet_g <= 10.0) ? nondet_g : 1.0;
            c <= (1.0 >= nondet_c && nondet_c >= 0.0) ? nondet_c : 0.5;

            x <= (nondet_H >= 0.0) ? nondet_H : 1.0;
            v <= 0.0;
        end else begin
            H <= H;
            g <= g;
            c <= c;

            if (x == 0.0) begin
                v <= (0.0 - c) * v;
            end else begin
                v <= v - g / CLK_FREQ;
            end

            x <= (x + v / CLK_FREQ >= 0.0) ? x + v / CLK_FREQ : 0.0;
        end
    end

    `REG_PAST(real, x, clk, rst, 0.0)

    prove_with_invariant: assert property (rst || x < 0.0 || past_x < 0.0
        || ~(2.0*g*past_x == 2.0*g*H - v*v & past_x >= 0.0)
        || (x >= 0.0 && x <= H)
    );

    prove_without_invariant: assert property (rst || x < 0.0
        || (x >= 0.0 && x <= H)
    );
endmodule
