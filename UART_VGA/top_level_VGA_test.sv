module top_level_vga_test(
    input logic clk,
    input logic reset,

    output logic [3:0] vgaRed,
    output logic [3:0] vgaBlue,
    output logic [3:0] vgaGreen,
    output logic Hsync,
    output logic Vsync
);

logic [9:0] v_count;
logic [9:0] h_count;

VGA_hori_vert_cnt test1 (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .VSYNC(Vsync),
    .HSYNC(Hsync),
    .hori_cnt(h_count),
    .vert_cnt(v_count)
);

vga_send_image test2 (
    .clk(clk),
    .enable(1'b1),
    .HSYNC(Hsync),
    .VSYNC(Vsync),
    .v_count(v_count),
    .h_count(h_count),
    .RED(vgaRed),
    .BLUE(vgaBlue),
    .GREEN(vgaGreen)
);


endmodule