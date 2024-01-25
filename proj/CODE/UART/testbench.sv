`timescale 1ns/1ps
module testbench;

parameter m = 8;

logic i_clk;
logic i_Tx_DV;
logic [m-1:0] i_Tx_b;
logic i_enable;
logic i_select;

logic o_Tx_serial;
logic o_Tx_serial_s;
logic o_Tx_active;
logic o_Tx_active_s;
logic o_data_sent;
logic o_data_sent_s;
logic o_ready;
logic o_ready_s;
logic o_data_recieved;
logic o_data_recieved_s;

UART #(.m(m)) model (.i_clk(i_clk), .i_Tx_DV(i_Tx_DV), .i_Tx_b(i_Tx_b), .i_enable(i_enable), .i_select(i_select), .o_Tx_active(o_Tx_active), .o_data_sent(o_data_sent), .o_ready(o_ready), .o_data_recieved(o_data_recieved));
UART_synth synth(.i_clk(i_clk), .i_Tx_DV(i_Tx_DV), .i_Tx_b(i_Tx_b), .i_enable(i_enable), .i_select(i_select), .o_Tx_active(o_Tx_active_s), .o_data_sent(o_data_sent_s), .o_ready(o_ready_s), .o_data_recieved(o_data_Recieved_s));

initial i_clk = 1;
always #1 i_clk = ~i_clk;                 

initial begin 
    $dumpfile("signals.vcd");
    $dumpvars(0, testbench);

    i_Tx_DV = 0;
    i_enable = 0;
    i_select = 0;
    i_Tx_b = 8'b11101011;
    #1

    i_Tx_DV = 1;
    i_enable = 1;
    #1

    i_select = 1;
    #10

    i_Tx_DV = 0;
    #4

    i_enable = 0;
    i_select = 0;
    #1

    i_Tx_DV = 1;
    i_enable = 1;
    #1

    i_select = 1;
    #8

    i_enable = 0;
    #1

    i_Tx_DV = 0;
    i_enable = 0;
    i_select = 0;
    #1

    i_Tx_DV = 1;
    i_enable = 1;
    #1

    i_select = 1;
    #10

    $finish;
end

endmodule
