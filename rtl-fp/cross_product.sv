module cross_product(
    input wire clk, rst_n, en,
    input wire [47:0] vec_a, 
    input wire [47:0] vec_b, 
    output wire [47:0] normal,
    output wire valid
);

    // one cross product takes 15 cycles, output valid that many cycles after en goes high
    reg en_ff;
    reg [3:0] valid_counter;
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
    assign valid = &valid_counter;

    // decompose vectors
    wire [15:0] a1, a2, a3, b1, b2, b3, a2b3, a3b2, a1b3, a3b1, a1b2, a2b1, nx, ny, nz;
    assign a1 = vec_a[47:32];
    assign a2 = vec_a[31:16];
    assign a3 = vec_a[15:0];
    assign b1 = vec_b[47:32];
    assign b2 = vec_b[31:16];
    assign b3 = vec_b[15:0];

    // x component
    fp16mul mul_a2b3(
        .clk(clk),
        .areset(~rst_n),
        .a(a2),
        .b(b3),
        .q(a2b3)
    );
    fp16mul mul_a3b2(
        .clk(clk),
        .areset(~rst_n),
        .a(a3),
        .b(b2),
        .q(a3b2)
    );
    fp16_sub sub_x(
        .clk(clk),
        .areset(~rst_n),
        .a(a2b3),
        .b(a3b2),
        .q(nx)
    );

    // y component
    fp16mul mul_a1b3(
        .clk(clk),
        .areset(~rst_n),
        .a(a1),
        .b(b3),
        .q(a1b3)
    );
    fp16mul mul_a3b1(
        .clk(clk),
        .areset(~rst_n),
        .a(a3),
        .b(b1),
        .q(a3b1)
    );
    fp16sub sub_y(
        .clk(clk),
        .areset(~rst_n),
        .a(a1b3),
        .b(a3b1),
        .q(ny)
    );

    // z component
    fp16mul mul_a1b2(
        .clk(clk),
        .areset(~rst_n),
        .a(a1),
        .b(b2),
        .q(a1b2)
    );
    fp16mul mul_a2b1(
        .clk(clk),
        .areset(~rst_n),
        .a(a2),
        .b(b1),
        .q(a2b1)
    );
    fp16sub sub_z(
        .clk(clk),
        .areset(~rst_n),
        .a(a1b2),
        .b(a2b1),
        .q(nz)
    );

    // recombine vector components
    assign normal = {nx, ny, nz};

endmodule