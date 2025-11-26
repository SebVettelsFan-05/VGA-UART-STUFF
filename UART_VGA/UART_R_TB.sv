`timescale 1ns/1ps

module uart_r_tb(
);
parameter CLK_PERIOD = 10;
parameter FULL_PERIOD = 10417*CLK_PERIOD; 

logic clk;
logic drdy;
logic serial_in;
logic [7:0] data;

always begin
    clk = 0;
    #(CLK_PERIOD/2);
    clk = 1;
    #(CLK_PERIOD/2);
end

uart_rec uut (
    .clk(clk),
    .drdy(drdy),
    .serial_in(serial_in),
    .data(data)
);

initial begin
    serial_in = 1;
    #(FULL_PERIOD/2);
    serial_in = 0;
    #(FULL_PERIOD*3);
    serial_in = 1;
    #(FULL_PERIOD*3);
    serial_in = 0;
    #(FULL_PERIOD*2);
    serial_in = 1;
    #FULL_PERIOD;
    $stop;
end
endmodule