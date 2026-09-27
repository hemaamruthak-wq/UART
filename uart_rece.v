module uart_rece (
    input wire clk,
    input wire reset,
    input wire rx,

    output reg [7:0] data_out,
    output reg data_valid
);

    parameter CLKS_PER_BIT = 10;

    reg [13:0] clk_count;
    reg [3:0]  bit_count;
    reg [7:0]  rx_data;
    reg        receiving;

    always @(posedge clk) begin

        if (reset) begin
            clk_count  <= 0;
            bit_count  <= 0;
            rx_data    <= 0;
            data_out   <= 0;
            data_valid <= 0;
            receiving  <= 0;
        end

        else begin

            data_valid <= 0;

            // Wait for start bit
            if (!receiving) begin

                if (rx == 1'b0) begin
                    receiving <= 1'b1;
                    clk_count <= 0;
                    bit_count <= 0;
                end

            end

            else begin

                clk_count <= clk_count + 1;

                // First data bit: sample at middle of bit
                if (bit_count == 0) begin

                    if (clk_count == 14) begin
                        rx_data[0] <= rx;
                        bit_count <= 1;
                        clk_count <= 0;
                    end

                end

                // Remaining data bits
                else if (bit_count <= 7) begin

                    if (clk_count == 9) begin
                        rx_data[bit_count] <= rx;
                        bit_count <= bit_count + 1;
                        clk_count <= 0;
                    end

                end

                // Stop bit
                else begin

                    if (clk_count == 9) begin
                        data_out   <= rx_data;
                        data_valid <= 1;
                        receiving  <= 0;
                        bit_count  <= 0;
                        clk_count  <= 0;
                    end

                end

            end
        end
    end

endmodule