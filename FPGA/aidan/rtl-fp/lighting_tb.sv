`timescale 1ns/1ps
module lighting_tb();

    logic clk, rst_n, en, err;
    logic [143:0] triangle;
    logic [23:0] input_rgb, output_rgb_act, output_rgb_exp;
    logic valid, illuminated;
    logic [47:0] light_vec;

    // positive z axis is pointing out of the screen
    /*
         +y
         |
         |
         |
         |
         |___________+x
        /
       /
      /
    +z (screen this way)
    */

    assign light_vec = {16'h0000, 16'h0000, 16'hbc00}; // <0, 0, -1>

    lighting dut(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .triangle(triangle),
        .light_vec(light_vec),
        .input_rgb(input_rgb),
        .output_rgb(output_rgb_act),
        .valid(valid),
        .illuminated(illuminated)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        err = 0;
        en = 0;
        triangle = 0;
        input_rgb = 0;
        output_rgb_exp = 0;
        
        @(posedge clk) rst_n = 1;

        $display("test 1: in direct view of the light source");
        triangle = {{16'h4000, 16'h3c00, 16'h0000},
                    {16'h0000, 16'h3c00, 16'h0000},
                    {16'h3c00, 16'h0000, 16'h0000}};
        
        input_rgb = {8'hff, 8'hff, 8'hff};      // triangle is white
        output_rgb_exp = {8'hff, 8'hff, 8'hff};

        en = 1;
        @(posedge clk) en = 0;

        @(posedge valid);
        @(negedge clk) if (!illuminated || output_rgb_act !== output_rgb_exp) begin
            err = 1;
            $display("Error: triangle is not illuminated or the color does not match");
        end

        $display("test 2: completely obscured from the light source");
        triangle = {{16'h4000, 16'h3c00, 16'h0000},
                    {16'h3c00, 16'h0000, 16'h0000},
                    {16'h0000, 16'h3c00, 16'h0000}};
        
        input_rgb = {8'hff, 8'hff, 8'hff};      // triangle is white
        output_rgb_exp = {8'h00, 8'h00, 8'h00};

        @(posedge clk) en = 1;
        @(posedge clk) en = 0;

        @(posedge valid);
        @(negedge clk) if (illuminated || output_rgb_act !== output_rgb_exp) begin
            err = 1;
            $display("Error: triangle is not illuminated or the color does not match");
        end

        $display("test 3: partially obscured from the light source");
        triangle = {{16'h4000, 16'h3c00, 16'hc000},
                    {16'h0000, 16'h3c00, 16'h3c00},
                    {16'h3c00, 16'h0000, 16'h0000}};
        
        input_rgb = {8'hff, 8'hff, 8'hff};      // triangle is white

        @(posedge clk) en = 1;
        @(posedge clk) en = 0;

        @(posedge valid);
        @(negedge clk) if (!illuminated || output_rgb_act == 24'h000000 || output_rgb_act == 24'hffffff) begin
            err = 1;
            $display("Error: triangle is not illuminated or the color does not match");
        end








        $display("test 4: in direct view of the light source, different color");
        triangle = {{16'h4000, 16'h3c00, 16'h0000},
                    {16'h0000, 16'h3c00, 16'h0000},
                    {16'h3c00, 16'h0000, 16'h0000}};
        
        input_rgb = {8'hd0, 8'h88, 8'hd0};      // triangle is pink
        output_rgb_exp = {8'hd0, 8'h88, 8'hd0};

        @(posedge clk) en = 1;
        @(posedge clk) en = 0;

        @(posedge valid);
        @(negedge clk) if (!illuminated || output_rgb_act !== output_rgb_exp) begin
            err = 1;
            $display("Error: triangle is not illuminated or the color does not match");
        end

        $display("test 5: completely obscured from the light source, different color");
        triangle = {{16'h4000, 16'h3c00, 16'h0000},
                    {16'h3c00, 16'h0000, 16'h0000},
                    {16'h0000, 16'h3c00, 16'h0000}};
        
        output_rgb_exp = {8'h00, 8'h00, 8'h00};

        @(posedge clk) en = 1;
        @(posedge clk) en = 0;

        @(posedge valid);
        @(negedge clk) if (illuminated || output_rgb_act !== output_rgb_exp) begin
            err = 1;
            $display("Error: triangle is not illuminated or the color does not match");
        end

        $display("test 6: partially obscured from the light source, different color");
        triangle = {{16'h4000, 16'h3c00, 16'hc000},
                    {16'h0000, 16'h3c00, 16'h3c00},
                    {16'h3c00, 16'h0000, 16'h0000}};

        @(posedge clk) en = 1;
        @(posedge clk) en = 0;
        
        @(posedge valid);
        @(negedge clk) if (!illuminated || output_rgb_act == 24'h000000 || output_rgb_act == input_rgb) begin
            err = 1;
            $display("Error: triangle is not illuminated or the color does not match");
        end

        if (!err)
            $display("YAHOO!! All tests passed.");
        $stop();
    end

    always
        #1 clk = ~clk;

endmodule