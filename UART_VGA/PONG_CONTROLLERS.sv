module pong_controller
#(
    parameter int PADDLE_HEIGHT = 6,
    parameter int PADDLE_ROW = 0,
    parameter int SCREEN_HEIGHT = 30,
    parameter int DELAY = 5000000//(100MHz/5MHz)
)
(
    input logic clk,
    input logic reset,
    input logic [9:0] vert_cnt,
    input logic [9:0] hori_cnt,
    input logic paddle_up,
    input logic paddle_down,
    input logic start,
    output logic on,
    output logic [5:0] height
);

logic [22:0] cnter;
logic valid_input;

assign valid_input = paddle_up ^ paddle_down;

always_ff @(posedge clk) begin
    if(reset) begin
        height <= 0;
    end 
    else if(valid_input & start) begin
        if(cnter == DELAY) begin
            cnter <= 0;
        end 
        else begin
            cnter <= cnter + 1;
        end 
        if(cnter == DELAY && paddle_down && height !== SCREEN_HEIGHT-PADDLE_HEIGHT-1) begin
            height <= height + 1;
        end
        if(cnter == DELAY && paddle_up && height !== 0) begin
            height <= height - 1;
        end
    end
    else begin
        cnter <= 0;      // reset counter
    end
end

//how the fuck do we know when to turn on?


assign on = (hori_cnt == PADDLE_ROW && vert_cnt <= height + PADDLE_HEIGHT && vert_cnt >= height);

endmodule