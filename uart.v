module uart (
    input  wire       clk,
    input  wire       reset,
    input  wire       send,
    input  wire [7:0] data_in,

    output wire       tx,
    output wire [7:0] data_out,
    output wire       data_valid,
    output wire       busy
);

    uart_trans transmitter (
        .clk(clk),
        .reset(reset),
        .send(send),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    uart_rece receiver (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        .data_out(data_out),
        .data_valid(data_valid)
    );

endmodule