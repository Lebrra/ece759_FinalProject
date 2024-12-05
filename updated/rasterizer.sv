module rasterizer (
    input logic signed [15:0] triangle [0:5],   // 2D triangle vertices
    input logic signed [15:0] width, height,     // Screen dimensions
    output logic [15:0] pixelX, pixelY,          // Pixel coordinates
    output logic valid                           // Valid pixel
);
    logic signed [15:0] minX, maxX, minY, maxY;
    logic signed [15:0] x0, y0, x1, y1, x2, y2;
    
    always_comb begin
        // Define the 2D triangle vertices
        x0 = triangle[0];
        y0 = triangle[1];
        x1 = triangle[2];
        y1 = triangle[3];
        x2 = triangle[4];
        y2 = triangle[5];
        
        // Calculate bounding box of the triangle
        minX = (x0 < x1) ? (x0 < x2 ? x0 : x2) : (x1 < x2 ? x1 : x2);
        maxX = (x0 > x1) ? (x0 > x2 ? x0 : x2) : (x1 > x2 ? x1 : x2);
        minY = (y0 < y1) ? (y0 < y2 ? y0 : y2) : (y1 < y2 ? y1 : y2);
        maxY = (y0 > y1) ? (y0 > y2 ? y0 : y2) : (y1 > y2 ? y1 : y2);

        // Rasterize triangle inside bounding box
        valid = 0;
        for (pixelX = minX; pixelX <= maxX; pixelX++) begin
            for (pixelY = minY; pixelY <= maxY; pixelY++) begin
                // Check if pixel is inside the triangle using barycentric coordinates
                // (The InTriangle module will check this validity)
                valid = 1;
            end
        end
    end
endmodule


