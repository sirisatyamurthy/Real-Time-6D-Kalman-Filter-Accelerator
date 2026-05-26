`timescale 1ns/1ps
module mac #(parameter DW=32, parameter FRAC=16)
(
input  logic clk,
input  logic rst,
input  logic en,
input  logic signed [DW-1:0] a,
input  logic signed [DW-1:0] b,
output logic signed [DW-1:0] y
);

logic signed [2*DW-1:0] mult_full;
logic signed [DW-1:0] mult_scaled;
logic signed [DW:0] acc;

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        acc <= 0;
    else if (en) begin
        mult_full   = a * b;
        mult_scaled = mult_full >>> FRAC;

        acc <= acc + mult_scaled;
    end
end

// Saturation
assign y = (acc > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
           (acc < -32'sh80000000) ? -32'sh80000000 :
           acc[DW-1:0];

endmodule
