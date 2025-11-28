module pong_full_impl 
#(
    parameter PADDLE_HEIGHT = 6,
    parameter COLUMNS = 40,
    parameter ROWS = 30
)
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [9:0] vert_cnt,
    input logic [9:0] hori_cnt,

    input logic paddle_down_r,
    input logic paddle_up_r,

    input logic paddle_down_l,
    input logic paddle_up_l,

    output logic [11:0] rgb_colour 
);

logic [9:0] split_hori;
logic [9:0] split_vert;

logic on_R;
logic on_L;
logic on_B;
logic on;

logic [10:0] ball_x;
logic [10:0] ball_y;

logic start;

logic [5:0] height_r;
logic [5:0] height_l;

assign split_hori = hori_cnt >> 4;
assign split_vert = vert_cnt >> 4;

typedef enum {IDLE, GAME_RUNNING, STOPPED} STATE;

STATE state = IDLE;

pong_controller #(.PADDLE_HEIGHT(PADDLE_HEIGHT)) left(
    .clk(clk),
    .reset(reset),
    .vert_cnt(split_vert),
    .hori_cnt(split_hori),
    .paddle_down(paddle_down_l),
    .start(start),
    .paddle_up(paddle_up_l),
    .on(on_L),
    .height(height_l)
);

pong_controller #(.PADDLE_ROW(39), .PADDLE_HEIGHT(PADDLE_HEIGHT)) right
(
    .clk(clk),
    .reset(reset),
    .vert_cnt(split_vert),
    .hori_cnt(split_hori),
    .paddle_down(paddle_down_r),
    .paddle_up(paddle_up_r),
    .start(start),
    .on(on_R),
    .height(height_r)
);

pong_ball balls (
    .clk(clk),
    .reset(reset),
    .hori_cnt(split_hori),
    .vert_cnt(split_vert),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .start(start),
    .on(on_B)
);

assign on = on_B | on_L | on_R;

always_comb begin
    if(on) begin 
        rgb_colour = 12'h000;
    end
    else begin
        rgb_colour = 12'hF0F;
    end
end 

always_ff @(posedge clk) begin
    case(state)
        IDLE: begin
            if(enable) begin
                state <= GAME_RUNNING;
                start <= 1'b1;
            end
            else begin
                state <= IDLE;
                start <= 1'b0;
            end
        end
        GAME_RUNNING: begin
            if(ball_x == 0 && (height_l - 2 > ball_y || ball_y-2 > height_l+PADDLE_HEIGHT)) begin //player 1 loses
                state <= STOPPED;
                start <= 1'b0;
            end
            if((ball_x == COLUMNS - 1 ) && (height_r - 2 > ball_y || ball_y - 2 > height_r+PADDLE_HEIGHT)) begin //player 2 loses
                state <= STOPPED;
                start <= 1'b0;
            end

        end
        STOPPED: begin
            start <= 1'b0;
            state <= IDLE;
        end
    endcase
end 

endmodule