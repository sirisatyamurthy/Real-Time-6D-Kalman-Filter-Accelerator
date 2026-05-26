`timescale 1ns/1ps

module matrix_mul #(parameter N=6, WIDTH=32, SCALE=16)(
    input  logic signed [WIDTH-1:0] A [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] B [0:N-1][0:N-1],
    output logic signed [WIDTH-1:0] Y [0:N-1][0:N-1]
);

    integer i, j, k;

    always_comb begin
        for (i = 0; i < N; i++) begin
            for (j = 0; j < N; j++) begin

                // 64-bit accumulator (IMPORTANT)
                logic signed [63:0] sum;
                sum = 64'sd0;

                for (k = 0; k < N; k++) begin
                    // multiply in 64-bit
                    logic signed [63:0] prod;

                    prod = $signed(A[i][k]) * $signed(B[k][j]);

                    // 🔥 SCALE DOWN HERE (CRITICAL FIX)
                    prod = prod >>> SCALE;

                    sum = sum + prod;
                end

                // clamp to 32-bit
                if (sum > 64'sd2147483647)
                    Y[i][j] = 32'sd2147483647;
                else if (sum < -64'sd2147483648)
                    Y[i][j] = -32'sd2147483648;
                else
                    Y[i][j] = sum[31:0];

            end
        end
    end

endmodule