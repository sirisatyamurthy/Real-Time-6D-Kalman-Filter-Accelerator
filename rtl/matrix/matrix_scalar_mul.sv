`timescale 1ns/1ps
module matrix_scalar_mul #(parameter N=6, DW=32, FRAC=16)
(
input  logic signed [DW-1:0] scalar,
input  logic signed [DW-1:0] A [N][N],
output logic signed [DW-1:0] Y [N][N]
);

genvar i,j;
generate
    for (i=0; i<N; i++) begin
        for (j=0; j<N; j++) begin
            logic signed [63:0] mult_full;
            logic signed [63:0] mult_scaled;

            assign mult_full   = scalar * A[i][j];
            assign mult_scaled = mult_full >>> FRAC;

            assign Y[i][j] = (mult_scaled > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
                             (mult_scaled < -32'sh80000000) ? -32'sh80000000 :
                             mult_scaled[31:0];
        end
    end
endgenerate

endmodule
