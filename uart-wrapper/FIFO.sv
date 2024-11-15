`default_nettype none

module FIFO
#(parameter int LENGTH = 128, parameter int DATA_WIDTH = 8)
(clk, rst_n, write, fifo_wdata, write_ptr, read, fifo_rdata, read_ptr, fifo_full, fifo_empty);

    localparam int ADDR_WIDTH = $clog2(LENGTH);

    input  wire clk, rst_n;
    input  wire write;                             // pulse on write will write the data from wdata to mem at the write_ptr
    input  wire read;                              // pulse on read will dump the data from the mem at the read_ptr onto rdata
    input  wire [DATA_WIDTH-1:0] fifo_wdata;       // data to write to the fifo
    output wire [DATA_WIDTH-1:0] fifo_rdata;       // data read from the fifo
    output wire fifo_full, fifo_empty;             // status signals if the fifo is full or empty
    output reg [ADDR_WIDTH:0] read_ptr, write_ptr; // these are outputs in case the parent module needs to do some math with them

    always_ff @(negedge clk, negedge rst_n) begin
        if(~rst_n)
            read_ptr <= 0;
        else if(read & ~fifo_empty)
            read_ptr <= read_ptr + 1;
    end

    always_ff @(negedge clk, negedge rst_n) begin
        if(~rst_n)
            write_ptr <= 0;
        else if(write & ~fifo_full)
            write_ptr <= write_ptr + 1;
    end

    // fifo memory, transparent reads
    reg [DATA_WIDTH-1:0] fifo_mem [LENGTH];
    always @(posedge clk, negedge rst_n)
        if (~rst_n)
            fifo_mem <= '0;
        else if (write & ~fifo_full)
            fifo_mem[write_ptr[ADDR_WIDTH-1:0]] <= fifo_wdata;
    assign fifo_rdata = (~fifo_empty & read) ? fifo_mem[read_ptr[ADDR_WIDTH-1:0]] : 'x;

    // the fifo is full if all bits of the r/w pointers match except the MSB
    assign fifo_full  = ~|(read_ptr[ADDR_WIDTH-1:0] ^ write_ptr[ADDR_WIDTH-1:0]) &
                          (read_ptr[ADDR_WIDTH] ^ write_ptr[ADDR_WIDTH]);
    // the fifo is empty if all bits of the r/w pointers match, including the MSB
    assign fifo_empty = ~|(read_ptr[ADDR_WIDTH:0] ^ write_ptr[ADDR_WIDTH:0]);

endmodule

`default_nettype wire
