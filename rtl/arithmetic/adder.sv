`timescale 1ns/1ps
module adder #(parameter DW=32)
(
input  logic signed [DW-1:0] a,
input  logic signed [DW-1:0] b,
output logic signed [DW-1:0] y
);

logic signed [DW:0] sum;

assign sum = a + b;

// Saturation logic
assign y = (sum > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
           (sum < -32'sh80000000) ? -32'sh80000000 :
           sum[DW-1:0];

endmodule
