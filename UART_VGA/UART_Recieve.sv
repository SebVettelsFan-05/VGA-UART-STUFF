module uart_rec 
#(
    parameter int PERIOD = 10417
)
(
    input logic clk,
    input logic serial_in,
    output logic drdy,
    output logic [7:0] data
);

parameter int HALF_PERIOD = PERIOD/2;


typedef enum {s_START, s_VERIFY, s_SAMPLE, s_FINISH } STATE;

logic pre_ser_in;
logic [$clog2(PERIOD)-1:0] cnter;
logic [$clog2(9)-1 : 0] index;
logic [7:0] data_inter;

int i;

STATE current_state = s_START;


always_ff @(posedge clk) begin
    case(current_state) 
    s_START: begin
        drdy <= 0;
        cnter <= 0;
        index <= 0;
        data_inter <= 0;
        pre_ser_in <= serial_in;
        if (pre_ser_in & ~serial_in) begin
            current_state <= s_VERIFY;
        end 
        else begin
            current_state <= s_START;
        end
    end
    s_VERIFY: begin
        if(cnter == HALF_PERIOD)begin
            cnter <= 0;
            drdy <= 0;
            if(~serial_in) begin
                current_state <= s_SAMPLE;
            end
            else begin
                current_state <= s_START;
            end 
        end
        else begin
            cnter <= cnter + 1;
        end
    end

    s_SAMPLE: begin
        if(cnter == PERIOD) begin
            cnter <= 0;
            drdy <= 0;
            if(index <= 7) begin
                for(int i = 1; i < 8; i++) begin
                    data_inter[i-1] <= data_inter[i];
                end
                data_inter[7] <= serial_in;
                index <= index + 1;
            end
            else begin
                current_state <= s_FINISH;
            end 
        end
        else begin
            cnter <= cnter + 1;
        end
    end

    
    s_FINISH: begin
        drdy <= 1;
        data <= data_inter;
        current_state <= s_START;
    end
    endcase
end
endmodule