`include "./../SUBMODULES/MACIEK/addition.sv"
`include "./../SUBMODULES/MACIEK/division.sv"
`include "./../SUBMODULES/MACIEK/right_shift.sv"
`include "./../SUBMODULES/MACIEK/zm_to_u2.sv"

`include "./../SUBMODULES/ADAM/sub_and_mul.sv"
`include "./../SUBMODULES/ADAM/comparison_2.sv"
`include "./../SUBMODULES/ADAM/add_bit.sv"
`include "./../SUBMODULES/ADAM/u2_to_zm.sv"

`include "./../SUBMODULES/KACPER/absolute.sv"
`include "./../SUBMODULES/KACPER/comparison_1.sv"
`include "./../SUBMODULES/KACPER/division.sv"
`include "./../SUBMODULES/KACPER/right_shift_2.sv"

module new_alu(i_op, i_arg_A, i_arg_B, i_clk, i_reset, o_result, o_status, o_op_rdy, o_alu_error);

	/*Dodałem od siebie parametr K, ponieważ w instrukcji nie ma zdefiniowanego romzmiaru wyjścia.
	  Rozmiar wyjścia domyślnie przyjąłem jako taki sam jak rozmiar wejścia, czyli 8 bitów*/
	
	parameter N = 4;
	parameter M = 8;
	parameter K = 8;
        
	input logic [N-1:0] i_op;
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	input logic i_clk;
	input logic i_reset;
	
	output logic [K-1:0] o_result;
	output logic [3:0] o_status;
	
	/*Deklaracja portów dla APB*/
	output logic o_op_rdy;
	output logic o_alu_error;
	
	logic [K-1:0] finale_cache_result;
	logic [3:0] finale_cache_status;
	logic cache_op_ready;
	logic cache_alu_error;
	
	/*Szyny do łączenia poszczególnych modułów (M od "Maciek") status + result*/
	
	logic [3:0] M_addition_status, M_division_status, M_right_shift_status, M_zm_to_u2_status;
	logic [M-1:0] M_addition_result, M_division_result, M_right_shift_result, M_zm_to_u2_result;
	
	logic [3:0] A_sub_and_mul_status, A_comparison_2_status, A_add_bit_status, A_u2_to_zm_status;
	logic [M-1:0] A_sub_and_mul_result, A_comparison_2_result, A_add_bit_result, A_u2_to_zm_result;

	logic [3:0] K_absolute_status, K_comparison_1_status, K_division_status, K_right_shift_2_status;
	logic [M-1:0] K_absolute_result, K_comparison_1_result, K_division_result, K_right_shift_2_result;
	
	/*Inicjalizacja poszczególnych modułów*/
	
	addition_1 #(.M(M), .K(K)) mod_addition_1(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(M_addition_status), .cache_result(M_addition_result));
	division_1 #(.M(M), .K(K)) mod_division_1(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(M_division_status), .cache_result(M_division_result));
	right_shift_1 #(.M(M), .K(K)) mod_right_shift_1(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(M_right_shift_status), .cache_result(M_right_shift_result));
	zm_to_u2 #(.M(M), .K(K)) mod_zm_to_u2(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(M_zm_to_u2_status), .cache_result(M_zm_to_u2_result));
	
	sub_and_mul #(.M(M), .K(K)) mod_sub_and_mul(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(A_sub_and_mul_status), .cache_result(A_sub_and_mul_result));
	comparison_2 #(.M(M), .K(K)) mod_comparison_2(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(A_comparison_2_status), .cache_result(A_comparison_2_result));	
	add_bit #(.M(M), .K(K)) mod_add_bit(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(A_add_bit_status), .cache_result(A_add_bit_result));	
	u2_to_zm #(.M(M), .K(K)) mod_u2_to_zm(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(A_u2_to_zm_status), .cache_result(A_u2_to_zm_result));

	absolute #(.M(M), .K(K)) mod_absolute(.i_arg_B(i_arg_B), .o_status(K_absolute_status), .o_newB(K_absolute_result));
	comparison_1 #(.M(M), .K(K)) mod_comparison_1(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .o_status(K_comparison_1_status), .o_eqA(K_comparison_1_result));	
	division #(.M(M), .K(K)) mod_division(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .o_status(K_division_status), .o_div(K_division_result));	
	right_shift_2 #(.M(M), .K(K)) mod_right_shift_2(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .o_status(K_right_shift_2_status), .o_newA(K_right_shift_2_result));
	
	
	/*Część kombinacyjna układu*/
	
	always_comb begin
	
		/*Domyślnie 'o_status' jest wyzerowany. W momencie konkretnego zdarzenia zmieniamy poszczególne bity lub cały wektor.
		  Ponadto wstępna inicjalizacja zapobiega interpretowania poniższych sygnałów jako "latched"
		  W ten sposób Yosys nie wyrzuca błędu, lecz poprawnie syntezuje*/
	
		finale_cache_status = 4'b0;
		finale_cache_result = 8'b0;
		cache_op_ready = 1'b0;
		cache_alu_error = 1'b0;
		
		case(i_op[3:2])
		
			/*i_op[3:2] == 2'b00 odpowiada maćkowym operacjom*/
			2'b00 : begin
				
				case(i_op[1:0])
					
					/*i_op[1:0] == 2'b00 odpowiada operacji przesunięcia bitowego w prawo*/
					2'b00 : begin
						finale_cache_status = M_right_shift_status;
						finale_cache_result = M_right_shift_result;
					end
					
					/*i_op[1:0] == 2'b01 odpowiada operacji dodawania*/
					2'b01 : begin
						finale_cache_status = M_addition_status;
						finale_cache_result = M_addition_result;
					end
					
					/*i_op[1:0] == 2'b10 odpowiada operacji dzielenia*/
					2'b10 : begin
						finale_cache_status = M_division_status;
						finale_cache_result = M_division_result;
					end
					
					/*i_op[1:0] == 2'b11 odpowiada operacji zamiany z kodu ZM na U2*/
					2'b11 : begin
						finale_cache_status = M_zm_to_u2_status;
						finale_cache_result = M_zm_to_u2_result;
					end
				
				endcase
			
			end
		
			2'b01 : begin
				
				case(i_op[1:0])
				
					2'b00 : begin
						finale_cache_status = A_sub_and_mul_status;
						finale_cache_result = A_sub_and_mul_result;
					end
				
					2'b01 : begin
						finale_cache_status = A_comparison_2_status;
						finale_cache_result = A_comparison_2_result;
					end
					
					2'b10 : begin
						finale_cache_status = A_add_bit_status;
						finale_cache_result = A_add_bit_result;
					end
					
					2'b11 : begin
						finale_cache_status = A_u2_to_zm_status;
						finale_cache_result = A_u2_to_zm_result;
					end
				endcase
			end
			
			2'b10 : begin
				
				case(i_op[1:0])
				
					2'b00 : begin
						finale_cache_status = K_absolute_status;
						finale_cache_result = K_absolute_result;
					end
				
					2'b01 : begin
						finale_cache_status = K_comparison_1_status;
						finale_cache_result = K_comparison_1_result;
					end
					
					2'b10 : begin
						finale_cache_status = K_division_status;
						finale_cache_result = K_division_result;
					end
					
					2'b11 : begin
						finale_cache_status = K_right_shift_2_status;
						finale_cache_result = K_right_shift_2_result;
					end
				endcase
			end
			
					
		
		endcase
		
		/*Jeżeli wszystkie cyfry wyniku są zerami - wystawiamy specjalny komunikat
		  ... a jak nie są to nie wystawiamy*/

		if(finale_cache_result == 8'b0) begin
			finale_cache_status[1] = 1'b1;
		end
				
		/*Sprawdzamy parzystość zer w wektorze 'o_result'*/
				
		if(^finale_cache_result == 1'b1) begin
			finale_cache_status[2] = 1'b1;
		end
		
		/*Jeżeli sygnał na i_reset jest ustawiony na niski - nie robimy nic*/
		
		if(i_reset == 1'b0) begin
			finale_cache_status = 4'b0;
			finale_cache_result = 8'b0;
		end
		
		/*Jeżeli w ALU wystąpił błąd, musimy odpowiednio ustawić wyjście*/
		if(finale_cache_status[0] == 1) begin
			cache_op_ready = 1'b0;
			cache_alu_error = 1'b1;
		end else begin
			cache_op_ready = 1'b1;
			cache_alu_error = 1'b0;
		end
	
	end
	
	/*Część synchroniczna układu*/
    
    always_ff @(posedge i_clk) begin
    	o_result <= finale_cache_result;
    	o_status <= finale_cache_status;
    	o_op_rdy <= cache_op_ready;
		o_alu_error <= cache_alu_error;
    end

endmodule

