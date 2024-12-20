`default_nettype none

/*
    this module calculates the bounding box (rectangle)
    that surrounds any given triangle, so that we do not
    have to scan the ENTIRE screen each time we compute
    a triangle. this allows us to speed up our calculations
*/
module bounding_box(
    input wire clk, rst_n, en,
    input wire [143:0] triangle,
    output wire [15:0] bbox_y_min_int, bbox_y_max_int, bbox_x_min_int, bbox_x_max_int,
    output wire valid
);
    /////////////////////////////////////
    // 2 bit counter to keep track of //
    // how many vertices we have     //
    // updated the bbox with        //
    /////////////////////////////////
    wire bbox_calc_done;
    reg [1:0] vertex_counter;
    logic inc_vertex_counter;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            vertex_counter <= 2'b00;
        else if (bbox_calc_done)
            vertex_counter <= 2'b00;
        else if (inc_vertex_counter)
            vertex_counter <= vertex_counter + 1;
    assign bbox_calc_done = &vertex_counter;

    //////////////////////////////////////////////////////////
    // 3 bit counter, determines when the float16 bbox     //
    // number has been converted to an int, and           //
    // is thus safe to read at the output (assert valid) //
    //////////////////////////////////////////////////////
    reg [2:0] conv_counter;
    reg conv_in_progress;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            conv_in_progress <= 1'b0;
        else if (valid)
            conv_in_progress <= 1'b0;
        else if (bbox_calc_done)
            conv_in_progress <= 1'b1;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            conv_counter <= 3'b000;
        else if (valid)
            conv_counter <= 3'b000;
        else if (conv_in_progress)
            conv_counter <= conv_counter + 1;
    assign valid = conv_counter[2];

    /////////////////////////////////////////////
    // extract x & y coords from the triangle //
    // after updating the current bbox with  //
    // one vertex, we shift triangle to     //
    // access the next vertex              //
    ////////////////////////////////////////
    logic next_vertex;
    wire [15:0] vertex_x, vertex_y;
    reg [143:0] triangle_ff;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            triangle_ff <= '0;
        else if (en)
            triangle_ff <= triangle;
        else if (next_vertex)
            triangle_ff <= triangle_ff << 48;
    assign vertex_x = triangle_ff[143:128];
    assign vertex_y = triangle_ff[127:112];

    //////////////////////////////////////////////////////////////////////
    // pseudo-code for bbox calculations:                              //
    //                                                                //
    // bbox_x_max, bbox_y_max = 0                                    //
    // bbox_x_min, bbox_y_min = 255                                 //
    // for i in range(3):                                          //
    //     bbox_x_min = max(0,   min(bbox_x_min, vertex[i].x))    //
    //     bbox_y_min = max(0,   min(bbox_y_min, vertex[i].y))   //
    //     bbox_x_max = min(255, max(bbox_x_max, vertex[i].x))  //
    //     bbox_y_max = min(255, max(bbox_x_max, vertex[i].y)) //
    // return bbox_x_max, bbox_y_max, bbox_x_min, bbox_y_min  //
    ///////////////////////////////////////////////////////////
    logic [15:0] bbox_x_max, bbox_x_min, bbox_y_max, bbox_y_min;
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

    // convert floats to int
    fp16_to_int min_x_int(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_x_min),
        .q(bbox_x_min_int)
    );
    fp16_to_int max_x_int(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_x_max),
        .q(bbox_x_max_int)
    );
    fp16_to_int min_y_int(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_y_min),
        .q(bbox_y_min_int)
    );
    fp16_to_int max_y_int(
        .clk(clk),
        .areset(~rst_n),
        .a(bbox_y_max),
        .q(bbox_y_max_int)
    );

    /* State machine I/O
            Inputs:
                prev_state
                en
                bbox_calc_done
            Outputs:
                bbox_x_max
                bbox_x_min
                bbox_y_max
                bbox_y_min
                next_vertex
                inc_vertex_counter
    */

    // state flop
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

    // state transitions
    always_comb begin
       // SM defaults, avoid latches
        bbox_x_max = curr_bbox_x_max;
        bbox_x_min = curr_bbox_x_min;
        bbox_y_max = curr_bbox_y_max;
        bbox_y_min = curr_bbox_y_min;
        next_vertex = 0;
        inc_vertex_counter = 0;
        next_state = state;

        case (state)
            CMP_1: begin// compare vertices with current bbox
                next_state = BUF;
                if (prev_state == IDLE) begin
                    bbox_x_max = 16'h0000;
                    bbox_x_min = 16'h5bf8;
                    bbox_y_max = 16'h0000;
                    bbox_y_min = 16'h5bf8;
                end
            end

            BUF:   // 1 cycle buffer between comparisons
                if (bbox_calc_done)
                    next_state = IDLE;
                else if (prev_state == CMP_1)
                    next_state = CMP_2;
                else if (prev_state == CMP_2) begin
                    next_state = CMP_1;
                    next_vertex = 1;
                end

            CMP_2: begin // compare CMP_1 with screen borders
                inc_vertex_counter = 1;
                next_state = BUF;
            end

            default: // IDLE state
                if (en)
                    next_state = CMP_1;

        endcase
    end

endmodule

`default_nettype wire