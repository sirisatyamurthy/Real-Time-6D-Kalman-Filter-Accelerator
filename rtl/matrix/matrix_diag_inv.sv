`timescale 1ns/1ps

module matrix_diag_inv #(parameter N=6, WIDTH=32)(
    input  logic signed [WIDTH-1:0] S     [0:N-1][0:N-1],
    output logic signed [WIDTH-1:0] S_inv [0:N-1][0:N-1]
);

    integer i, j;

    always_comb begin
        for (i = 0; i < N; i++) begin
            for (j = 0; j < N; j++) begin

                if (i == j) begin
                    if (S[i][i] != 0) begin
                        // 🔥 FINAL FIX: reduced scaling (was <<<32)
                        S_inv[i][i] = (64'sd1 <<< 30) / S[i][i];
                    end
                    else begin
                        S_inv[i][i] = 0;
                    end
                end
                else begin
                    S_inv[i][j] = 0;
                end

            end
        end
    end

endmodule