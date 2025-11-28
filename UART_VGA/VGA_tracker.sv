module VGA_hori_vert_cnt
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
    input logic reset,
    input logic enable,
    
    output logic VSYNC,
    output logic HSYNC,
    output logic [9:0] hori_cnt,
    output logic [9:0] vert_cnt
);

parameter int hori_res = ACTIVE_HORI+FRONT_PORCH_HORI+SYNC_PULSE_HORI+BACK_PORCH_HORI;
parameter int vert_res = ACTIVE_VERT+FRONT_PORCH_VERT+SYNC_PULSE_VERT+BACK_PORCH_VERT;

parameter int hori_tot_time = ACTIVE_HORI+FRONT_PORCH_HORI+BACK_PORCH_HORI;
parameter int vert_tot_time = ACTIVE_VERT+FRONT_PORCH_VERT+BACK_PORCH_VERT;

logic pixel_clk;

downcounter #(.PERIOD(PERIOD_COUNT)) pixel_clock(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .zero(pixel_clk)
); 

always_ff @(posedge clk) begin
    if(reset) begin
        hori_cnt <= 0;
        vert_cnt <= 0;
    end
    else if (pixel_clk) begin
        if(hori_cnt == hori_res-1) begin
            hori_cnt <= 0;
            if(vert_cnt == vert_res-1) begin
                vert_cnt <= 0;
            end
            else begin
                vert_cnt <= vert_cnt + 1;
            end
        end 
        else begin
            hori_cnt <= hori_cnt + 1;
        end 
    end
end

assign HSYNC = ((hori_cnt >= (ACTIVE_HORI+FRONT_PORCH_HORI)) && (hori_cnt < (ACTIVE_HORI+FRONT_PORCH_HORI+SYNC_PULSE_HORI))) ? 1'b0 : 1'b1;
assign VSYNC = ((vert_cnt >= (ACTIVE_VERT+FRONT_PORCH_VERT)) && (vert_cnt < (ACTIVE_VERT+FRONT_PORCH_VERT+SYNC_PULSE_VERT))) ? 1'b0 : 1'b1;


endmodule