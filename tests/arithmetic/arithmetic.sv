module main
(
    input real a,
    input logic[2:0] b
);
    real c;
    assign c = b + a;
    assert property (c == a + b);
endmodule
