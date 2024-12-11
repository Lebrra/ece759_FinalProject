
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module bootloader_test(

	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// GPIO_0, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);

wire rst_n, system_rst_n, read_fb, triangle_valid, write_fb;
wire [143:0] triangle_mem_read;
wire [143:0] triangle_data;
wire [31:0] triangle_addr;
wire [23:0] fb_output;
wire [23:0] fill_time;
wire [7:0] bootloader_fb_addr;
assign LED[1:0] = SW[1:0];
assign LED[7] = system_rst_n;
assign LED[4] = ~rst_n;

rst_synch rst_synch(
    .clk(FPGA_CLK1_50),
    .RST_n(KEY[0]),
    .pll_locked(1'b1),
    .rst_n(rst_n)
);

reg [143:0] triangle_test;
bootloader bootloader(
	.clk(FPGA_CLK1_50),
    .rst_n(rst_n),
    .done_drawing(system_rst_n),
    .bootload_en(SW[0]),
    .transmit_en(SW[1]),
    .pixel_rgb(triangle_test[143:120]),
    .fill_time(fill_time),
    .bootload_triangle(triangle_data),
    .bootload_addr(triangle_addr),
    .RX(GPIO[5]), .TX(GPIO[3]),
    .system_rst_n(system_rst_n),
    .triangle_valid(triangle_valid),
    .read_fb(read_fb),
    .fb_addr(bootloader_fb_addr)
);

// reg [7:0] fb_addr;

// reg [143:0] triangle_mem [0:63];
// always @(posedge FPGA_CLK1_50)
// 	if (triangle_valid)
// 		triangle_mem[triangle_addr] <= triangle_data;
// assign triangle_mem_read = triangle_mem[bootloader_fb_addr];

// // some sort of basic logic to fill up the frame buffer
// always @(posedge FPGA_CLK1_50, negedge system_rst_n)
//     if (~system_rst_n)
//         fb_addr <= 8'h00;
//     else
//         fb_addr <= fb_addr + 1;
// assign done_drawing = fb_addr[0]; // done drawing when filled up all data

always @(posedge FPGA_CLK1_50)
    if (triangle_valid)
        triangle_test <= triangle_data;
    else if (read_fb)
        triangle_test <= triangle_test << 24;

// timer to track how long calculation takes
assign fill_time = 24'h123456;

// TODO: also need to reduce the size of the frame buffer, it WILL NOT fit into FPGA
// wire [23:0] fb_input;
// assign fb_input = {16'h0000, triangle_mem_read[7:0]};
// assign write_fb = ~done_drawing;
// frame_buffer frame_buffer(
//     .clk(FPGA_CLK1_50),
//     .reset(~system_rst_n),
//     .write_enable(write_fb),
//     .addr(read_fb ? bootloader_fb_addr : fb_addr),
//     .data(fb_input),
//     .pixel_data(fb_output)
// );


endmodule
