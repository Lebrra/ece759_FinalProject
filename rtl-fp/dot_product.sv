module dot_product(
    input wire clk, rst_n, en,
    input wire [47:0] vec_a, 
    input wire [47:0] vec_b, 
    output wire [15:0] product,
    output wire valid
);

    // unfortunately slower than cross product, since there are 2 summing stages
    // one dot product takes 25 cycles, output valid that many cycles after en goes high
    reg en_ff;
    reg [4:0] valid_counter;
    always_ff @(posedge clk)
        if (en)
            en_ff <= 1'b1;
        else if (valid)
            en_ff <= 1'b0;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            valid_counter <= 4'h0;
        else if (en | en_ff)
            valid_counter <= valid_counter + 1;
        else if (valid)
            valid_counter <= 4'h0;
    assign valid = valid_counter == 25;

    // decompose vectors
    wire [15:0] a1, a2, a3, b1, b2, b3, a1b1, a2b2, a3b3, sum_xy;
    assign a1 = vec_a[47:32];
    assign a2 = vec_a[31:16];
    assign a3 = vec_a[15:0];
    assign b1 = vec_b[47:32];
    assign b2 = vec_b[31:16];
    assign b3 = vec_b[15:0];

    fp16mul mul_a1b1(
        .clk(clk),
        .areset(~rst_n),
        .a(a1),
        .b(b1),
        .q(a1b1)
    );
    fp16mul mul_a2b2(
        .clk(clk),
        .areset(~rst_n),
        .a(a2),
        .b(b2),
        .q(a2b2)
    );
    fp16mul mul_a3b3(
        .clk(clk),
        .areset(~rst_n),
        .a(a3),
        .b(b3),
        .q(a3b3)
    );

    // these adders are cascaded, since we can't add three numbers together at once
    fp16add add_x_y(
        .clk(clk),
        .areset(~rst_n),
        .a(a1b1),
        .b(a2b2),
        .q(sum_xy)
    );
    fp16add add_z(
        .clk(clk),
        .areset(~rst_n),
        .a(sum_xy),
        .b(a3b3),
        .q(product)
    );

endmodule