`timescale 1ns/1ps

module kalman_gain #(parameter N=6, WIDTH=32)(

    input  logic signed [WIDTH-1:0] P [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] H [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] R [0:N-1][0:N-1],

    output logic signed [WIDTH-1:0] K [0:N-1][0:N-1]
);

    // internal matrices
    logic signed [WIDTH-1:0] HT     [0:N-1][0:N-1];
    logic signed [WIDTH-1:0] PHt    [0:N-1][0:N-1];
    logic signed [WIDTH-1:0] HP     [0:N-1][0:N-1];
    logic signed [WIDTH-1:0] HPHt   [0:N-1][0:N-1];
    logic signed [WIDTH-1:0] S      [0:N-1][0:N-1];
    logic signed [WIDTH-1:0] S_inv  [0:N-1][0:N-1];

    // H transpose
    matrix_transpose mt (
        .A(H),
        .Y(HT)
    );

    // PHᵀ
    matrix_mul mm1 (
        .A(P),
        .B(HT),
        .Y(PHt)
    );

    // H·P
    matrix_mul mm2 (
        .A(H),
        .B(P),
        .Y(HP)
    );

    // H·P·Hᵀ
    matrix_mul mm3 (
        .A(HP),
        .B(HT),
        .Y(HPHt)
    );

    // S = HPHᵀ + R
    matrix_add ma1 (
        .A(HPHt),
        .B(R),
        .Y(S)
    );

    // inverse(S)
    matrix_diag_inv mdi (
        .S(S),
        .S_inv(S_inv)
    );

    // K = PHᵀ * S⁻¹
    matrix_mul mm4 (
        .A(PHt),
        .B(S_inv),
        .Y(K)
    );
    initial begin
    #1;
    $display("---- DEBUG KALMAN GAIN ----");
    $display("HPHt[0][0] = %0d", HPHt[0][0]);
    $display("R[0][0]    = %0d", R[0][0]);
    $display("S[0][0]    = %0d", S[0][0]);
    $display("S_inv[0][0]= %0d", S_inv[0][0]);
    $display("---------------------------");
end
endmodule