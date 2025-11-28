module controller_test(
    input logic clk,
    input logic reset,
    input logic btnU,
    input logic btnL,
    input logic btnR,
    input logic btnD,

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

logic on_L;
logic on_R;
logic on;


assign split_hori = hori_cnt >> 4;
assign split_vert = vert_cnt >> 4;

VGA_hori_vert_cnt test1(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .VSYNC(Vsync),
    .HSYNC(Hsync),
    .hori_cnt(hori_cnt),
    .vert_cnt(vert_cnt)
);

pong_controller left(
    .clk(clk),
    .reset(reset),
    .vert_cnt(split_vert),
    .hori_cnt(split_hori),
    .paddle_down(btnD),
    .paddle_up(btnL),
    .on(on_L)
);

pong_controller #(.PADDLE_ROW(39)) right
(
    .clk(clk),
    .reset(reset),
    .vert_cnt(split_vert),
    .hori_cnt(split_hori),
    .paddle_down(btnR),
    .paddle_up(btnU),
    .on(on_R)
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

assign on = on_L | on_R;

always_comb begin
    if(on) begin 
        rgb_colour = 12'hFFF;
    end
    else begin
        rgb_colour = 12'h000;
    end
end 


endmodule