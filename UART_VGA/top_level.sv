module top_level(
    input logic clk,
    input logic reset,
    input logic RsRx,
    input logic btnU,
    
    output logic RsTx,
    output logic CA, CB, CC, CD, CE, CF, CG, DP,
    output logic AN1, AN2, AN3, AN4,
    output logic [15:0] led
);

logic [7:0] data;
logic drdy;

logic [7:0] data_rdy;

logic enable_rx;    
logic done_rx;
logic prev_but;

uart_rec Reciever(
    .clk(clk),
    .serial_in(RsRx),
    .drdy(drdy),
    .data(data)
);

uart_trans Transmitter(
    .clk(clk),
    .data_to_send(8'd61),
    .enable(enable_rx),
    .serial_out(RsTx),
    .done(done_rx)
);



always_ff @(posedge clk) begin
    if(drdy) begin
        data_rdy <= data;
    end 
end

always_ff @(posedge clk) begin
    prev_but <= btnU;
    if(prev_but & ~btnU) begin
        enable_rx <= 1;
    end
    else begin
        enable_rx <= 0;
    end
end

seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY(
    .clk(clk), 
    .reset(reset), 
    .sec_dig1(data_rdy[3:0]),     // Lowest digit
    .sec_dig2(data_rdy[7:4]),     // Second digit
    .min_dig1(4'b0000),    // Third digit
    .min_dig2(4'b0000),   // Highest digit
    .decimal_point(4'b0000),
    .CA(CA), .CB(CB), .CC(CC), .CD(CD), 
    .CE(CE), .CF(CF), .CG(CG), .DP(DP), 
    .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4)    
);



endmodule 