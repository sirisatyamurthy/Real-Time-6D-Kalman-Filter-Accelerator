`timescale 1ns/1ps
module subtractor #(parameter DW=32)
(
input  logic signed [DW-1:0] a,
input  logic signed [DW-1:0] b,
output logic signed [DW-1:0] y
);

logic signed [DW:0] diff;

assign diff = a - b;

assign y = (diff > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
           (diff < -32'sh80000000) ? -32'sh80000000 :
           diff[DW-1:0];

endmodule
