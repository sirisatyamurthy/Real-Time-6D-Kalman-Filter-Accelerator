`timescale 1ns/1ps
module matrix_sub #(parameter N=6, DW=32)
(
input  logic signed [DW-1:0] A [N][N],
input  logic signed [DW-1:0] B [N][N],
output logic signed [DW-1:0] Y [N][N]
);

genvar i,j;
generate
    for (i=0; i<N; i++) begin
        for (j=0; j<N; j++) begin
            logic signed [DW:0] diff;

            assign diff = A[i][j] - B[i][j];

            assign Y[i][j] = (diff > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
                             (diff < -32'sh80000000) ? -32'sh80000000 :
                             diff[DW-1:0];
        end
    end
endgenerate

endmodule
