`timescale 1ns/1ps
module divider #(parameter DW=32, parameter FRAC=16)
(
input  logic signed [DW-1:0] a,
input  logic signed [DW-1:0] b,
output logic signed [DW-1:0] y
);

logic signed [2*DW-1:0] num;
logic signed [DW-1:0] result;

assign num = a <<< FRAC;  // scale numerator

assign result = (b != 0) ? (num / b) : 0;

// Saturation
assign y = (result > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
           (result < -32'sh80000000) ? -32'sh80000000 :
           result;

endmodule
