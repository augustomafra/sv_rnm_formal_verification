`define real real

module main
(
    input logic i_Sprg, i_Ssmpl, 
    input `real i_Vin, Vref_L
);
    
    `real Vdac, Vdac_mat;

    always_comb begin
        case ({i_Sprg,i_Ssmpl})
            2'b00: Vdac = Vdac_mat;
            2'b01: Vdac = i_Vin;
            2'b10: Vdac = Vref_L;
            2'b11: Vdac = (i_Vin+Vref_L)/2.0;
        endcase
    end
    
    assert property (Vdac >= 0.0 && Vdac <= Vref_L);
endmodule

