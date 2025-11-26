module uart_trans
#(
    parameter int PERIOD = 10417
)
(
    input logic clk,
    input logic [7:0] data_to_send,
    input logic enable,
    output logic serial_out,
    output logic done
);

typedef enum {s_START, s_SSEQUENCE, s_SHIFTTRANS} STATE;

STATE current_state = s_START;

logic [$clog2(PERIOD)-1:0] cnter;
logic [$clog2(9)-1 : 0] index;
logic [7:0] shift_reg;

int i;

always_ff @(posedge clk) begin
    case(current_state)
    s_START: begin
        serial_out <= 1;
        done <= 0;
        cnter <= 0;
        index <= 0;
        shift_reg <= 0;
        if(enable) begin
            shift_reg <= data_to_send;
            current_state <= s_SSEQUENCE;
        end 
        else begin
            current_state <= s_START;
        end 
    end
    s_SSEQUENCE: begin
        serial_out <= 0;
        if(cnter == PERIOD) begin
            current_state <= s_SHIFTTRANS;
            cnter <=0;
        end
        else begin
            cnter <= cnter + 1;
        end 
    end
    s_SHIFTTRANS: begin
        serial_out <= shift_reg[0];
        if(index <= 7) begin
            if(cnter == PERIOD) begin
                cnter <= 0;
                index <= index + 1;
                shift_reg[7] <= 0;
                for(int i = 1; i < 8; i++) begin
                    shift_reg[i-1] <= shift_reg[i];
                end
            end
            else begin
                cnter <= cnter + 1;
            end 
        end
        else begin
            done <= 1;
            current_state <= s_START;
        end
    end
    endcase

end

endmodule