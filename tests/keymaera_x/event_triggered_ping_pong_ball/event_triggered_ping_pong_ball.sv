// Nathan Fulton et al., 2015, KeYmaera X: An Axiomatic Tactical Theorem Prover
// for Hybrid Systems

/* Exported from KeYmaera X v5.1.2 */

//Theorem "LFCPS Textbook/08: Event-triggered Ping-Pong Ball"
//Description "8.2.7 Proposition 8.1: Event-triggered ping-pong is safe".
//
//Definitions
//  Real H;        /* initial height */
//  Real g;        /* gravity */
//  Real c;        /* damping coefficient */
//  Real f;        /* paddle factor */
//End.
//
//ProgramVariables
//  Real x, v;     /* height, velocity */
//End.
//
//Problem
//  (0<=x&x<=5 & v<=0) &
//  (g>0 & 1>=c&c>=0 & f>=0)
//  ->
//  [
//    {
//      { {x'=v,v'=-g&x>=0&x<=5}++{x'=v,v'=-g&x>=5} }
//      {?x=0; v:=-c*v; ++ ?(4<=x&x<=5&v>=0); v:=-f*v; ++ ?(x!=0&x<4|x>5);}
//    }* @invariant(5>=x&x>=0 & (x=5->v<=0))
//  ] (0<=x&x<=5)
//End.

`include "formal_rnm.sv"

module main
(
    input logic clk, rst,
    input real nondet_x,
    input real nondet_v
);
    parameter real CLK_FREQ = 1e4;

    real H;        /* initial height */
    assign H = 1.0;
    real g;        /* gravity */
    assign g = 1.0;
    real c;        /* damping coefficient */
    assign c = 0.5;
    real f;        /* paddle factor */
    assign f = 0.8;

    real x, v;     /* height, velocity */

    logic valid;

    always @(posedge clk) begin
        if (rst) begin
            x <= (0.0 <= nondet_x && nondet_x <= 5.0) ? nondet_x : 0.0;
            v <= (nondet_v <= 0.0) ? nondet_v : 0.0;

            valid <= 1'b1;
        end else begin
            if (~valid || (x + v / CLK_FREQ < 0.0)) begin
                valid <= 1'b0;
            end else begin
                valid <= valid;
            end

            x <= x + v / CLK_FREQ;

            if (x == 0.0) begin
                v <= (0.0 - c) * v;
            end else if (4.0 <= x && x <= 5.0 && v >= 0.0) begin
                v <= (0.0 - f) * v;
            end else begin
                v <= v - g / CLK_FREQ;
            end
        end
    end

    `REG_PAST(real, x, clk, rst, 0.0)
    `REG_PAST(real, v, clk, rst, 0.0)

    prove_with_invariant: assert property (rst || ~valid
        || (5.0 >= past_x && past_x >= 0.0 && (past_x != 5.0 || past_v <= 0.0))
        || (x >= 0.0 && x <= 5.0)
    );

    prove_without_invariant: assert property (rst || ~valid
        || (x >= 0.0 && x <= 5.0)
    );
endmodule
