module top (
    input logic clk, reset,
    input logic [15:0] num_coords,  // Number of coordinates
    input logic signed [15:0] triangle[0:5], // 6 triangle vertices (x, y, z)
    input logic signed [15:0] width, height,
    output logic [15:0] pixelX, pixelY, // Output pixel coordinates
    output logic valid                // Pixel validity (inside triangle)
);

    // Perspective projection calculation for 3D -> 2D
    logic signed [15:0] proj_x [0:2], proj_y [0:2];  // Array for projected 2D coordinates
    logic signed [15:0] x [0:2], y [0:2], z [0:2];  // Array to hold 3D coordinates (x, y, z)
    
    // Perspective projection
    always_comb begin
        for (int i = 0; i < num_coords; i++) begin
            x[i] = triangle[3*i];       // x coordinate
            y[i] = triangle[3*i+1];     // y coordinate
            z[i] = triangle[3*i+2];     // z coordinate
            
            // Perspective projection: x' = x / z, y' = y / z
            if (z[i] != 0) begin
                proj_x[i] = x[i] * 256 / z[i]; // Scale to avoid floating point precision
                proj_y[i] = y[i] * 256 / z[i]; // Scale to avoid floating point precision
            end else begin
                proj_x[i] = 0;  // Handle division by zero if z = 0 (this should ideally be avoided)
                proj_y[i] = 0;
            end
        end
    end

    // Triangle vertices for 2D
    logic signed [15:0] triangle_2d[0:5];  // Projected 2D triangle vertices
    always_comb begin
        // Prepare the projected 2D triangle vertices
        triangle_2d[0] = proj_x[0];
        triangle_2d[1] = proj_y[0];
        triangle_2d[2] = proj_x[1];
        triangle_2d[3] = proj_y[1];
        triangle_2d[4] = proj_x[2];
        triangle_2d[5] = proj_y[2];
    end

    // Instantiate the rasterizer for triangle rasterization
    rasterizer rast(
        .triangle(triangle_2d),
        .width(width),
        .height(height),
        .pixelX(pixelX),
        .pixelY(pixelY),
        .valid(valid)
    );

    // Instantiate the Barycentric and InTriangle modules
    logic [15:0] alpha, beta, gamma;
    logic inside_triangle;

    // Barycentric calculation and InTriangle check
    barycentric bary(
        .px(pixelX), .py(pixelY), 
        .x0(triangle_2d[0]), .y0(triangle_2d[1]), 
        .x1(triangle_2d[2]), .y1(triangle_2d[3]), 
        .x2(triangle_2d[4]), .y2(triangle_2d[5]),
        .alpha(alpha), .beta(beta), .gamma(gamma)
    );
    
    inTriangle check_triangle(
        .alpha(alpha),
        .beta(beta),
        .gamma(gamma),
        .valid(inside_triangle)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid <= 0;
        end else if (inside_triangle) begin
            valid <= 1;
        end
    end

endmodule


