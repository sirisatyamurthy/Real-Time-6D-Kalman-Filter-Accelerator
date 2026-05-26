`timescale 1ns/1ps
module vector_add #(parameter N=6, DW=32)
(
input  logic signed [DW-1:0] a [N],
input  logic signed [DW-1:0] b [N],
output logic signed [DW-1:0] y [N]
);

genvar i;
generate
    for (i=0; i<N; i++) begin
        logic signed [DW:0] sum;

        assign sum = a[i] + b[i];

        assign y[i] = (sum > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
                      (sum < -32'sh80000000) ? -32'sh80000000 :
                      sum[DW-1:0];
    end
endgenerate

endmodule
