`timescale 1ns/1ps

module matrix_add #(parameter N=6, WIDTH=32)(
    input  logic signed [WIDTH-1:0] A [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] B [0:N-1][0:N-1],
    output logic signed [WIDTH-1:0] Y [0:N-1][0:N-1]
);

    integer i, j;

    always_comb begin
        for (i = 0; i < N; i++) begin
            for (j = 0; j < N; j++) begin

                // 🔥 FIX: use 64-bit addition
                logic signed [63:0] sum;

                sum = $signed(A[i][j]) + $signed(B[i][j]);

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