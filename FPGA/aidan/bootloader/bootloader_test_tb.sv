module bootloader_test_tb();

    logic clk, rst_n, bootload_en, transmit_en;
    logic [7:0] LED_out;
    wire [35:0] GPIO;

    logic [7:0] host_rx_data, host_tx_data;
    logic host_trmt, host_rx_rdy, host_tx_done;

    UART host(
        .clk(clk),
        .rst_n(rst_n),
        .RX(GPIO[3]),
        .trmt(host_trmt),
        .clr_rx_rdy(host_rx_rdy),
        .tx_data(host_tx_data),
        .custom_baud_value(/* unused, baud rate is 115200 */),
        .TX(GPIO[5]),
        .tx_done(host_tx_done),
        .rx_rdy(host_rx_rdy),
        .rx_data(host_rx_data)
    );

    bootloader_test dut(
        .FPGA_CLK1_50(clk),
        .KEY({1'b0, rst_n}),
        .LED(LED_out),
        .SW({2'b00, transmit_en, bootload_en}),
        .GPIO(GPIO)
    );
    integer i;
    initial begin
        clk = 0;
        rst_n = 0;
        transmit_en = 0;
        bootload_en = 0;
        host_tx_data = 0;
        host_trmt = 0;
        i=0;

        @(posedge clk) rst_n = 1;
        bootload_en = 1;
        host_tx_data = 8'h01;
        host_trmt = 1;
        @(posedge clk) host_trmt = 0;
        @(posedge host_tx_done);
        host_tx_data = 8'h00;
        host_trmt = 1;
        @(posedge clk) host_trmt = 0;
        @(posedge host_tx_done);
        host_tx_data = 8'h00;
        host_trmt = 1;
        @(posedge clk) host_trmt = 0;
        
        repeat (18) begin
            @(posedge host_tx_done);
            host_tx_data = 8'h25+i;
            host_trmt = 1;
            i=i+1;
            @(posedge clk) host_trmt = 0;
        end

        @(posedge dut.triangle_valid);
        repeat (10) @(posedge clk);
        bootload_en = 0;

        repeat (100) @(posedge clk);
        transmit_en = 1;

        repeat (21) @(posedge host_rx_rdy);

        repeat (100) @(posedge clk);



        $stop();
    end

    always
        #1 clk = ~clk;

endmodule