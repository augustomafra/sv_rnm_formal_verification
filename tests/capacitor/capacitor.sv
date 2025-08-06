// Considering the RC circuit:
//                
//                i
//               -->
//   + ._______/\/\/\/______  +
//                R         |
//   Vi                   C _  v
//                          T 
//   - .____________________| -
//     |
//     T GND
// 
// 
// The equation of the voltage at the capacitor is:
// 
//     RC(dv/dt) + v = Vi
//     dv/dt = (Vi - v) / RC
// 
// Solving the differential equation yields:
// 
//     dv = dt(Vi - v) / RC
//     dv / (v - Vi) = -dt / RC
//     INT(dv / (v - Vi)) = INT(dt) / -RC
//     ln((v - Vi)/(V0 - Vi)) = -t / RC
//     (v - Vi) / (V0 - Vi) = e^(-t / RC)
//     v - Vi = (V0 - Vi)e^(-t / RC)
//     
// Therefore:
// 
//     v = Vi + (V0 - Vi)e^(-t / RC) 

module main
#(
    parameter real R = 4.2e6,
    parameter real C = 270e-9,
    parameter real f = 5
)
(
    input clk, rst,
    //input real Vi,
    output real v
);

    // Difference equation from discretization of Capacitor's
    // differential equation:
    //
    //     (v' - v) / Tclk = (1/RC) * (Vi - v)
    //     f(v' - v) = (1/RC) * (Vi - v)
    // 
    // Therefore:
    // 
    //     v' = v + (1/fRC) * (Vi - v)

    real Vi;
    assign Vi = 0.0;

    real past_v;
    wire past_rst;

    localparam real epsilon = 1e-6;

    always @(posedge clk) begin
        past_rst <= rst;
        past_v <= v;

        if (rst) begin
            v <= 1.0;
        end else begin
            v <= v + (1 / f*R*C) * (Vi - v);
        end
    end


    //assert property (s_eventually (-f*R*C*epsilon <= v && v <= f*R*C*epsilon));
    assert property (past_rst || past_v - v > epsilon || (-f*R*C*epsilon <= v && v <= f*R*C*epsilon));
endmodule

//~/Documents/universidade/pono/build/pono --smt-solver cvc5 --witness --reset _rst --resetsteps 2 --engine bmc --bound 51 capacitor.smv
