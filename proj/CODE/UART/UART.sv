`include "UART_def.vh"

module UART (i_clk, i_Tx_DV, i_Tx_b, i_enable, i_select, o_Tx_active, o_Tx_serial, o_data_sent, o_ready, o_data_recieved);

parameter CLKS_PER_BIT = 1;
parameter m = 8;

input  logic i_clk;
input  logic i_Tx_DV;
input  logic [m-1:0] i_Tx_b;
input  logic i_enable;
input  logic i_select;

output logic o_Tx_active;
output logic o_Tx_serial;
output logic o_data_sent;
output logic o_ready;
output logic o_data_recieved;

 // Zmienne rejestrów
reg [2:0] curr_state = 0;
reg [7:0] r_clock_count = 0;
reg [2:0] r_bit_index = 0;
reg [m-1:0] r_Tx_data = 0;
reg r_data_sent   = 0;
reg r_Tx_active   = 0;
   
// Proces opadającego zbocza zegara   
always @(posedge i_clk) begin
    
    case (curr_state)

    `IDLE: begin
        o_Tx_serial <= 1'b1;
        o_ready <= 1'b1;
        o_data_recieved <= 1'b0;
        r_data_sent <= 1'b0;
        r_clock_count <= 0;
        r_bit_index <= 0;
         
        if (i_Tx_DV == 1'b1) begin
            o_ready <= 1'b0;
            o_data_recieved <= 1'b1;
            r_Tx_active <= 1'b1;
            r_Tx_data <= i_Tx_b;
            curr_state <= `START;
        end
        else curr_state <= `IDLE;
    end
     
    `START: begin
        if (&{i_select, i_enable}) begin
            o_Tx_serial <= 1'b0;
            if (r_clock_count < CLKS_PER_BIT - 1) begin
                r_clock_count <= r_clock_count + 1;
                curr_state <= `START;
            end
            else begin
                r_clock_count <= 0;
                curr_state <= `DATA_BITS;
            end
        end
        else curr_state <= `IDLE;
    end

    `DATA_BITS: begin
        if (&{i_select, i_enable}) begin
            o_Tx_serial <= r_Tx_data[r_bit_index];   
            if (r_clock_count < CLKS_PER_BIT - 1) begin
                r_clock_count <= r_clock_count + 1;
                curr_state <= `DATA_BITS;
            end
            else begin
                r_clock_count <= 0;

                if (r_bit_index < 7) begin
                    r_bit_index <= r_bit_index + 1;
                    curr_state <= `DATA_BITS;
                end
                else begin
                    r_bit_index <= 0;
                    curr_state <= `STOP;
                end
            end
        end
        else curr_state <= `STOP;
    end
      
    `STOP: begin
        o_Tx_serial <= 1'b1;

        if (r_clock_count < CLKS_PER_BIT - 1) begin
            r_clock_count <= r_clock_count + 1;
            curr_state <= `STOP;
        end
        else begin
            r_data_sent <= 1'b1;
            r_clock_count <= 0;
            curr_state <= `CLEANUP;
            r_Tx_active <= 1'b0;
        end
      end  
       
    `CLEANUP: begin
        // Ustawienie wyjść w stanie czystości
        o_Tx_serial <= 1'b1;
        o_ready <= 1'b1;
        o_data_recieved <= 1'b0;
        r_data_sent <= 1'b0;
        r_clock_count <= 0;
        r_bit_index <= 0;
        curr_state <= `IDLE;
    end
       
       
    default: curr_state <= `IDLE;
       
    endcase
end
// Przypisanie wyjść
assign o_Tx_active = r_Tx_active;
assign o_data_sent = r_data_sent;
   
endmodule