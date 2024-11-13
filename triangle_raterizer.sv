// Triangle Rasterizer Module
// Draws and fills a triangle defined by three vertices with color interpolation.

module triangle_rasterizer (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [10:0] x0, y0,     // Vertex 0 coordinates
    input wire [10:0] x1, y1,     // Vertex 1 coordinates
    input wire [10:0] x2, y2,     // Vertex 2 coordinates
    input wire [23:0] color0,     // Color at Vertex 0 (RGB 8:8:8)
    input wire [23:0] color1,     // Color at Vertex 1 (RGB 8:8:8)
    input wire [23:0] color2,     // Color at Vertex 2 (RGB 8:8:8)
    output wire done,
    output reg [20:0] fb_addr,    // Frame buffer address
    output reg [23:0] fb_data,    // Frame buffer data (pixel color)
    output reg fb_write_enable    // Frame buffer write enable
);

    // Internal control signals
    reg [10:0] scan_y;           // Current scan-line y-coordinate
    reg [10:0] x_left, x_right;  // Interpolated x-coordinates of intersections
    reg [23:0] color_left, color_right; // Interpolated colors at intersections
    reg [10:0] x_pixel;          // Current pixel x-coordinate for filling
    reg [23:0] color_pixel;      // Interpolated color for current pixel
    reg filling;                 // State for filling a scan-line

    // FSM states for rasterizing and filling
    typedef enum logic [2:0] {
        IDLE,
        DRAW_EDGE0,
        DRAW_EDGE1,
        DRAW_EDGE2,
        FILL_SCANLINE,
        COMPLETE
    } state_t;
    state_t state, next_state;

    // Function to compute x-coordinate intersection of edge with scan-line y
    function [10:0] edge_intersection;
        input [10:0] x_start, y_start, x_end, y_end;
        input [10:0] y_scan;
        reg signed [20:0] dx, dy;
        begin
            dx = x_end - x_start;
            dy = y_end - y_start;
            if (dy == 0) begin
                edge_intersection = x_start;
            end else begin
                edge_intersection = x_start + (dx * (y_scan - y_start)) / dy;
            end
        end
    endfunction

    // Function to interpolate color between two points on the line
    function [23:0] color_interpolate;
        input [23:0] color_left, color_right;
        input [10:0] x_left, x_right, x;
        reg [7:0] r, g, b;
        reg signed [20:0] range, dist;
        begin
            range = x_right - x_left;
            dist = x - x_left;
            if (range == 0) begin
                color_interpolate = color_left;
            end else begin
                r = (color_left[23:16] * (range - dist) + color_right[23:16] * dist) / range;
                g = (color_left[15:8] * (range - dist) + color_right[15:8] * dist) / range;
                b = (color_left[7:0] * (range - dist) + color_right[7:0] * dist) / range;
                color_interpolate = {r, g, b};
            end
        end
    endfunction

    // FSM: Transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            scan_y <= 0;
        end else begin
            state <= next_state;
        end
    end

    // FSM: Next-state logic
    always_comb begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = DRAW_EDGE0;
                else
                    next_state = IDLE;
            end
            DRAW_EDGE0: next_state = DRAW_EDGE1;
            DRAW_EDGE1: next_state = DRAW_EDGE2;
            DRAW_EDGE2: next_state = FILL_SCANLINE;
            FILL_SCANLINE: begin
                if (x_pixel < x_right)
                    next_state = FILL_SCANLINE;
                else if (scan_y < max_y)
                    next_state = FILL_SCANLINE;
                else
                    next_state = COMPLETE;
            end
            COMPLETE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // FSM: Output logic for drawing edges and filling pixels
    always_ff @(posedge clk) begin
        case (state)
            DRAW_EDGE0: begin
                // Calculate x_left and color for edge from (x0, y0) to (x1, y1)
                x_left <= edge_intersection(x0, y0, x1, y1, scan_y);
                color_left <= color0;
            end
            DRAW_EDGE1: begin
                // Calculate x_right and color for edge from (x1, y1) to (x2, y2)
                x_right <= edge_intersection(x1, y1, x2, y2, scan_y);
                color_right <= color1;
            end
            DRAW_EDGE2: begin
                // For the last edge from (x2, y2) to (x0, y0)
                if (scan_y >= y0 && scan_y <= y2) begin
                    x_right <= edge_intersection(x2, y2, x0, y0, scan_y);
                    color_right <= color2;
                end
            end
            FILL_SCANLINE: begin
                // Fill pixels on the current scan-line between x_left and x_right
                if (x_pixel <= x_right) begin
                    color_pixel <= color_interpolate(color_left, color_right, x_left, x_right, x_pixel);
                    fb_addr <= (scan_y * 1920) + x_pixel;
                    fb_data <= color_pixel;
                    fb_write_enable <= 1;
                    x_pixel <= x_pixel + 1;
                end else begin
                    // Move to the next scan-line
                    fb_write_enable <= 0;
                    scan_y <= scan_y + 1;
                end
            end
            COMPLETE: begin
                fb_write_enable <= 0;
                done <= 1;
            end
            default: begin
                fb_write_enable <= 0;
                done <= 0;
            end
        endcase
    end

endmodule
