module barycentric (
    input logic signed [15:0] px, py,         // Pixel (x, y) coordinates
    input logic signed [15:0] x0, y0,         // Vertex 0 (x, y)
    input logic signed [15:0] x1, y1,         // Vertex 1 (x, y)
    input logic signed [15:0] x2, y2,         // Vertex 2 (x, y)
    output logic [15:0] alpha, beta, gamma    // Barycentric coordinates
);
    logic signed [15:0] denom, denom_inv;
    
    always_comb begin
        denom = (y1 - y2) * (x0 - x2) + (x2 - x1) * (y0 - y2);  // Determinant of the triangle
        if (denom != 0) begin
            denom_inv = 1 / denom;  // Inverse of denominator

            // Barycentric coordinates
            alpha = ((y1 - y2) * (px - x2) + (x2 - x1) * (py - y2)) * denom_inv;
            beta  = ((y2 - y0) * (px - x2) + (x0 - x2) * (py - y2)) * denom_inv;
            gamma = 1 - alpha - beta;
        end else begin
            alpha = 0;
            beta  = 0;
            gamma = 0;
        end
    end
endmodule


