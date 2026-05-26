`timescale 1ns/1ps

module innovation #(parameter N=6, WIDTH=32)(
    input  logic signed [WIDTH-1:0] z      [0:N-1],
    input  logic signed [WIDTH-1:0] H      [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] X_pred [0:N-1],
    output logic signed [WIDTH-1:0] y      [0:N-1]
);

    integer i, j;

    always_comb begin
        for (i = 0; i < N; i++) begin

            logic signed [63:0] acc;
            acc = 64'sd0;

            for (j = 0; j < N; j++) begin
                logic signed [63:0] prod;

                // SAME AS matrix_mul (DO NOT CHANGE THIS EVER AGAIN)
                prod = H[i][j] * X_pred[j];
                prod = prod >>> 16;

                acc += prod;
            end

            // innovation
            y[i] = z[i] - acc[31:0];
        end
    end

endmodule