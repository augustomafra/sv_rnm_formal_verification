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
    
    assert property (
        (!(i_Sprg == 1'b0 && i_Ssmpl == 1'b0) || Vdac == Vdac_mat) &&
        (!(i_Sprg == 1'b0 && i_Ssmpl == 1'b1) || Vdac == i_Vin) &&
        (!(i_Sprg == 1'b1 && i_Ssmpl == 1'b0) || Vdac == Vref_L) &&
        (!(i_Sprg == 1'b1 && i_Ssmpl == 1'b1) || Vdac == (i_Vin+Vref_L)/2.0)
    );
endmodule

