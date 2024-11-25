`default_nettype none

module lighting(
    input wire clk, rst_n, en,
    input wire [143:0] triangle, // the triangle (duh)
    input wire [47:0] light_vec, // direction that the light source points
    input wire [23:0] input_rgb, // input color of the triangle (for now, assume white)
    output wire [23:0] output_rgb, // the resulting color of the triangle based on the lighting
    output wire valid, illuminated // valid tells us when the calculation is done
                                   // illuminated tells us if the triangle should be rendered or not
);

    // decompose triangle
    wire [47:0] vertex0, vertex1, vertex2, side0, side1;
    assign vertex0 = triangle[143:96];
    assign vertex1 = triangle[95:48];
    assign vertex2 = triangle[47:0];

    // this process calculates the normal vector for the triangle,
    // by finding the vectors that correspond to two of it's sides
    // and finding the cross product of these sides.
    wire cross_prod_en, normalize_en;
    wire [47:0] triangle_normal;
    vector_subtraction sub_2_0(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .vec_a(vertex2),
        .vec_b(vertex0),
        .vec_q(side0),
        .valid(cross_prod_en)
    );
    vector_subtraction sub_1_0(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .vec_a(vertex1),
        .vec_b(vertex0),
        .vec_q(side1),
        .valid(/* redundant */)
    );
    cross_product get_triangle_normal(
        .clk(clk),
        .rst_n(rst_n),
        .en(cross_prod_en),
        .vec_a(side0),
        .vec_b(side1),
        .normal(triangle_normal),
        .valid(normalize_en)
    );

    wire intensity_en;
    wire [47:0] normalized_normal;
    normalize normalize(
        .clk(clk),
        .rst_n(rst_n),
        .en(normalize_en),
        .vec(triangle_normal),
        .vec_n(normalized_normal),
        .valid(intensity_en)
    );

    // calculate the light intensity for this triangle
    // and if it is to be illuminated or not
    wire gtz_en;
    wire [15:0] intensity, intensity_enabled;
    dot_product calc_intensity(
        .clk(clk),
        .rst_n(rst_n),
        .en(intensity_en),
        .vec_a(normalized_normal),
        .vec_b(light_vec),
        .scalar(intensity),
        .valid(gtz_en)
    );
    assign intensity_enabled = gtz_en ? intensity : 16'h0000;
    fp16comp intensity_gtz(
        .clk(clk),
        .areset(~rst_n),
        .a(intensity_en),
        .b(16'h0000), // always compare against zero
        .q(illuminated)
    );

    // this conversion can be done in parallel with the above calculations
    wire [15:0] float_r, float_g, float_b;
    int_to_fp16 conv_r(
        .clk(clk),
        .areset(~rst_n),
        .a({8'h00, input_rgb[23:16]}),
        .q(float_r)
    );
    int_to_fp16 conv_g(
        .clk(clk),
        .areset(~rst_n),
        .a({8'h00, input_rgb[15:8]}),
        .q(float_g)
    );
    int_to_fp16 conv_b(
        .clk(clk),
        .areset(~rst_n),
        .a({8'h00, input_rgb[7:0]}),
        .q(float_b)
    );

    // however these must wait until everything above is finished
    wire [15:0] r_intensity, g_intensity, b_intensity;
    fp16mul mul_r(
        .clk(clk),
        .areset(~rst_n),
        .a(float_r),
        .b(intensity),
        .q(r_intensity)
    );
    fp16mul mul_g(
        .clk(clk),
        .areset(~rst_n),
        .a(float_g),
        .b(intensity),
        .q(g_intensity)
    );
    fp16mul mul_b(
        .clk(clk),
        .areset(~rst_n),
        .a(float_b),
        .b(intensity),
        .q(b_intensity)
    );

    // convert back to the int domain
    wire [15:0] output_r, output_g, output_b;
    fp16_to_int conv_r_back(
        .clk(clk),
        .areset(~rst_n),
        .a(r_intensity),
        .q(output_r)
    );
    fp16_to_int conv_r_back(
        .clk(clk),
        .areset(~rst_n),
        .a(r_intensity),
        .q(output_g)
    );
    fp16_to_int conv_r_back(
        .clk(clk),
        .areset(~rst_n),
        .a(r_intensity),
        .q(output_b)
    );
    assign output_rgb = {output_r[7:0], output_g[7:0], output_b[7:0]};

    // if the triangle is illuminated, assign the output as valid ONLY after the 9 cycle delay
    // of the color intensity multiplication / conversion
    // 
    // if it is NOT illuminated, we can say it is "valid" right away, since
    // we will not be writing to the frame buffer with this triangle
    reg gtz_en_ff;
    reg [3:0] gtz_counter;
    always_ff @(posedge clk)
        if (gtz_en)
            gtz_en_ff <= 1'b1;
        else if (valid)
            gtz_en_ff <= 1'b0;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            gtz_counter <= 4'h0;
        else if (valid)
            gtz_counter <= 4'h0;
        else if (gtz_en | gtz_en_ff)
            gtz_counter <= gtz_counter + 1;
    assign valid = ~illuminated | (gtz_counter == 9);

endmodule

`default_nettype wire