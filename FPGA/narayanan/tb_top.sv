module tb_top;

    // Declare testbench signals before the procedural blocks
    reg clk;
    reg reset;
    reg [15:0] num_coords;
    reg signed [15:0] triangle [0:149];  // Array for 50 sets of triangle coordinates (150 values)
    reg signed [15:0] width, height;
    wire [15:0] pixelX, pixelY;
    wire valid;

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100MHz clock
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        num_coords = 50;
        width = 256;
        height = 256;

        // Generate 50 random triangles (150 coordinates)
        integer i;
        for (i = 0; i < 50; i = i + 1) begin
            triangle[3*i]   = $random % 256;  // Random x-coordinate for triangle vertex 1
            triangle[3*i+1] = $random % 256;  // Random y-coordinate for triangle vertex 1
            triangle[3*i+2] = ($random % 128) + 1;  // Random z-coordinate (non-zero to avoid division by zero)
        end

        // Apply reset
        reset = 1;
        #10 reset = 0;

        // Run simulation for some time to observe results
        #2000;

        // Finish simulation
        $finish;
    end

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .num_coords(num_coords),
        .triangle(triangle),
        .width(width),
        .height(height),
        .pixelX(pixelX),
        .pixelY(pixelY),
        .valid(valid)
    );

    // Monitor signals for debugging
    initial begin
        $monitor("At time %t, pixelX = %d, pixelY = %d, valid = %d", $time, pixelX, pixelY, valid);
    end

endmodule

