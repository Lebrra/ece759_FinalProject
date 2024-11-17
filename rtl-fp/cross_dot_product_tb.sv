
`timescale 1 ps / 1 ps
module cross_dot_product_tb();

    // tb signals
    reg err;
    reg clk, rst_n, cross_en, dot_en, norm_en, cross_valid, dot_valid, norm_valid;
    reg [47:0] test_vec_a, test_vec_b;
    reg [47:0] actual_normal, expected_normal, actual_normalized, expected_normalized;
    reg [15:0] actual_scalar, expected_scalar;

    // instantiate DUTs
    cross_product cross_dut(
        .clk(clk), .rst_n(rst_n), .en(cross_en),
        .vec_a(test_vec_a),
        .vec_b(test_vec_b),
        .normal(actual_normal),
        .valid(cross_valid)
    );
    dot_product dot_dut(
        .clk(clk), .rst_n(rst_n), .en(dot_en),
        .vec_a(test_vec_a),
        .vec_b(test_vec_b),
        .scalar(actual_scalar),
        .valid(dot_valid)
    );
    normalize norm_dut(
        .clk(clk), .rst_n(rst_n), .en(norm_en),
        .vec(test_vec_a),
        .vec_n(actual_normalized),
        .valid(norm_valid)
    );


    initial begin
        err = 0;
        clk = 1;
        rst_n = 0;
        cross_en = 0;
        dot_en = 0;
        test_vec_a = 0;
        test_vec_b = 0;

        @(posedge clk) rst_n = 1;

        $display("Test 1: Cross product on two simple vectors");
        cross_en = 1;
        test_vec_a = {16'hbc00, 16'h0000, 16'hbc00};      // <-1, 0, -1>
        test_vec_b = {16'hbc00, 16'h0000, 16'h0000};      // <-1, 0, 0>
        expected_normal = {16'h0000, 16'h3c00, 16'h0000}; // <0, 1, 0>

        @(posedge clk) cross_en = 0;

        repeat (14) @(posedge clk);
        @(negedge clk) if (~cross_valid) begin
            err = 1;
            $display("Test 1: Cross product not valid when expected!");
        end else if (actual_normal !== expected_normal) begin
            err = 1;
            $display("Test 1: Normals do not match!");
        end

        $display("Test 2: Cross product on two arbitrary vectors");
        @(posedge clk) cross_en = 1;
        test_vec_a = {16'h4248, 16'h4248, 16'h4248};
        test_vec_b = {16'h4c31, 16'hcd00, 16'hbda8};
        expected_normal = {16'h534b, 16'h5323, 16'hd737};

        @(posedge clk) cross_en = 0;

        repeat (14) @(posedge clk);
        @(negedge clk) if (~cross_valid) begin
            err = 1;
            $display("Test 2: Cross product not valid when expected!");
        end else if (actual_normal !== expected_normal) begin
            err = 1;
            $display("Test 2: Normals do not match!");
        end

        $display("Test 3: Cross product on parallel vectors");
        @(posedge clk) cross_en = 1;
        test_vec_a = {16'h3c00, 16'h0000, 16'h3c00};
        test_vec_b = {16'hbc00, 16'h0000, 16'hbc00};
        expected_normal = 48'h800000000000; // 8000 is just -0

        @(posedge clk) cross_en = 0;

        repeat (14) @(posedge clk);
        @(negedge clk) if (~cross_valid) begin
            err = 1;
            $display("Test 3: Cross product not valid when expected!");
        end else if (actual_normal !== expected_normal) begin
            err = 1;
            $display("Test 3: Normals do not match!");
        end

        $display("Test 4: Dot product on arbitrary vectors");
        @(posedge clk) dot_en = 1;
        test_vec_a = {16'h4248, 16'h4248, 16'h4248};
        test_vec_b = {16'h4c31, 16'hcd00, 16'hbda8};
        expected_scalar = 16'hcb4c;

        @(posedge clk) dot_en = 0;

        repeat (24) @(posedge clk);
        @(negedge clk) if (~dot_valid) begin
            err = 1;
            $display("Test 4: Dot product not valid when expected!");
        end else if (actual_scalar !== expected_scalar) begin
            err = 1;
            $display("Test 4: Scalars do not match!");
        end

        $display("Test 5: Dot product on orthogonal vectors");
        @(posedge clk) dot_en = 1;
        test_vec_a = {16'h3c00, 16'h0000, 16'h0000};
        test_vec_b = {16'h0000, 16'h0000, 16'hbc00};
        expected_scalar = 16'h0000;

        @(posedge clk) dot_en = 0;

        repeat (24) @(posedge clk);
        @(negedge clk) if (~dot_valid) begin
            err = 1;
            $display("Test 5: Dot product not valid when expected!");
        end else if (actual_scalar !== expected_scalar) begin
            err = 1;
            $display("Test 5: Scalars do not match!");
        end

        $display("Test 6: Normalization on arbitrary vector");
        @(posedge clk) norm_en = 1;
        test_vec_a = {16'h4c31, 16'hcd00, 16'hbda8};
        expected_normalized = {16'h3922, 16'hba20, 16'haaed};

        @(posedge clk) norm_en = 0;

        repeat (32) @(posedge clk);
        @(negedge clk) if (~norm_valid) begin
            err = 1;
            $display("Test 6: Normalization not valid when expected!");
        end else if (actual_normalized !== expected_normalized) begin
            err = 1;
            $display("Test 6: Unit vectors do not match!");
        end

        $display("Test 7: Normalization on already unit vector");
        @(posedge clk) norm_en = 1;
        test_vec_a = {16'h3c00, 16'h0000, 16'h0000};
        expected_normalized = {16'h3c00, 16'h0000, 16'h0000};

        @(posedge clk) norm_en = 0;

        repeat (32) @(posedge clk);
        @(negedge clk) if (~norm_valid) begin
            err = 1;
            $display("Test 7: Normalization not valid when expected!");
        end else if (actual_normalized !== expected_normalized) begin
            err = 1;
            $display("Test 7: Unit vectors do not match!");
        end

        repeat (8) @(posedge clk);

        if (~err)
            $display("YAHOO!! All tests passed.");
        $stop();
    end

    always
        #1 clk = ~clk;

endmodule