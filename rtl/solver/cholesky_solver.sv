`timescale 1ns/1ps
module cholesky_solver
#(
    parameter N  = 6,
    parameter DW = 32
)
(
    input  logic signed [DW-1:0] A [N][N],
    output logic signed [DW-1:0] A_inv [N][N]
);

logic signed [DW-1:0] L [N][N];

logic signed [DW-1:0] e [N];
logic signed [DW-1:0] y [N];
logic signed [DW-1:0] x [N];

integer i,j,k;

//////////////////////////////////////////////////////
// Cholesky Decomposition
//////////////////////////////////////////////////////

cholesky_decomp #(N,DW) decomp(
    .A(A),
    .L(L)
);

//////////////////////////////////////////////////////
// Solve A*x = I column by column
//////////////////////////////////////////////////////

always_comb begin

    for(j=0;j<N;j++) begin

        // create unit vector
        for(i=0;i<N;i++)
            e[i] = (i==j) ? 1 : 0;

        // forward substitution
        for(i=0;i<N;i++) begin
            y[i] = e[i];

            for(k=0;k<i;k++)
                y[i] = y[i] - L[i][k]*y[k];

            y[i] = y[i] / L[i][i];
        end

        // backward substitution
        for(i=N-1;i>=0;i--) begin
            x[i] = y[i];

            for(k=i+1;k<N;k++)
                x[i] = x[i] - L[k][i]*x[k];

            x[i] = x[i] / L[i][i];
        end

        // store column of inverse
        for(i=0;i<N;i++)
            A_inv[i][j] = x[i];

    end

end

endmodule
