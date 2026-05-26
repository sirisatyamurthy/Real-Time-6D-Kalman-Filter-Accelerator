`timescale 1ns/1ps
module covariance_predictor #(parameter N=6, DW=32, FRAC=16)
(
    input  logic signed [DW-1:0] F [N][N],
    input  logic signed [DW-1:0] P [N][N],
    input  logic signed [DW-1:0] Q [N][N],
    output logic signed [DW-1:0] P_out [N][N]
);

    logic signed [DW-1:0] Ft [N][N];
    logic signed [DW-1:0] temp1 [N][N];
    logic signed [DW-1:0] temp2 [N][N];

    // Transpose
    always_comb begin
        for (int i=0;i<N;i++)
            for (int j=0;j<N;j++)
                Ft[i][j] = F[j][i];
    end

    matrix_mul #(N,DW,FRAC) m1 (.A(F),     .B(P),  .Y(temp1));
    matrix_mul #(N,DW,FRAC) m2 (.A(temp1), .B(Ft), .Y(temp2));

    // Final add
    always_comb begin
        for (int i=0;i<N;i++)
            for (int j=0;j<N;j++)
                P_out[i][j] = temp2[i][j] + Q[i][j];
    end

endmodule
