`timescale 1ns/1ps
module dot_product #(parameter N=6, DW=32, FRAC=16)
(
input  logic signed [DW-1:0] a [N],
input  logic signed [DW-1:0] b [N],
output logic signed [DW-1:0] y
);

integer i;
logic signed [63:0] acc;

always_comb begin
    acc = 0;

    for (i=0;i<N;i++) begin
        acc += a[i] * b[i];   // ❌ NO SHIFT HERE
    end

    acc = acc >>> FRAC;       // ✅ ONLY ONCE

    y = acc[31:0];
end

endmodule
