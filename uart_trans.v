module uart_trans (
    input  wire       clk,
    input  wire       reset,
    input  wire       send,
    input  wire [7:0] data_in,

    output reg        tx,
    output reg        busy
);

    parameter CLKS_PER_BIT = 10;

    reg [13:0] clk_count;
    reg [3:0]  bit_count;
    reg [9:0]  tx_data;

    always @(posedge clk) begin

        if (reset) begin
            clk_count <= 0;
            bit_count <= 0;
            tx_data   <= 10'b1111111111;
            tx        <= 1'b1;
            busy      <= 1'b0;
        end

        else if (send && !busy) begin
            tx_data   <= {1'b1, data_in, 1'b0};
            clk_count <= 0;
            bit_count <= 0;
            busy      <= 1'b1;
            tx        <= 1'b0;
        end

        else if (busy) begin

            if (clk_count == CLKS_PER_BIT - 1) begin
                clk_count <= 0;

                if (bit_count == 9) begin
                    bit_count <= 0;
                    busy      <= 1'b0;
                    tx        <= 1'b1;
                end

                else begin
                    bit_count <= bit_count + 1;
                    tx        <= tx_data[bit_count + 1];
                end
            end

            else begin
                clk_count <= clk_count + 1;
            end
        end

        else begin
            tx <= 1'b1;
        end
    end

endmodule