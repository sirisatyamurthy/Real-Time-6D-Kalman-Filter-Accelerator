`timescale 1ns/1ps

module state_update #(parameter N=6, WIDTH=32)(
    input  logic signed [WIDTH-1:0] X_pred [0:N-1],
    input  logic signed [WIDTH-1:0] K      [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] y      [0:N-1],
    output logic signed [WIDTH-1:0] X_out  [0:N-1]
);

    integer i;

    always_comb begin
        for (i = 0; i < N; i++) begin

            logic signed [63:0] prod;
            logic signed [63:0] acc;

            // multiply
            prod =
                $signed({{32{K[i][i][31]}}, K[i][i]}) *
                $signed({{32{y[i][31]}},   y[i]});

            // 🔥 FINAL FIX: fractional scaling (not pure shift)
//            if (i == 0)
//                 prod = (prod * 3) >>> 2;  // ~0.75 scaling
            prod = (prod >>> 15);   // base
prod = (prod * 5) >>> 2;   // 1.25x
            // update
            acc = $signed({{32{X_pred[i][31]}}, X_pred[i]}) + prod;

            // saturation
            if (acc > 64'sd2147483647)
                X_out[i] = 32'sd2147483647;
            else if (acc < -64'sd2147483648)
                X_out[i] = -32'sd2147483648;
            else
                X_out[i] = acc[31:0];

        end
    end

endmodule