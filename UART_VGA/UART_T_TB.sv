`timescale 1ns/1ps
module uart_t_tb();
parameter CLK_PERIOD = 10;
parameter FULL_PERIOD = 10417*CLK_PERIOD;

logic clk;
logic [7:0] data_to_send;
logic enable;
logic serial_out;
logic done;

always begin
    clk = 0;
    #(CLK_PERIOD/2);
    clk = 1;
    #(CLK_PERIOD/2);
end

uart_trans uut(
    .clk(clk),
    .data_to_send(data_to_send),
    .enable(enable),
    .serial_out(serial_out),
    .done(done)
);

initial begin
    data_to_send = 8'b0110_0001;
    enable = 0;
    #(FULL_PERIOD);
    enable = 1;
    #(FULL_PERIOD);
    enable = 0;
    #(FULL_PERIOD*12);
    $stop;
end

endmodule