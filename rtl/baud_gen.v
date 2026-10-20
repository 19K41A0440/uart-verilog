module baud_gen #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD     = 115_200
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);
    localparam integer DIVISOR = CLK_FREQ / BAUD;
    localparam integer W       = $clog2(DIVISOR);

    reg [W-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt  <= 0;
            tick <= 1'b0;
        end else if (cnt == DIVISOR - 1) begin
            cnt  <= 0;
            tick <= 1'b1;
        end else begin
            cnt  <= cnt + 1;
            tick <= 1'b0;
        end
    end
endmodule