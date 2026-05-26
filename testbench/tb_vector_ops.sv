`timescale 1ns/1ps
module vector_tb;

parameter N=6;
parameter DW=32;
parameter TESTS=100;

logic signed [DW-1:0] A[N];
logic signed [DW-1:0] B[N];
logic signed [DW-1:0] Y[N];
logic signed [DW-1:0] dot;

vector_add #(N,DW) v1(A,B,Y);
dot_product #(N,DW) v2(A,B,dot);

integer i,t;
integer pass=0;
integer fail=0;

logic signed [DW-1:0] ref_dot;

initial begin

$dumpfile("vector.vcd");
$dumpvars(0,vector_tb);

for(t=0;t<TESTS;t++) begin

for(i=0;i<N;i++) begin
A[i]=$urandom_range(-500,500);
B[i]=$urandom_range(-500,500);
end

#1;

/* reference dot */

ref_dot=0;

for(i=0;i<N;i++)
ref_dot += A[i]*B[i];

if(dot==ref_dot) pass++; else fail++;

end

$display("VECTOR PASS=%0d FAIL=%0d",pass,fail);

$finish;

end

endmodule
