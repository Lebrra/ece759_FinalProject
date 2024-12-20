`default_nettype none

/*
    this module is a bootloader for our triangle memory.
    this module also functions as a transmitter for the 
    resulting frame buffer over UART to a host PC terminal.

    when bootloading, it is our responsibility to hold the rest of the
    system in reset. otherwise, we just pass through rst_n through this module
*/
module bootloader(
    input wire clk, rst_n, RX,
    input wire done_drawing,              // signifies when the hardware has finished drawing to the frame buffer
    input wire bootload_en, transmit_en,  // these signals should be mapped to switches on the board
    input wire [23:0] pixel_rgb,          // pixel_rgb is the data read from the frame buffer
    input wire [23:0] fill_time,          // time it took to fill the frame buffer in clock cycles
    output reg [143:0] bootload_triangle, // the triangle data read from bootloading
    output wire [31:0] bootload_addr,     // the address in triangle memory to store the triangle
    output wire system_rst_n, TX,         // system_rst_n holds the rest of the system in reset while bootloading
    output logic triangle_valid, read_fb, // triangle_valid specifies when we can write to triangle memory
                                          // read_fb signifies we should read from the frame buffer
    output reg [20:0] fb_addr             // the address in the frame buffer to read from
);
    // internal signals
    wire [7:0] rx_byte, tx_byte, fifo_wdata;
    wire rx_rdy, q_full, q_empty, tx_done;
    reg rx_rst_n, q_empty_ff;
    logic count_valid, inc_count, trmt, q_write, q_read, shift_rgb, read_time, shift_time;

    // set the rest of the system in reset during bootload or simply pass rst_n through
    assign system_rst_n = rst_n & ~bootload_en;

    // instantiate common UART between transmitter and bootload
    UART uart (
        .clk(clk),
        .rst_n(rx_rst_n),
        .RX(RX),
        .trmt(trmt),
        .clr_rx_rdy(rx_rdy),
        .tx_data(tx_byte),
        .custom_baud_value(/* unused, baud rate is 115200 */),
        .TX(TX),
        .tx_done(tx_done),
        .rx_rdy(rx_rdy),
        .rx_data(rx_byte)
    );

////////////////////////
// frame buffer TXer //
//////////////////////

    // instantiate a 6-entry FIFO for sending out frame buffer and timing data
    FIFO #(
        .LENGTH(6),    // 6 entries *
        .DATA_WIDTH(8) // 8 bits each
    ) tx_q (           // is enough for 24 bit color and 24 bit time value
        .clk(clk),
        .rst_n(system_rst_n),
        .read(q_read),
        .write(q_write),
        .fifo_wdata(fifo_wdata),
        .fifo_rdata(tx_byte),
        .fifo_full(q_full),
        .fifo_empty(q_empty),
        .read_ptr (/* unused */),
        .write_ptr(/* unused */)
    );

    // flop the q_empty signal so that when we write to an empty queue,
    // we wait until the next cycle to consume the data to send over UART
    // which solves the problem of reading and writing to the queue in the same cycle
    // always_ff @(posedge clk, negedge system_rst_n)
    //     if (~system_rst_n)
    //         q_empty_ff <= 1'b1; // preset the queue as empty
    //     else
    //         q_empty_ff <= q_empty;

    // load the pixel's r, g, or b value into a register
    reg [23:0] pixel_rgb_ff;
    always_ff @(posedge clk, negedge system_rst_n)
        if (~system_rst_n)
            pixel_rgb_ff <= '0;
        else if (shift_rgb)
            pixel_rgb_ff <= pixel_rgb_ff << 8;
        else if (read_fb)
            pixel_rgb_ff <= pixel_rgb;

    // increment frame buffer address on read
    always_ff @(posedge clk, negedge system_rst_n)
        if (~system_rst_n)
            fb_addr <= '0;
        else if (read_fb)
            fb_addr <= fb_addr + 1;
    wire done_reading;
    assign done_reading = fb_addr == 65536; // reached the end of the 256x256 buffer

    // load the time it took to fill the frame buffer into a register
    reg read_time_ff;
    always_ff @(posedge clk)
        read_time_ff <= read_time;
    reg [23:0] time_ff;
    always_ff @(posedge clk, negedge system_rst_n)
        if (~system_rst_n)
            time_ff <= '0;
        else if (shift_time)
            time_ff <= time_ff << 8;
        else if (read_time & ~read_time_ff) // posedge of read_time
            time_ff <= fill_time;

    // choose which value to load into the fifo
    assign fifo_wdata = read_time ? time_ff[23:16] : pixel_rgb_ff[23:16];

    // 2 bit counter for the state machine, counts to 3, one for each RGB value, or each byte in the timing data
    reg [1:0] tx_count;
    wire tx_count_3;
    always_ff @(posedge clk, negedge system_rst_n)
        if (~system_rst_n)
            tx_count <= 2'b00;
        else if (tx_done | q_write)
            tx_count <= tx_count + 1;
        else if (tx_count_3)
            tx_count <= 2'b00;
    assign tx_count_3 = &tx_count;

    /*  TX State machine I/O
            Inputs:
                done_drawing
                transmit_en
                tx_count_3
                tx_count
                fb_done
            Outputs:
                trmt
                read_time
                shift_time
                read_fb
                shift_rgb
                q_write
                q_read
    */

    // TX state flop
    typedef enum logic [1:0] {IDLE_TX, READ_TIMING, READ_RGB, TRANSMIT} tx_state_t;
    tx_state_t tx_state, tx_next_state;
    always_ff @(posedge clk, negedge system_rst_n)
        if (~system_rst_n)
            tx_state <= IDLE_TX;
        else
            tx_state <= tx_next_state;

    // TX state transitions
    always_comb begin
        // SM defaults, avoid latches
        tx_next_state = tx_state;
        trmt = 1'b0;
        read_time = 1'b0;
        shift_time = 1'b0;
        read_fb = 1'b0;
        shift_rgb = 1'b0;
        q_write = 1'b0;
        q_read = 1'b0;

        case (tx_state)
            default: // IDLE_TX
                if (done_drawing & transmit_en & ~done_reading) begin
                    read_time = 1'b1;
                    tx_next_state = READ_TIMING;
                end

            READ_TIMING:
                if (~tx_count_3) begin
                    q_write = 1'b1;
                    read_time = 1'b1;
                    shift_time = 1'b1;
                end else begin
                    trmt = 1'b1;
                    q_read = 1'b1;
                    tx_next_state = TRANSMIT;
                end

            READ_RGB:
                if (~tx_count_3) begin
                    q_write = 1'b1;
                    shift_rgb = 1'b1;
                end else begin
                    trmt = 1'b1;
                    q_read = 1'b1;
                    tx_next_state = TRANSMIT;
                end

            TRANSMIT:
                if (~tx_count_3) begin
                    trmt = tx_done & ~tx_count[1];
                    q_read = tx_done & ~tx_count[1];
                end else if (~done_reading) begin
                    read_fb = 1'b1;
                    tx_next_state = READ_RGB;
                end else if (done_reading)
                    tx_next_state = IDLE_TX;
        endcase
    end

////////////////////
// RX bootloader //
//////////////////

    // create an internal active low reset signal that gets
    // set upon the positive edge of bootload_en, specifically
    // for the RX side, so that if we ever enable
    // bootloading, this module gets reset ONCE, but not
    // held in reset like the rest of the system is.
    reg prev_bootload_en;
    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            prev_bootload_en <= 1'b0;
        else
            prev_bootload_en <= bootload_en;

    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
            rx_rst_n <= 1'b1;   // disabling internal reset prevents the bootloader from resetting on a soft reset
        else if (bootload_en & ~prev_bootload_en) // posedge of bootload_en
            rx_rst_n <= 1'b0;
        else
            rx_rst_n <= 1'b1;

    // UART frame counter, increments each time we receive a byte over UART.
    // count up to eighteen frames, as each triangle has 144 bits (18 bytes).
    reg [4:0] frame_count;
    wire three_frames, eighteen_frames;
    always_ff @(posedge clk, negedge rx_rst_n)
        if (~rx_rst_n)
            frame_count <= '0;
        else if (rx_rdy)
            frame_count <= frame_count + 1;
        else if (eighteen_frames)
            frame_count <= '0;
        else if (three_frames & count_valid) // only reset here after reading number of triangles
            frame_count <= '0;
    assign three_frames = frame_count == 3;
    assign eighteen_frames = frame_count == 18;

    // shift in each byte from UART to a temporary register,
    // as we may send this value to the word counter or to bootload_triangle
    // only valid after four/eighteen UART frames have transpired.
    reg [143:0] rx_word;
    always_ff @(posedge clk, negedge rx_rst_n)
        if (~rx_rst_n)
            rx_word <= '0;
        else if (rx_rdy)
            rx_word <= (rx_word >> 8) | {rx_byte, 136'd0};

    // choose whether to send out this word to bootload_triangle or the word counter
    reg [23:0] num_triangles;
    always_ff @(posedge clk, negedge rx_rst_n)
        if (~rx_rst_n)
            num_triangles <= '0;
        else if (count_valid)
            num_triangles <= rx_word[143:120];
    always_ff @(posedge clk, negedge rx_rst_n)
        if (~rx_rst_n)
            bootload_triangle <= '0;
        else
            bootload_triangle <= rx_word;

    // counter for the number of triangles to load in
    // maximum of 2**24 triangles, although we should never have that many
    reg [23:0] triangle_count;
    wire count_full;
    always_ff @(posedge clk, negedge rx_rst_n)
        if (~rx_rst_n)
            triangle_count <= '0;
        else
            triangle_count <= triangle_count + inc_count;
    // extra condition makes sure count_full not asserted on rst
    assign count_full = (triangle_count == num_triangles) & |triangle_count;
    assign bootload_addr = triangle_count;

    /*  RX State machine I/O
            Inputs:
                bootload_en
                count_full
                three_frames
                eighteen_frames
            Outputs:
                count_valid
                triangle_valid
                inc_count
    */

    // RX state flop
    typedef enum logic [1:0] {IDLE_RX, GET_CNT, RXING, WRITE} rx_state_t;
    rx_state_t rx_state, rx_next_state;
    always_ff @(posedge clk, negedge rx_rst_n)
        if (~rx_rst_n)
            rx_state <= IDLE_RX;
        else
            rx_state <= rx_next_state;

    // RX state transitions
    always_comb begin
        // SM defaults, avoid latches
        rx_next_state = rx_state;
        count_valid = 1'b0;
        triangle_valid = 1'b0;
        inc_count   = 1'b0;

        case (rx_state)
            default: // IDLE_RX
                if (bootload_en & ~count_full)
                    rx_next_state = GET_CNT;

            GET_CNT:
                if (three_frames) begin
                    rx_next_state = RXING;
                    count_valid = 1'b1;
                end

            RXING:
                if (eighteen_frames)
                    rx_next_state = WRITE;
                else if (count_full)
                    rx_next_state = IDLE_RX;

            WRITE: begin
                rx_next_state = RXING;
                triangle_valid = 1'b1;
                inc_count = 1'b1;
            end
        endcase
    end
endmodule

`default_nettype wire
