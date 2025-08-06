module main
(
    input clk,
    input rstn
);
    logic [1:0] counter;
    logic [1:0] previous;
    always @(posedge clk) begin
        if (~rstn) begin
            counter <= '0;
            previous <= '0;
        end else begin
            counter <= counter + 1;
            previous <= counter;
        end
    end
    prop_proven: assert property (counter == 0 || counter >= previous);
    prop_cex: assert property (counter >= previous);
endmodule
