`timescale 1ns/1ps
module VGA_SYNC_TRACTOR_TB();
parameter CLK_PERIOD = 10;

logic clk;
logic reset;
logic enable;

logic VSYNC;
logic HSYNC;

logic [9:0] hori_cnt;
logic [9:0] vert_cnt;


always begin
    clk = 0;
    #(CLK_PERIOD/2);
    clk = 1;
    #(CLK_PERIOD/2);
end

VGA_hori_vert_cnt uut(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .VSYNC(VSYNC),
    .HSYNC(HSYNC),
    .hori_cnt(hori_cnt),
    .vert_cnt(vert_cnt)
);

initial begin
    reset = 1;
    #CLK_PERIOD;
    reset = 0;
    #(CLK_PERIOD*10)
    enable = 1;
    #(CLK_PERIOD*1000)
    $stop;
end

endmodule