`timescale 1ns/1ps
module backward_substitution
#(
    parameter N  = 6,
    parameter DW = 32
)
(
    input  logic signed [DW-1:0] L [N][N],
    input  logic signed [DW-1:0] y [N],
    output logic signed [DW-1:0] x [N]
);

integer i,j;
logic signed [DW-1:0] sum;

always_comb begin

for(i=N-1;i>=0;i--) begin

    sum = y[i];

    for(j=i+1;j<N;j++)
        sum -= L[j][i]*x[j];

    x[i] = sum / L[i][i];

end

end

endmodule
