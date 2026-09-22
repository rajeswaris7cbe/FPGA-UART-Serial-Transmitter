// -------------------------------------------------------------------------
// Project: FPGA UART Serial Transmitter
// Developer: Rajeswari S
// Description: Synthesizable RS-232 Transmitter with parameterized baud rate
// -------------------------------------------------------------------------

module uart_tx #(
    parameter CLKS_PER_BIT = 434 // Example: 50MHz Clock / 115200 Baud
)(
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx_out,
    output reg   tx_busy
);

    // FSM States
    localparam s_IDLE  = 3'b000;
    localparam s_START = 3'b001;
    localparam s_DATA  = 3'b010;
    localparam s_STOP  = 3'b011;

    reg [2:0]  state;
    reg [8:0]  clk_count;
    reg [2:0]  bit_index;
    reg [7:0]  tx_data_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= s_IDLE;
            tx_out      <= 1'b1;
            tx_busy     <= 1'b0;
            clk_count   <= 0;
            bit_index   <= 0;
        end else begin
            case (state)
                s_IDLE: begin
                    tx_out  <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        tx_busy     <= 1'b1;
                        tx_data_reg <= tx_data;
                        state       <= s_START;
                    end
                end
                
                s_START: begin
                    tx_out <= 1'b0; // Start bit is low
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state     <= s_DATA;
                    end
                end
                
                s_DATA: begin
                    tx_out <= tx_data_reg[bit_index];
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state     <= s_STOP;
                        end
                    end
                end
                
                s_STOP: begin
                    tx_out <= 1'b1; // Stop bit is high
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state     <= s_IDLE;
                    end
                end
                
                default: state <= s_IDLE;
            endcase
        end
    end

endmodule
