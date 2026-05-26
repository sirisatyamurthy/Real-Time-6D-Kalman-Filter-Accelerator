`timescale 1ns/1ps
module matrix_copy #(parameter N=6, DW=32)
(
input  logic signed [DW-1:0] A [N][N],
output logic signed [DW-1:0] Y [N][N]
);

genvar i,j;
generate
    for (i=0; i<N; i++) begin
        for (j=0; j<N; j++) begin
            assign Y[i][j] = A[i][j];
        end
    end
endgenerate

endmodule
