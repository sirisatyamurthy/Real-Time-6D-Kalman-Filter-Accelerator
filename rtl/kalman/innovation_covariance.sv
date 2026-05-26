`timescale 1ns/1ps
module innovation_covariance #(parameter N=6, DW=32, FRAC=16)(
    input  logic signed [DW-1:0] H [N][N],
    input  logic signed [DW-1:0] P_pred [N][N],
    input  logic signed [DW-1:0] R [N][N],
    output logic signed [DW-1:0] S [N][N]
);

    integer i,j,k;
    logic signed [63:0] acc;

    always_comb begin
        for (i=0;i<N;i++) begin
            for (j=0;j<N;j++) begin
                acc = 0;
                for (k=0;k<N;k++) begin
                    acc += (H[i][k] * P_pred[k][j]) >>> FRAC;
                end
                S[i][j] = acc + R[i][j];
            end
        end
    end

endmodule
