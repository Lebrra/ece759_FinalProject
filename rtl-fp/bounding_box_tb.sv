
`timescale 1ns/1ps
module bounding_box_tb();

    logic clk, rst_n, en, valid, err;
    logic [143:0] triangle;
    logic [15:0] x_min, x_max, y_min, y_max;

    bounding_box dut(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .triangle(triangle),
        .bbox_y_min_int(y_min),
        .bbox_y_max_int(y_max),
        .bbox_x_min_int(x_min),
        .bbox_x_max_int(x_max),
        .valid(valid)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        en = 0;
        triangle = 0;
        err = 0;

        @(posedge clk) rst_n = 1;
        en = 1;
        triangle = {16'h3c00, 16'h4000, 16'h4200,  // 1, 2, 3
                    16'h4400, 16'h4500, 16'h4600,  // 4, 5, 6
                    16'h4700, 16'h4800, 16'h4880}; // 7, 8, 9
        @(posedge clk) en = 0;
        
        repeat (21) @(posedge clk);
        @(negedge clk) if (~valid) begin
            $display("error! valid not asserted");
            err = 1;
        end

        repeat (10) @(posedge clk);

        if (~err)
            $display("YAHOO!! All tests passed.");
        $stop();
    end

    always
        #1 clk = ~clk;

endmodule