`default_nettype none

// borrowing obfuscated version from ece 551
// deobfuscation done by us (ece 759)

module UART
#(parameter int CUSTOM_BAUD = 0)
(clk,rst_n,custom_baud_value,RX,TX,rx_rdy,clr_rx_rdy,rx_data,trmt,tx_data,tx_done);

input  wire        clk, rst_n;
input  wire        RX, trmt, clr_rx_rdy;
input  wire [ 7:0] tx_data;
input  wire [12:0] custom_baud_value;
output wire        TX;
output reg         tx_done, rx_rdy;
output wire [ 7:0] rx_data;

// Custom Baud Rates
//   This module allows the setting of a custom baud rate. The value in this register will
//   be used to reload both the tx_baud_cnt and rx_baud_cnt registers when necessary.
// Common Baud Rates are shown below (for a 50MHz clk)
// | Desired Baud Rate | Baud Register Value (Hex) | (Decimal) |
// |-------------------|---------------------------|-----------|
// | 9600              | 0x1458                    | 5208      |
// | 19200             | 0x0A2C                    | 2604      |
// | 38400             | 0x0516                    | 1302      |
// | 57600             | 0x0364                    | 868       |
// | 115200            | 0x01B2                    | 434       | ** Default
// | 230400            | 0x00D9                    | 217       |
// | 460800            | 0x006C                    | 108       |
// | 921600            | 0x0036                    | 54        |

// TX Regs and Signals
reg [8:0] tx_shift_reg;
reg [3:0] tx_bit_cnt;
reg [12:0] tx_baud_cnt;
wire tx_shift;
logic tx_load, tx_transmitting;

// RX Regs and Signals
reg [8:0] rx_shift_reg;
reg [3:0] rx_bit_cnt;
reg [12:0] rx_baud_cnt;
reg rx_ff_1, rx_ff_2;
wire rx_shift;
logic rx_load, set_rx_rdy, rx_receiving;

///////////////////////
// Custom Baud Rate
/////////////////////
wire [12:0] baud_reload;
generate
  if (CUSTOM_BAUD) begin : g_custom_baud
    // If you desire to use a custom baud rate, it must be provided by an external
    //   register. Take that register value in through the 'baud_value' port. That port
    //   drives the baud_reload net used by the TX and RX to reload their baud counters.
    assign baud_reload = custom_baud_value;
  end
  else begin : g_default_baud
    // If you are not using a custom baud rate, the baud_reload used by TX and RX to
    //   reload their baud counters is just driven to a fixed baud rate of 115200
    assign baud_reload = 13'h06C8; // this value has been changed to run for a 200MHz clock (multiplied by 4)
  end
endgenerate


////////
// TX
//////

always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    tx_bit_cnt <= 4'b0000;
  else if (tx_load)
    tx_bit_cnt <= 4'b0000;
  else if (tx_shift)
    tx_bit_cnt <= tx_bit_cnt+4'b0001;
end


always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    tx_baud_cnt <= baud_reload;
  else if (tx_load || tx_shift)
    tx_baud_cnt <= baud_reload;
  else if (tx_transmitting)
    tx_baud_cnt <= tx_baud_cnt-13'd1;
end

assign tx_shift = ~|tx_baud_cnt;


// bits from the tx_shift_reg are shifted out of the LSB
always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    tx_shift_reg <= 9'h1FF;
  else if (tx_load)
    tx_shift_reg <= {tx_data,1'b0};
  else if (tx_shift)
    tx_shift_reg <= {1'b1,tx_shift_reg[8:1]};
end

assign TX = tx_shift_reg[0];


always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    tx_done <= 1'b0;
  else if (trmt)
    tx_done <= 1'b0;
  else if (tx_bit_cnt == 4'b1010)
    tx_done <= 1'b1;
end


// TX State Machine
typedef enum reg {TX_IDLE, TX_STATE} tx_state_t;
tx_state_t tx_state,tx_next_state;

always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    tx_state <= TX_IDLE;
  else
    tx_state <= tx_next_state;
end

always_comb begin
  tx_load = 0;
  tx_transmitting = 0;
  tx_next_state = TX_IDLE;

  case (tx_state)
    TX_IDLE : begin
      if (trmt) begin
        tx_next_state = TX_STATE;
        tx_load = 1;
      end
      else
        tx_next_state = TX_IDLE;
    end
    default : begin
      if (tx_bit_cnt==4'b1010)
        tx_next_state = TX_IDLE;
      else
        tx_next_state = TX_STATE;

      tx_transmitting = 1;
    end
  endcase
end




////////
// RX
///////

always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    rx_bit_cnt <= 4'b0000;
  else if (rx_load)
    rx_bit_cnt <= 4'b0000;
  else if (rx_shift)
    rx_bit_cnt <= rx_bit_cnt+4'b0001;
end


always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    rx_baud_cnt <= {1'b0,baud_reload[12:1]}; // bit-shifted by 1 bit for half-baud
  else if (rx_load)
    rx_baud_cnt <= {1'b0,baud_reload[12:1]}; // bit-shifted by 1 bit for half-baud
  else if (rx_shift)
    rx_baud_cnt <= baud_reload;
  else if (rx_receiving)
    rx_baud_cnt <= rx_baud_cnt-13'd1;
end

assign rx_shift = ~|rx_baud_cnt;


always_ff @(posedge clk) begin
  if (rx_shift)
    rx_shift_reg <= {rx_ff_2,rx_shift_reg[8:1]};
end

assign rx_data = rx_shift_reg[7:0];


always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    rx_rdy <= 1'b0;
  else if (rx_load || clr_rx_rdy)
    rx_rdy <= 1'b0;
  else if (set_rx_rdy)
    rx_rdy <= 1'b1;
end


always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    begin
      rx_ff_1 <= 1'b1;
      rx_ff_2 <= 1'b1;
    end
  else
    begin
      rx_ff_1 <= RX;
      rx_ff_2 <= rx_ff_1;
    end
end


// RX State Machine
typedef enum reg {RX_IDLE, RX_STATE} rx_state_t;
rx_state_t rx_state, rx_next_state;

always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n)
    rx_state <= RX_IDLE;
  else
    rx_state <= rx_next_state;
end

always_comb
  begin
    rx_load = 0;
    set_rx_rdy = 0;
    rx_receiving = 0;
    rx_next_state = RX_IDLE;

    case (rx_state)
      RX_IDLE : begin
        if (!rx_ff_2)
          begin
            rx_next_state = RX_STATE;
            rx_load = 1;
          end
        else rx_next_state = RX_IDLE;
      end
      default : begin
        if (rx_bit_cnt==4'b1010)
          begin
            set_rx_rdy = 1;
            rx_next_state = RX_IDLE;
          end
        else
          rx_next_state = RX_STATE;
        rx_receiving = 1;
      end
    endcase
  end


endmodule

`default_nettype wire
