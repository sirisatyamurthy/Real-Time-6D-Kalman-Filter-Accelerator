`timescale 1ns/1ps

module multiplier #(parameter WIDTH=32, FRAC=16)(
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    output logic signed [WIDTH-1:0] y
);

    logic signed [2*WIDTH-1:0] mult_full;

    always_comb begin
        mult_full = a * b;                 // Q32 result
        y = mult_full >>> FRAC;            // Back to Q16
    end

endmodule