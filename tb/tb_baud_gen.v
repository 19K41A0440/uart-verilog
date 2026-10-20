`timescale 1ns/1ps
module tb_baud_gen;
    localparam CLK_FREQ = 1000;
    localparam BAUD     = 100;
    localparam DIV      = CLK_FREQ / BAUD;

    reg  clk = 0, rst_n = 0;
    wire tick;

    always #5 clk = ~clk;

    baud_gen #(.CLK_FREQ(CLK_FREQ), .BAUD(BAUD)) dut (
        .clk(clk), .rst_n(rst_n), .tick(tick)
    );

    integer ticks = 0, gap = 0, errors = 0;

    always @(posedge clk) if (rst_n) begin
        if (tick) begin
            if (ticks > 0 && gap != DIV - 1) begin
                errors = errors + 1;
                $display("ERROR: gap=%0d expected=%0d at %0t", gap, DIV-1, $time);
            end
            ticks = ticks + 1;
            gap   = 0;
        end else begin
            gap = gap + 1;
        end
    end

    initial begin
        $dumpfile("tb_baud_gen.vcd");
        $dumpvars(0, tb_baud_gen);
        #20 rst_n = 1;
        #(10 * DIV * 20 * 10);          // ~20 ticks
        if (errors == 0 && ticks >= 19) $display("PASS: %0d ticks", ticks);
        else                            $display("FAIL: ticks=%0d errors=%0d", ticks, errors);
        $finish;
    end
endmodule