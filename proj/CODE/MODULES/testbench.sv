`timescale 1ps/1ps
`include "./new_alu.sv"

/*Moduł służący do testowania funkcjonalności 'new_alu.sv'*/

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
        
        /*Operacje ALU Maćka*/
   
        /*1.) Testowanie operacji Y = (A >> ~B)*/
        
        s_op = 4'b0000;
        s_reset = 1'b1;

        /*Przesunięcie o 1 bit w prawo*/
        s_clk = 0;
        s_arg_A = 8'b11001100;
        s_arg_B = 8'b11111110;
        #1
        s_clk = 1;
        #1
        
        /*2.) Testowanie operacji Y = A + ~B*/
        
        s_op = 4'b0001;
        
        /*Y = 2 + 3 (POPRAWNIE)*/
        s_clk = 0;
        s_arg_A = 8'b00000010;
        s_arg_B = 8'b11111100;
        #1
        s_clk = 1;
        #1
		
		/*3.) Testowanie operacji Y = A / B*/
		
		s_op = 4'b0010;
        
        /*Y = 13 / 3*/
        s_clk = 0;
        s_arg_A = 8'b00001101;
        s_arg_B = 8'b00000011;
        #1
        s_clk = 1;
        #1
        
        /*4.) Testowanie operacji ZM(A) => U2(A)*/
        
        s_op = 4'b0011;

        /*Zamiana wartości -10 na U2*/
        s_clk = 0;
        s_arg_A = 8'b10001010;
        #1
        s_clk = 1;
        #1
        
        
        /*Operacje ALU Adama*/
        
        /*5.) Testowanie operacji Y = A-2*B*/
        
        s_op = 4'b0100;
        
        s_clk = 0;
        s_arg_A = 8'b00000011; // =3
        s_arg_B = 8'b00000001; // =1   output = 1 Check
        #1
        s_clk = 1;
        #1
        
        /*6.) Testowanie operacji Y = A < B*/
        
        s_op = 4'b0101;
        
        s_clk = 0;
        s_arg_A = 8'b00000110; // = 6
        s_arg_B = 8'b00000011; // = 3  output = 0 check
        #1
        s_clk = 1;
        #1
        
        /*7.) Testowanie operacji Y = (A+B)[B]*/
        
        s_op = 4'b0110;
        
        s_clk = 0;
        s_arg_A = 8'b00000011;
        s_arg_B = 8'b00000010; // check
        #1
        s_clk = 1;
        #1

        /*8.) Testowanie operacji U2(A) => ZM(A)*/
        
        s_op = 4'b0111;
        
        s_clk = 0;
        s_arg_A = 8'b11111001;
        #1
        s_clk = 1;
        #1
        
        
        /*Operacje ALU Kacpra*/
        
        /*9.) Testowanie operacji Y = ~A >> B*/
        
        s_op = 4'b1000;
        
        s_clk = 0;
        s_arg_A = 8'b11111100;
        s_arg_B = 8'b00001100;
        #1
        s_clk = 1;
        #1
        
        /*10.) Testowanie operacji Y = ~A >= B*/
        
        s_op = 4'b1001;
        
        s_clk = 0;
        s_arg_A = 8'b11111100;
        s_arg_B = 8'b00000001;
        #1
        s_clk = 1;
        #1
        
        /*11.) Testowanie operacji Y = ~A / B*/
        
        s_op = 4'b1010;
        
        s_clk = 0;
        s_arg_A = 8'b11111000;
        s_arg_B = 8'b00000001;
        #1
        s_clk = 1;
        #1
        
        /*12.) Testowanie operacji Y = ~ABS(B)*/
        
        s_op = 4'b1011;
        
        s_clk = 0;
        s_arg_B = 8'b01010101;
        #1
        s_clk = 1;
        #1

        $finish;
	end

endmodule
