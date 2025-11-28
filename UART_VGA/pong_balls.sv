module pong_ball
#(
    parameter int COLUMNS = 40,
    parameter int ROW  = 30,
    parameter int DELAY = 5000000
)
(
    input logic clk,
    input logic reset,
    input logic [9:0] hori_cnt,
    input logic [9:0] vert_cnt,
    input logic start,

    output logic [10:0] ball_x,
    output logic [10:0] ball_y,
    output logic on
);

parameter half_col = COLUMNS/2;
parameter half_row = ROW/2;

logic [10:0] ball_y;
logic [10:0] ball_x;

logic [22:0] cnter;

logic dir_x; //dir x = 0, move left, dir x = 1, move right
logic dir_y; //dir y = 0, move down, dir y = 1, move up

always_ff @(posedge clk) begin
    if(reset) begin
        cnter <= 0;
        ball_x <= half_col - 1;
        ball_y <= half_row - 1;
        dir_x <= 0;
        dir_y <= 0;
    end 
    else if(start) begin
        if(cnter == DELAY) begin 
            cnter <= 0;

            if(dir_x == 1'b0) begin //moving left
                if(ball_x == 1'b0) begin
                    dir_x <= 1'b1;
                    ball_x <= ball_x + 1;
                end
                else begin
                    ball_x <= ball_x - 1;
                end
            end
            else if (dir_x == 1'b1) begin //moving right
                if(ball_x == COLUMNS - 1) begin
                    dir_x <= 1'b0;
                    ball_x <= ball_x - 1;
                end
                else begin
                    ball_x <= ball_x + 1;
                end
            end

            if(dir_y == 1'b0) begin //moving down
                if(ball_y == ROW - 1) begin
                    dir_y <= 1'b1;
                    ball_y <= ball_y - 1;
                end
                else begin
                    ball_y <= ball_y + 1;
                end
                
            end
            else if(dir_y == 1'b1) begin
                if(ball_y == 1'b0) begin
                    dir_y <= 1'b0;
                    ball_y <= ball_y + 1;
                end
                else begin
                    ball_y <= ball_y - 1;
                end
            end

        end
        else begin
            cnter <= cnter + 1;
        end

    end
    else begin
        dir_x <= 0;
        dir_y <= 0;
        ball_x <= half_col - 1;
        ball_y <= half_row - 1;
        cnter <= 0;
    end 
end


assign on = (hori_cnt == ball_x && vert_cnt == ball_y);

endmodule