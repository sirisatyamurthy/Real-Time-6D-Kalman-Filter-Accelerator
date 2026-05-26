`timescale 1ns/1ps
module covariance_update #(parameter N=6, DW=32, FRAC=16)(
    input  logic signed [DW-1:0] P [N][N],
    input  logic signed [DW-1:0] K [N][N],
    input  logic signed [DW-1:0] H [N][N],
    output logic signed [DW-1:0] P_out [N][N]
);

    integer i,j,k;
    logic signed [63:0] acc;

    logic signed [DW-1:0] KH [N][N];
    logic signed [DW-1:0] I_KH [N][N];

    always_comb begin
        // KH = K * H
        for (i=0;i<N;i++) begin
            for (j=0;j<N;j++) begin
                acc = 0;
                for (k=0;k<N;k++) begin
                    acc += (K[i][k] * H[k][j]) >>> FRAC;
                end
                KH[i][j] = acc;
            end
        end

        // I - KH
        for (i=0;i<N;i++) begin
            for (j=0;j<N;j++) begin
                if (i==j)
                    I_KH[i][j] = (1 <<< FRAC) - KH[i][j];
                else
                    I_KH[i][j] = -KH[i][j];
            end
        end

        // P_out = (I-KH) * P
        for (i=0;i<N;i++) begin
            for (j=0;j<N;j++) begin
                acc = 0;
                for (k=0;k<N;k++) begin
                    acc += (I_KH[i][k] * P[k][j]) >>> FRAC;
                end
                P_out[i][j] = acc;
            end
        end
    end

endmodule
