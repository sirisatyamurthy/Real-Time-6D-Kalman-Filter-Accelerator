`timescale 1ns/1ps
module matrix_vector_mul
#(
    parameter N  = 6,
    parameter M  = 6,
    parameter DW = 32
)
(
    input  logic signed [DW-1:0] A [N][M],
    input  logic signed [DW-1:0] x [M],
    output logic signed [DW-1:0] y [N]
);

integer i,j;

always_comb begin

    for(i = 0; i < N; i++) begin
        y[i] = 0;

        for(j = 0; j < M; j++) begin
            y[i] = y[i] + (A[i][j] * x[j]);
        end

    end

end

endmodule
