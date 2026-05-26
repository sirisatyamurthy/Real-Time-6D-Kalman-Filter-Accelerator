`timescale 1ns/1ps
module state_predictor #(parameter N=6, DW=32, FRAC=16)(
    input  logic signed [DW-1:0] F      [N][N],
    input  logic signed [DW-1:0] X_in   [N],
    output logic signed [DW-1:0] X_pred [N]
);

    integer i,j;
    logic signed [63:0] acc;

    always_comb begin
        for (i=0;i<N;i++) begin
            acc = 0;

            for (j=0;j<N;j++) begin
                acc += F[i][j] * X_in[j];
            end

            X_pred[i] = acc >>> FRAC;
        end
    end

endmodule
