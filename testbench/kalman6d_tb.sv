`timescale 1ns/1ps

module kalman6d_tb;

    parameter N  = 6;
    parameter DW = 32;

    // ================================
    // INPUTS
    // ================================
    logic signed [DW-1:0] X_in  [0:N-1];
    logic signed [DW-1:0] Z_in  [0:N-1];
    logic signed [DW-1:0] F     [0:N-1][0:N-1];
    logic signed [DW-1:0] H     [0:N-1][0:N-1];
    logic signed [DW-1:0] P_in  [0:N-1][0:N-1];

    // ================================
    // OUTPUTS
    // ================================
    logic signed [DW-1:0] X_out [0:N-1];
    logic signed [DW-1:0] P_out [0:N-1][0:N-1];
logic signed [31:0] R [0:5][0:5];
    // ================================
    // GOLDEN
    // ================================
    logic signed [DW-1:0] golden [0:N-1];

    // ================================
    // DUT
    // ================================
    kalman6d_core dut (
        .X_in(X_in),
        .Z_in(Z_in),
        .F(F),
        .H(H),
        .P_in(P_in),
        .X_out(X_out),
        .P_out(P_out),
        .R(R)
    );

    // ================================
    // LOAD MEMORY
    // ================================
    initial begin
    for (int i = 0; i < 6; i++) begin
        for (int j = 0; j < 6; j++) begin
            if (i == j)
                R[i][j] = 32'd1000;   // small noise
            else
                R[i][j] = 0;
        end
    end
end
    initial begin
        $readmemh("x_input.mem", X_in);
        $readmemh("z_input.mem", Z_in);
        $readmemh("F_input.mem", F);
        $readmemh("H_input.mem", H);
        $readmemh("P_input.mem", P_in);
        $readmemh("x_golden.mem", golden);
    end

    // ================================
    // DEBUG + CHECK
    // ================================
    integer i;
    integer errors;

    initial begin
        #20;

        $display("\n===== INTERNAL DEBUG =====");
        $display("X_pred[0] = %0d", dut.X_pred[0]);
        $display("y[0]      = %0d", dut.y[0]);
        $display("K[0][0]   = %0d", dut.K[0][0]);
        $display("================================\n");

        $display("===== DEBUG SAMPLE =====");
        $display("X_out[0] = %0d", X_out[0]);
        $display("Golden   = %0d", golden[0]);

        // 🔥 X DETECTION (CRITICAL)
        for (i = 0; i < N; i++) begin
            if (^X_out[i] === 1'bX) begin
                $display("🚨 X DETECTED at X_out[%0d]", i);
            end
        end

        // ================================
        // CHECK RESULTS
        // ================================
        errors = 0;

        $display("\n===== CHECKING RESULTS =====");

        for (i = 0; i < N; i++) begin
            if (X_out[i] !== golden[i]) begin
                $display("FAIL X[%0d]: DUT=%0d GOLD=%0d", i, X_out[i], golden[i]);
                errors++;
            end else begin
                $display("PASS X[%0d]", i);
            end
        end

        $display("\nTOTAL ERRORS = %0d", errors);
        $finish;
    end

endmodule