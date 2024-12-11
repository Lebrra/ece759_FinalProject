//Frame buffer module to represent a 1920x1080 display.

// Frame Buffer Module
// Stores the RGB values for each pixel in a 1920x1080 display.

module frame_buffer (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [20:0] addr, // 1920 * 1080 = 2,073,600 pixels, needs 21 bits
    input wire [23:0] data,   // 8 bits per color channel: R, G, B
    output wire [23:0] pixel_data
);
    // Using Block RAM for frame buffer storage
    reg [23:0] fb_mem [0:2073599]; // 1920*1080 = 2,073,600 pixels

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize frame buffer to black
            integer i;
            for (i = 0; i < 2073600; i = i + 1) begin
                fb_mem[i] <= 24'd0;
            end
        end else if (write_enable) begin
            fb_mem[addr] <= data;
        end
    end

    assign pixel_data = fb_mem[addr];
endmodule
