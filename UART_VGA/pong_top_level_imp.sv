module top_level_pong(
    input logic clk,
    input logic reset,
    input logic btnU,
    input logic btnL,
    input logic btnR,
    input logic btnD,

    input logic pong_en,
    input logic RsRx,

    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic Vsync,
    output logic Hsync

);

logic [9:0] hori_cnt;
logic [9:0] vert_cnt;

logic uart_ready;

logic [11:0] rgb_colour;

uart_rec recieved(
    .clk(clk),
    .serial_in(RsRx),
    .drdy(uart_ready)
);


VGA_hori_vert_cnt SYNCs(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .VSYNC(Vsync),
    .HSYNC(Hsync),
    .hori_cnt(hori_cnt),
    .vert_cnt(vert_cnt)
);

vga_send_image SEND(
    .clk(clk),
    .enable(1'b1),
    .HSYNC(Hsync),
    .VSYNC(Vsync),
    .v_count(vert_cnt),
    .h_count(hori_cnt),
    .rgb_colour(rgb_colour),
    .RED(vgaRed),
    .BLUE(vgaBlue),
    .GREEN(vgaGreen)
);

pong_full_impl pong_imp(
    .clk(clk),
    .reset(reset),
    .enable(uart_ready),
    .vert_cnt(vert_cnt),
    .hori_cnt(hori_cnt),
    .paddle_down_r(btnD),
    .paddle_up_r(btnR),
    .paddle_down_l(btnL),
    .paddle_up_l(btnU),
    .rgb_colour(rgb_colour)
);

endmodule