//bresenham for drawing a line b/w 2 points

module bresenham_line_drawer #(
    parameter X_WIDTH = 11, // Width for x-coordinate
    parameter Y_WIDTH = 11  // Width for y-coordinate
)(
    input logic clk,                     // Clock signal
    input logic rst,                     // Reset signal
    input logic start,                   // Start drawing the line
    input logic [X_WIDTH-1:0] x0,        // Start x-coordinate
    input logic [Y_WIDTH-1:0] y0,        // Start y-coordinate
    input logic [X_WIDTH-1:0] x1,        // End x-coordinate
    input logic [Y_WIDTH-1:0] y1,        // End y-coordinate
    output logic [X_WIDTH-1:0] x_out,    // Current x-coordinate on line
    output logic [Y_WIDTH-1:0] y_out,    // Current y-coordinate on line
    output logic done,                   // Line-drawing completion flag
    output logic pixel_valid             // Pixel valid flag for current x_out and y_out
);

    // FSM state definitions
    typedef enum logic [1:0] {
        IDLE,       // Waiting for start signal
        INIT,       // Initial calculations
        DRAW,       // Drawing line
        FINISH      // Line drawing completed
    } state_t;

    state_t state, next_state;

    // Internal variables
    logic signed [X_WIDTH:0] dx, dy, err;
    logic signed [X_WIDTH:0] abs_dx, abs_dy;
    logic signed [X_WIDTH:0] sx, sy;
    logic signed [X_WIDTH-1:0] x, y;
    
    // Next state logic for FSM
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM state transitions
    always_comb begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = INIT;
                else
                    next_state = IDLE;
            end

            INIT: begin
                next_state = DRAW;
            end

            DRAW: begin
                if ((x == x1) && (y == y1))
                    next_state = FINISH;
                else
                    next_state = DRAW;
            end

            FINISH: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // FSM output logic and line-drawing algorithm
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 0;
            y <= 0;
            dx <= 0;
            dy <= 0;
            sx <= 0;
            sy <= 0;
            err <= 0;
            x_out <= 0;
            y_out <= 0;
            pixel_valid <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    pixel_valid <= 0;
                end

                INIT: begin
                    x <= x0;
                    y <= y0;
                    x_out <= x0;
                    y_out <= y0;
                    abs_dx <= (x1 > x0) ? (x1 - x0) : (x0 - x1); // Absolute difference in x
                    abs_dy <= (y1 > y0) ? (y1 - y0) : (y0 - y1); // Absolute difference in y
                    sx <= (x0 < x1) ? 1 : -1;  // Sign of x increment
                    sy <= (y0 < y1) ? 1 : -1;  // Sign of y increment
                    dx <= abs_dx;
                    dy <= abs_dy;
                    err <= abs_dx - abs_dy;  // Initial error value for Bresenham's algorithm
                    pixel_valid <= 1;        // First pixel is valid
                end

                DRAW: begin
                    x_out <= x;
                    y_out <= y;
                    pixel_valid <= 1;

                    // Bresenham's midpoint algorithm
                    logic signed [X_WIDTH:0] e2 = 2 * err;
                    if (e2 > -dy) begin
                        err <= err - dy;
                        x <= x + sx;
                    end
                    if (e2 < dx) begin
                        err <= err + dx;
                        y <= y + sy;
                    end

                    // Check if we reached the endpoint
                    if ((x == x1) && (y == y1)) begin
                        pixel_valid <= 1;
                    end
                end

                FINISH: begin
                    pixel_valid <= 0;
                    done <= 1;
                end

                default: begin
                    done <= 0;
                    pixel_valid <= 0;
                end
            endcase
        end
    end
endmodule

