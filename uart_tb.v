`timescale 1ns / 1ps

module uart_tb;

    reg clk;
    reg reset;
    reg send;
    reg [7:0] data_in;

    wire tx;
    wire [7:0] data_out;
    wire data_valid;
    wire busy;

    uart uut (
        .clk(clk),
        .reset(reset),
        .send(send),
        .data_in(data_in),
        .tx(tx),
        .data_out(data_out),
        .data_valid(data_valid),
        .busy(busy)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        send = 0;
        data_in = 8'h55;

        #100;

        reset = 0;

        #100;

        send = 1;
        #10;
        send = 0;

        #2000;

        $finish;

    end

endmodule