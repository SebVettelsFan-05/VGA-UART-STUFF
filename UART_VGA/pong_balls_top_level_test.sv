module pong_ball_top_level (
    input logic clk, 
    input logic reset,
    
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic Vsync,
    output logic Hsync
);

logic [9:0] hori_cnt;
logic [9:0] vert_cnt;

logic [9:0] split_hori;
logic [9:0] split_vert;

logic [11:0] rgb_colour;

assign split_hori = hori_cnt >> 4;
assign split_vert = vert_cnt >> 4;

logic on;

VGA_hori_vert_cnt test1(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .VSYNC(Vsync),
    .HSYNC(Hsync),
    .hori_cnt(hori_cnt),
    .vert_cnt(vert_cnt)
);

vga_send_image test2(
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

pong_ball test3(
    .clk(clk),
    .reset(reset),
    .hori_cnt(split_hori),
    .vert_cnt(split_vert),
    .start(1'b1),
    .on(on)
);

always_comb begin
    if(on) begin 
        rgb_colour = 12'hFFF;
    end
    else begin
        rgb_colour = 12'h000;
    end
end 



endmodule