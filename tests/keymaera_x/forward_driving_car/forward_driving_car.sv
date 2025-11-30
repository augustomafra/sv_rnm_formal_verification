// Nathan Fulton et al., 2015, KeYmaera X: An Axiomatic Tactical Theorem Prover
// for Hybrid Systems

/* Exported from KeYmaera X v5.1.2 */

// Theorem "Beginner Safety Tutorial/00: Forward-Driving Car"
//   Description "Simple model of straight-line driving. Car can accelerate, coast, or brake, but not drive backwards.".
//   Title "Forward-driving 1-dimensional car".
//
// Definitions  /* function symbols cannot change their value */
//   Real A;     /* real-valued maximum acceleration constant */
//   Real B;     /* real-valued maximum braking constant */
// End.
//
// ProgramVariables  /* program variables may change their value over time */
//   Real x;            /* real-valued position */
//   Real v;            /* real-valued velocity */
//   Real a;            /* current acceleration chosen by controller */
// End.
//
// Problem                                 /* conjecture in differential dynamic logic */
//   v>=0 & A>0 & B>0                      /* initial condition */
// ->                                      /* implies */
// [                                       /* all runs of hybrid program dynamics */
//   {                                     /* braces {} for grouping of programs */
//     {?v<=5;a:=A; ++ a :=0; ++ a:=-B; }  /* nondeterministic choice of acceleration a */
//     {x'=v , v'=a & v>=0}                /* differential equation system with domain */
//   }*@invariant(v>=0)                    /* loop repeats, with invariant contract */
// ] v>=0                                  /* safety/postcondition */
// End.

`include "formal_rnm.sv"

module main
(
    input logic clk, rst,
    input logic [1:0] choice,
    input real nondet_A,
    input real nondet_B,
    input real nondet_v
);
    real A;
    real B;

    real x;
    real v;
    real a;

    always @(posedge clk) begin
        if (rst) begin
            A <= (nondet_A > 0 && !`is_nan(nondet_A) && !`is_inf(nondet_A)) ? nondet_A : 0.1;
            B <= (nondet_B > 0 && !`is_nan(nondet_B) && !`is_inf(nondet_B)) ? nondet_B : 0.1;

            a <= 0.0;
            v <= (nondet_v >= 0.0 && !`is_nan(nondet_v) && !`is_inf(nondet_v)) ? nondet_v : 0.0;
        end else begin
            A <= A;
            B <= B;

            if (choice == 2'b00 && v <= 5.0) a <= A;
            else if (choice == 2'b01) a <= 0.0;
            else a <= (0.0 - B);

            v <= (v + a >= 0.0) ? v + a : v;
            x <= x + v;
        end
    end

    assert property (rst || v >= 0.0);
endmodule
