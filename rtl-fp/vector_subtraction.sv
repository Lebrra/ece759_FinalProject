`default_nettype none

module vector_subtraction(
    input wire clk, rst_n, en,
    input wire [47:0] vec_a, vec_b,
    output wire [47:0] vec_q,
    output wire valid
);
    // since these can be done in parallel, it only takes 10 total cycles
    reg en_ff;
    reg [3:0] valid_counter;
    always_ff @(posedge clk)
        if (en)
            en_ff <= 1'b1;
        else if (valid)
            en_ff <= 1'b0;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            valid_counter <= 5'h00;
        else if (valid)
            valid_counter <= 5'h00;
        else if (en | en_ff)
            valid_counter <= valid_counter + 1;
    assign valid = valid_counter == 10;

    // decompose vectors
    wire [15:0] a1, a2, a3, b1, b2, b3, q1, q2, q3;
    assign a1 = vec_a[47:32];
    assign a2 = vec_a[31:16];
    assign a3 = vec_a[15:0];
    assign b1 = vec_b[47:32];
    assign b2 = vec_b[31:16];
    assign b3 = vec_b[15:0];

    fp16sub sub_x(
        .clk(clk),
        .areset(~rst_n),
        .a(a1),
        .b(b1),
        .q(q1)
    );
    fp16sub sub_y(
        .clk(clk),
        .areset(~rst_n),
        .a(a2),
        .b(b2),
        .q(q2)
    );
    fp16sub sub_z(
        .clk(clk),
        .areset(~rst_n),
        .a(a3),
        .b(b3),
        .q(q3)
    );
    assign vec_q = {q1, q2, q3};

endmodule

`default_nettype wire