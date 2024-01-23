`timescale 1ps/1ps
`include "./../CODE/MODULES/new_alu.sv"

/*Moduł służący do testowania funkcjonalności 'alu.sv'*/

module testbench;

    parameter s_N = 4;
    parameter s_M = 8;
    parameter s_K = 8;
    
    reg [s_N-1:0] s_op;
    reg [s_M-1:0] s_arg_A;
    reg [s_M-1:0] s_arg_B;
    reg s_clk;
    reg s_reset;
    
    wire [s_K-1:0] simulation_s_result;
    wire [3:0] simulation_s_status;

    wire [s_K-1:0] synthesis_s_result;
    wire [3:0] synthesis_s_status;
    
    new_alu #(.N(s_N), .M(s_M), .K(s_K))
    new_alu_model_simulation (.i_arg_A(s_arg_A), .i_arg_B(s_arg_B), .i_op(s_op), .i_clk(s_clk), .i_reset(s_reset), .o_result(simulation_s_result), .o_status(simulation_s_status));
    

    initial begin
        $dumpfile("signals.vcd");
        $dumpvars(0, testbench);
                
        s_op = 2'b00;
        s_reset = 1'b1;
        
        /*1.) Testowanie operacji Y = (A >> ~B)*/

        /*Przesunięcie o 1 bit w prawo*/
        s_clk = 0;
        s_arg_A = 8'b11001100;
        s_arg_B = 8'b11111110;
        #1
        s_clk = 1;
        #1

        $finish
	end

endmodule
