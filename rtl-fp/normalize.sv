module normalize(
    input wire clk, rst_n, en,
    input wire [47:0] vec, 
    output wire [47:0] vec_n,
    output wire valid
);
    // unfortunately this is super slow, even if inv sqrt is fast
    // one normalization takes 33 cycles
    reg en_ff;
    reg [5:0] valid_counter;
    always_ff @(posedge clk)
        if (en)
            en_ff <= 1'b1;
        else if (valid)
            en_ff <= 1'b0;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            valid_counter <= 6'h00;
        else if (valid)
            valid_counter <= 6'h00;
        else if (en | en_ff)
            valid_counter <= valid_counter + 1;
    assign valid = valid_counter == 33;

    // get magnitude of the vector
    wire [15:0] magnitude;
    dot_product get_magnitude(
        .clk(clk), .rst_n(rst_n), .en(en),
        .vec_a(vec),
        .vec_b(vec),
        .scalar(magnitude),
        .valid()
    );

    // get the inverse square root of the magnitude
    wire [15:0] mag_invsqrt;
    fp16invsqrt invsqrt(
        .clk(clk),
        .areset(~rst_n),
        .a(magnitude),
        .q(mag_invsqrt)
    );

    // multiply the inverse square root by each part of the vector
    fp16mul mul_x(
        .clk(clk),
        .areset(~rst_n),
        .a(vec[47:32]),
        .b(mag_invsqrt),
        .q(vec_n[47:32])
    );
    fp16mul mul_y(
        .clk(clk),
        .areset(~rst_n),
        .a(vec[31:16]),
        .b(mag_invsqrt),
        .q(vec_n[31:16])
    );
    fp16mul mul_z(
        .clk(clk),
        .areset(~rst_n),
        .a(vec[15:0]),
        .b(mag_invsqrt),
        .q(vec_n[15:0])
    );

endmodule