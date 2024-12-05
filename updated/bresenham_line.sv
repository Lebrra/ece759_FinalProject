module bresenham_line (
    input logic signed [15:0] x0, y0,          // Starting point
    input logic signed [15:0] x1, y1,          // Ending point
    output logic signed [15:0] x_out, y_out,   // Output pixel coordinates
    output logic valid                         // Valid pixel
);
    logic signed [15:0] dx, dy, sx, sy, err, e2;
    
    always_comb begin
        dx = (x1 > x0) ? (x1 - x0) : (x0 - x1);
        dy = (y1 > y0) ? (y1 - y0) : (y0 - y1);
        sx = (x0 < x1) ? 1 : -1;
        sy = (y0 < y1) ? 1 : -1;
        err = dx - dy;
        
        x_out = x0;
        y_out = y0;
        valid = 1;

        while (x_out != x1 || y_out != y1) begin
            e2 = 2 * err;
            if (e2 > -dy) begin
                err -= dy;
                x_out += sx;
            end
            if (e2 < dx) begin
                err += dx;
                y_out += sy;
            end
            if (x_out == x1 && y_out == y1) break;
        end
    end
endmodule


