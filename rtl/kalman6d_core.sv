`timescale 1ns/1ps

module kalman6d_core #(parameter N=6, WIDTH=32)(

    input  logic signed [WIDTH-1:0] X_in  [0:N-1],
    input  logic signed [WIDTH-1:0] Z_in  [0:N-1],
    input  logic signed [WIDTH-1:0] F     [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] H     [0:N-1][0:N-1],
    input  logic signed [WIDTH-1:0] P_in  [0:N-1][0:N-1],
    input logic signed [WIDTH-1:0] R [0:N-1][0:N-1],
    output logic signed [WIDTH-1:0] X_out [0:N-1],
    output logic signed [WIDTH-1:0] P_out [0:N-1][0:N-1]
);

    logic signed [WIDTH-1:0] X_pred [0:N-1];
    logic signed [WIDTH-1:0] y      [0:N-1];
    logic signed [WIDTH-1:0] K      [0:N-1][0:N-1];
    logic signed [WIDTH-1:0] X_temp [0:N-1];

    state_predictor sp (
        .X_in(X_in),
        .F(F),
        .X_pred(X_pred)
    );

    innovation inn (
        .H(H),
        .X_pred(X_pred),
        .z(Z_in),
        .y(y)
    );

    kalman_gain kg (
    .P(P_in),
    .H(H),
    .R(R),
    .K(K)
);

    state_update su (
        .X_pred(X_pred),
        .K(K),
        .y(y),
        .X_out(X_temp)
    );

    assign X_out = X_temp;
    assign P_out = P_in;

endmodule