module vga_send_image 
#(
    parameter int ACTIVE_HORI = 640,
    parameter int FRONT_PORCH_HORI = 16,
    parameter int SYNC_PULSE_HORI = 96,
    parameter int BACK_PORCH_HORI = 48,

    parameter int ACTIVE_VERT = 480,
    parameter int FRONT_PORCH_VERT = 10,
    parameter int SYNC_PULSE_VERT = 2,
    parameter int BACK_PORCH_VERT = 33,

    parameter int PERIOD_COUNT = 4
)
(
    input logic clk,
    input logic enable,
    input logic HSYNC,
    input logic VSYNC,
    input logic [9:0] v_count,
    input logic [9:0] h_count,

    input logic [11:0] rgb_colour,


    output logic [3:0] RED,
    output logic [3:0] BLUE,
    output logic [3:0] GREEN
);

localparam int hori_res = ACTIVE_HORI+FRONT_PORCH_HORI+SYNC_PULSE_HORI+BACK_PORCH_HORI;
localparam int vert_res = ACTIVE_VERT+FRONT_PORCH_VERT+SYNC_PULSE_VERT+BACK_PORCH_VERT;

logic valid;

assign valid = (h_count < ACTIVE_HORI) && (v_count < ACTIVE_VERT);

always_ff @(posedge clk) begin
    if(enable) begin
        if(valid) begin
            RED <= rgb_colour[11:8];
            GREEN <= rgb_colour[7:4];
            BLUE <= rgb_colour[3:0];
        end
        else begin
            RED <= 4'h0;
            GREEN <= 4'h0;
            BLUE <= 4'h0;
        end
    end

end
endmodule