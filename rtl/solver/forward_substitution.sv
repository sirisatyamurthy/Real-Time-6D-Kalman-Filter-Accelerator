`timescale 1ns/1ps
module forward_substitution
#(
    parameter N  = 6,
    parameter DW = 32
)
(
    input  logic signed [DW-1:0] L [N][N],
    input  logic signed [DW-1:0] b [N],
    output logic signed [DW-1:0] y [N]
);

integer i,j;
logic signed [DW-1:0] sum;

always_comb begin

for(i=0;i<N;i++) begin

    sum = b[i];

    for(j=0;j<i;j++)
        sum -= L[i][j]*y[j];

    y[i] = sum / L[i][i];

end

end

endmodule
