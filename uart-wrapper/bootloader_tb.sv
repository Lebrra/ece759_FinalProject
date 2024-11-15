`default_nettype none

import pkgTasks::*;

module bootloader_tb();

    // tb signals
    logic err;
    integer i, j;
    logic [31:0] tb_rx_data [6];
    logic [31:0] tb_tx_data;
    logic [31:0] exp_data;

    // DUT / host UART signals
    logic clk, rst_n, system_rst_n, dut_tx, dut_rx, bootload_en, transmit_en;
    logic [7:0] host_tx_data, host_rx_data;
    logic host_trmt, host_tx_done, host_rx_rdy, done_drawing;

    // memory signals
    logic [23:0] fb_input, fb_output;
    logic [20:0] fb_addr, bootloader_fb_addr;
    logic [143:0] triangle_data;
    logic [31:0] triangle_addr, triangle_read_addr;
    logic triangle_valid, fb_write, fb_read;
    reg [143:0] triangle_mem [2**32];
    wire [143:0] triangle_mem_read;

    // "host" UART
    UART host (
        .clk(clk),
        .rst_n(rst_n),
        .RX(dut_tx),
        .trmt(host_trmt),
        .clr_rx_rdy(host_rx_rdy),
        .tx_data(host_tx_data),
        .custom_baud_value(/* unused, baud rate is 115200 */),
        .TX(dut_rx),
        .tx_done(host_tx_done),
        .rx_rdy(host_rx_rdy),
        .rx_data(host_rx_data)
    );

    bootloader dut (
        .clk(clk),
        .rst_n(rst_n),
        .done_drawing(done_drawing),
        .bootload_en(bootload_en),
        .transmit_en(transmit_en),
        .pixel_rgb(fb_output),
        .bootload_triangle(triangle_data),
        .bootload_addr(triangle_addr),
        .RX(dut_rx), .TX(dut_tx),
        .system_rst_n(system_rst_n),
        .triangle_valid(triangle_valid),
        .read_fb(read_fb),
        .fb_addr(bootloader_fb_addr)
    );

    // frame buffer to read from
    frame_buffer fb (
        .clk(clk),
        .reset(~system_rst_n),
        .write_enable(fb_write),
        .addr(read_fb ? bootloader_fb_addr, fb_addr),
        .data(fb_input),
        .pixel_data(fb_output)
    );

    // triangle memory to write to
    always @(posedge clk, negedge rst_n)
        if (~rst_n)
            triangle_mem <= '0;
        else if (triangle_valid)
            triangle_mem[triangle_addr] <= triangle_data;
    assign triangle_mem_read = triangle_mem[triangle_read_addr];

    initial begin
        clk = 1;
        host_tx_data = 0;
        host_trmt = 0;
        err = 0;
        bootload_en = 1;
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        $display("BOOTLOAD test 1: send out one triangle");
        hostSendNumWords(
            .clk(clk),
            .host_tx_done(host_tx_done),
            .num_words(tb_rx_data[0]),
            .host_trmt(host_trmt),
            .host_tx_data(host_tx_data)
        );
        hostSendDataAndBootloaderRxIt(
            .clk(clk),
            .err(err),
            .host_tx_done(host_tx_done),
            .dut_instr_valid(dut_instr_valid),
            .dut_instr(dut_instr),
            .start_i(0),
            .num_words(1),
            .tb_rx_data(tb_rx_data),
            .host_tx_data(host_tx_data),
            .host_trmt(host_trmt)
        );

        // toggle bootloading
        bootload_en = 0;
        @(posedge clk);
        bootload_en = 1;

        $display("BOOTLOAD test 2: send out multiple instruction words");
        hostSendNumWords(
            .clk(clk),
            .host_tx_done(host_tx_done),
            .num_words(tb_rx_data[2]),
            .host_trmt(host_trmt),
            .host_tx_data(host_tx_data)
        );
        hostSendDataAndShitrRxIt(
            .clk(clk),
            .err(err),
            .host_tx_done(host_tx_done),
            .dut_instr_valid(dut_instr_valid),
            .dut_instr(dut_instr),
            .start_i(2),
            .num_words(3),
            .tb_rx_data(tb_rx_data),
            .host_tx_data(host_tx_data),
            .host_trmt(host_trmt)
        );

        // stop bootloading
        bootload_en = 0;

        $display("DEBUG test 1: check quick 4 byte write");
        for (i = 0; i < 4; i++)
            shitrSendDebugByte(
                .clk(clk),
                .err(err),
                .mm_write_en(mm_write_en),
                .host_rx_rdy(host_rx_rdy),
                .mm_addr(mm_addr),
                .mm_wdata(mm_wdata),
                .host_rx_data(host_rx_data),
                .index(i),
                .tb_tx_data(tb_tx_data)
            );

        $display("DEBUG test 2: check edge cases, full/empty queue");
        fillAndEmptyShitrQ(
            .clk(clk),
            .err(err),
            .mm_write_en(mm_write_en),
            .mm_read_en(mm_read_en),
            .host_rx_rdy(host_rx_rdy),
            .mm_addr(mm_addr),
            .mm_wdata(mm_wdata),
            .mm_rdata(mm_rdata),
            .tb_tx_data(tb_tx_data)
        );

        if (~err)
            $display("YAHOO!! All tests passed");
        $stop();
    end

    // initialize testbench data
    initial begin
        // bootloader "number of words"
        tb_rx_data[0] = 32'h0000_0001;

        // bootloader RX expected instr data
        tb_rx_data[1] = 32'hDEAD_C0DE;

        // bootloader "number of words"
        tb_rx_data[2] = 32'h0000_0003;

        // bootloader RX expected instr data
        tb_rx_data[3] = 32'h1122_3344;
        tb_rx_data[4] = 32'h6677_8899;
        tb_rx_data[5] = 32'hCCDD_EEFF;

        // debug TX expected print data
        tb_tx_data = 32'hABCD_F00D;
    end

    always
        #1 clk = ~clk;

    /*
        send a byte of a triangle over the host UART to the bootloader
    */
    task automatic hostSendByte;
        ref clk;
        ref host_tx_done;
        input [143:0] triangle;
        ref integer byte_index;
        ref host_trmt;
        ref [7:0] host_tx_data;

        // get the correct byte, tx it
        @(posedge clk);
        host_tx_data = {triangle >> byte_index*8};
        host_trmt = 1;

        @(posedge clk);
        host_trmt = 0;

        // wait for a tx to be done
        @(posedge host_tx_done);
    endtask

    /*
        sends out over the host UART the number of triangles
        that will follow in this transaction
    */
    task automatic hostSendNumTris;
        ref clk;
        ref host_tx_done;
        input integer num_tris;
        ref host_trmt;
        ref [7:0] host_tx_data;
        integer i;

        for (i = 0; i < 4; i++)
            hostSendByte(
                .clk(clk),
                .host_tx_done(host_tx_done),
                .byte_index(i),
                .triangle(num_tris),
                .host_trmt(host_trmt),
                .host_tx_data(host_tx_data)
            );
    endtask

    /*
        check that the data received over bootloader
        equals to the data sent over the host UART
    */
    task automatic hostSendDataAndBootloaderRxIt;
        ref clk, host_tx_done, dut_triangle_valid;
        ref [143:0] dut_triangle;
        input integer start_i, num_words;
        input [143:0] tb_rx_data [0:5];
        ref [7:0] host_tx_data;
        ref host_trmt, err;
        integer i, j;
        logic [31:0] exp_data;

        for (i = start_i; i < start_i + num_words; i++) begin
            // send 17 of 18 bytes, waiting for tx_done
            for (j = 0; j < 17; j++)
                hostSendByte(
                    .clk(clk),
                    .host_tx_done(host_tx_done),
                    .byte_index(j),
                    .triangle(tb_rx_data[i]),
                    .host_trmt(host_trmt),
                    .host_tx_data(host_tx_data)
                );

            // send out the last byte, DONT wait for tx_done
            @(posedge clk);
            host_tx_data = tb_rx_data[i][31:24];
            host_trmt = 1;

            @(posedge clk);
            host_trmt = 0;

            // wait for the triangle to be valid
            fork
                begin: timeout
                    repeat (100000) @(posedge clk);
                    err = 1;
                    $display("ERROR! Timed out waiting for triangle to be valid");
                    disable wait_triangle_valid;
                end
                begin: wait_triangle_valid
                    @(posedge dut_triangle_valid);
                    disable timeout;
                end
            join

            // actually check that the data matches
            @(posedge clk);
            if (dut_triangle !== tb_rx_data[i]) begin
                err = 1;
                $display("ERROR! Triangle did not match expected");
            end
            @(posedge host_tx_done);
        end
    endtask

endmodule

`default_nettype wire
