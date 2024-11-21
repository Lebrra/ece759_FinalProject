module bounding_box(
    input wire clk, rst_n,
    input wire [143:0] triangle,
    //output logic [7:0] bbox_y_min, bbox_y_max, bbox_x_min, bbox_x_max
    output logic valid
);
    // 2 bit counter, determines when we have found the bbox based on each vertex
    wire count_3;
    reg [1:0] counter;
    logic inc_count;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            counter <= 2'b00;
        else if (count_3)
            counter <= 2'b00;
        else if (inc_count)
            counter <= counter + 1;
    assign count_3 = &count;

    // decompose triangle
    logic next_vertex;
    wire [15:0] vertex_x, vertex_y;
    // TODO: assign vertex values here. shift triangle data ? use ff ?

    logic [7:0] bbox_y_min, bbox_y_max, bbox_x_min, bbox_x_max;
    wire [15:0] curr_bbox_x_min, curr_bbox_y_min, curr_bbox_x_max, curr_bbox_y_max;

    // bbox_x_max calculation
    wire [15:0] inter0;
    fp16_max max0(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_x_max),
        .b(vertex_x),
        .q(inter0)
    );
    fp16_min min0(
        .clk(clk),
        .areset(~rst_n),
        .a(16'h5bf8), // float16(255)
        .b(inter0),
        .q(curr_bbox_x_max)
    );

    // bbox_x_min calculation
    wire [15:0] inter1;
    fp16_min min1(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_x_min),
        .b(vertex_x),
        .q(inter1)
    );
    fp16_max max1(
        .clk(clk),
        .areset(~rst_n),
        .a(16'h0000),
        .b(inter1),
        .q(curr_bbox_x_min)
    );

    // bbox_y_max calculation
    wire [15:0] inter2;
    fp16_max max2(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_y_max),
        .b(vertex_y),
        .q(inter2)
    );
    fp16_min min2(
        .clk(clk),
        .areset(~rst_n),
        .a(16'h5bf8), // float16(255)
        .b(inter2),
        .q(curr_bbox_y_max)
    );

    // bbox_y_min calculation
    wire [15:0] inter3;
    fp16_min min3(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_y_min),
        .b(vertex_y),
        .q(inter3)
    );    
    fp16_max max3(
        .clk(clk),
        .areset(~rst_n),
        .a(16'h0000),
        .b(inter3),
        .q(curr_bbox_y_min)
    );

    typedef enum reg [1:0] {IDLE, CMP_1, BUF, CMP_2} state_t;
    state_t prev_state, state, next_state;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n) begin
            state <= IDLE;
            prev_state <= IDLE;
        end else begin
            state <= next_state;
            prev_state <= state;
        end

    always_comb begin
       // sm defaults
        bbox_x_max = curr_bbox_x_max;
        bbox_x_min = curr_bbox_x_min;
        bbox_y_max = curr_bbox_y_max;
        bbox_y_min = curr_bbox_y_min;
        valid = 0;
        next_vertex = 0;
        inc_count = 0;
        next_state = state;

        case (state)
            CMP_1: // compare vertices with current bbox
                next_state = BUF;

            BUF:   // 1 cycle buffer between comparisons
                if (count_3) begin
                    next_state = IDLE;
                    valid = 1;
                end else if (prev_state == CMP_1) begin
                    next_state = CMP_2;
                    next_vertex = 1;
                end else if (prev_state == CMP_2)
                    next_state = CMP_1;

            CMP_2: begin // compare CMP_1 with screen borders
                inc_count = 1;
                next_state = BUF;
            end

            default: // IDLE state
                if (en) begin
                    bbox_x_max = 0;
                    bbox_x_min = 255;
                    bbox_y_max = 0;
                    bbox_y_min = 255;
                    next_state = CMP_1;
                end
        endcase
    end

endmodule