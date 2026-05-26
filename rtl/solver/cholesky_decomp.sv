`timescale 1ns/1ps
module cholesky_decomp
#(
    parameter N  = 6,
    parameter DW = 32
)
(
    input  logic signed [DW-1:0] A [N][N],
    output logic signed [DW-1:0] L [N][N]
);

integer i,j,k;

logic signed [DW-1:0] sum;
real r_sum;

always_comb begin

    // initialize
    for(i=0;i<N;i++)
        for(j=0;j<N;j++)
            L[i][j] = 0;

    for(i=0;i<N;i++) begin
        for(j=0;j<=i;j++) begin

            sum = A[i][j];

            for(k=0;k<j;k++)
                sum = sum - L[i][k]*L[j][k];

            if(i==j) begin

                // convert to real
                r_sum = sum;

                // clamp negative values
                if(r_sum < 0)
                    r_sum = 0;

                L[i][j] = $rtoi($sqrt(r_sum));

            end
            else begin

                if(L[j][j] != 0)
                    L[i][j] = sum / L[j][j];
                else
                    L[i][j] = 0;

            end
        end
    end

end

endmodule
