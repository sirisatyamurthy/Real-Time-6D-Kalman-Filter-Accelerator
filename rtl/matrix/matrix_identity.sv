`timescale 1ns/1ps
module matrix_identity #(parameter N=6, DW=32)
(
output logic signed [DW-1:0] I [N][N]
);

genvar i,j;
generate
    for (i=0; i<N; i++) begin
        for (j=0; j<N; j++) begin
            assign I[i][j] = (i==j) ? 32'h00010000 : 0;
        end
    end
endgenerate

endmodule
