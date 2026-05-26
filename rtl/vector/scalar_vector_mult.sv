`timescale 1ns/1ps
module scalar_vector_mult #(parameter N=6, DW=32, FRAC=16)
(
input  logic signed [DW-1:0] scalar,
input  logic signed [DW-1:0] vec [N],
output logic signed [DW-1:0] y [N]
);

genvar i;
generate
    for (i=0; i<N; i++) begin
        logic signed [63:0] mult_full;
        logic signed [63:0] mult_scaled;

        assign mult_full   = scalar * vec[i];
        assign mult_scaled = mult_full >>> FRAC;

        assign y[i] = (mult_scaled > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
                      (mult_scaled < -32'sh80000000) ? -32'sh80000000 :
                      mult_scaled[31:0];
    end
endgenerate

endmodule
