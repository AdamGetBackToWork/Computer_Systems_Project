module addition_1(i_arg_A, i_arg_B, cache_status, cache_result);
	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	
	/*Wewnętrzny rejestr przechowujący ~B*/
		
	logic [M-1:0] cache_B;
	
	/*Wewnętrzny rejestr do przechowywania wyniku dodawania (większy o 1 bit, aby sprawdzić, czy nastąpiło przepełnienie)*/
	
	logic [M:0] cache;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/*Od razu zapisałem negację argumentu B, bo mi się myliło*/
		
		cache_B = ~(i_arg_B);
        
		/*Jeżeli obie liczby są dodatnie: wykonaj normalne dodawanie*/
		
		if((i_arg_A[M-1] == 0) & (cache_B[M-1] == 0)) begin
			cache = i_arg_A + cache_B;
			if(cache[M-1] == 1) begin
				cache_status = 4'b1001;
				cache_result = 8'bx;
			end else begin
				cache_result = cache[M-1:0];
			end
		end
        	
		/*Jeżeli tylko jedna liczba jest ujemna to odejmujemy je od siebie i sprawdzamy znak*/
        
		if((i_arg_A[M-1] == 0) & (cache_B[M-1] == 1)) begin
			if((i_arg_A[M-2:0]) > cache_B[M-2:0]) begin
				cache_result = {1'b0, (i_arg_A[M-2:0] - cache_B[M-2:0])};
			end else begin
				cache_result = {1'b1, (cache_B[M-2:0] - i_arg_A[M-2:0])};
			end
		end
        	
        /*To samo co powyżej*/
        
		if((i_arg_A[M-1] == 1) & (cache_B[M-1] == 0)) begin
			if((i_arg_A[M-2:0]) > cache_B[M-2:0]) begin
				cache_result = {1'b1, (i_arg_A[M-2:0] - cache_B[M-2:0])};
			end else begin
				cache_result = {1'b0, (cache_B[M-2:0] - i_arg_A[M-2:0])};
			end
		end
        	
		/*Jeżeli obie liczby są ujemne: dodajemy bez znaku i dostawiamy znak*/
        	
		if((i_arg_A[M-1] == 1) & (cache_B[M-1] == 1)) begin
			cache = i_arg_A[M-2:0] + cache_B[M-2:0];
			if(cache[M-1] == 1) begin
				cache_status = 4'b1001;
				cache_result = 8'bx;
			end else begin
				cache_result = {1'b1, cache[M-2:0]};
			end
		end
	end
endmodule

module division_1(i_arg_A, i_arg_B, cache_status, cache_result);
	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/*Jeżeli dzielnik jest równy zero: zwracamy błąd*/
            	
		if(i_arg_B == 8'b0) begin
			cache_status = 4'b1000;
			cache_result = 8'bx;
		end

		/*W przeciwnym przypadku zwracamy wynik*/
		
		else begin
			cache_result = {(i_arg_A[M-1] ^ i_arg_B[M-1]), (i_arg_A[M-2:0] / i_arg_B[M-2:0])};
		end
	end	
endmodule

module right_shift_1(i_arg_A, i_arg_B, cache_status, cache_result);
	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/*Sprawdzamy czy liczba nie stanie się ujemna po negacji
		  Jeśli będzie, to wystawiamy odpowiedni kod błędu na 'o_status' oraz stan nieustalony na 'o_result'*/

		if(i_arg_B[M-1] == 0) begin
			cache_status = 4'b1000;
			cache_result = 8'bx;
		end
		
		/*Jeżeli wszystko jest git - przechodzimy do wykonania operacji*/
		
		else begin
			cache_result = i_arg_A >> ~(i_arg_B);
		end
	end
	
endmodule

module zm_to_u2(i_arg_A, i_arg_B, cache_status, cache_result);
	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/*Jeżeli liczba nie jest ujemna: zwracamy tą liczbę bez zmian*/
        	
		if(i_arg_A[M-1] == 0) begin
			cache_result = i_arg_A;
		end

		/*W przeciwnym przypadku zwracamy to co w algorytmie*/

		else begin
			cache_result = {1'b1, ~(i_arg_A[M-2:0]) + 1'b1};
		end

	end
	
endmodule

module absolute (i_arg_B, cache_result, cache_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_B;
    output logic [K-1:0] cache_result;
    output logic [3:0] cache_status;
    integer a;
    integer x;

    always_comb
    begin
        // Initialize outputs and variables
        cache_result = '0;
        x = 0;
        a = 0;
        cache_status = '0;
         
        begin
            if (i_arg_B >= 0) 
                begin
                    cache_result = i_arg_B;
                end 
            else 
                begin
                    cache_result = -i_arg_B;
                end
        end
        
        // Check if all bits in o_newB are ones
        if (cache_result === (1 << M) - 1)
            cache_status[2] = 1; // Set status bit 2 to 1 if all bits in o_newB are ones

        // Count the number of '1' bits in o_newB
        for (a = 0; a < M; a++)
        begin
            if (cache_result[a] == 1)
                x = x + 1;
        end

        // Check if the number of '1' bits is even and o_newB is not '0'
        if (x % 2 == 0 && cache_result != 0)
            cache_status[1] = 1; // Set status bit 1 to 1 if conditions are met
            
        // Check if the number couldn't be converted properly
        if (i_arg_B < -(2**(M-1)) || i_arg_B >= 2**(M-1)) begin
            cache_status[0] = 1; // Set status bit 0 to 1 if the number couldn't be converted properly
        end
    end
endmodule

module comparison_1 (i_arg_A, i_arg_B, cache_result, cache_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_A;
    input logic signed [M-1:0] i_arg_B;
    output logic [K-1:0] cache_result;
    output logic [3:0] cache_status;
    integer a;
    integer x;

    always_comb 
    begin

        cache_status = '0;
        cache_result = '0;
        a = 0;
        x = 0;

        if ((~i_arg_A) >= i_arg_B) begin
            cache_result = 1;

            if (((i_arg_A >>> (M-1)) == 1) && ((i_arg_B >>> (M-1)) == 1) && ((cache_result >>> (K-1)) == 0) ||
            ((i_arg_A >>> (M-1)) == 0) && ((i_arg_B >>> (M-1)) == 0) && ((cache_result >>> (K-1)) == 1))
            begin
                cache_status[3] = 1;
            end
        end
    end
endmodule

module division (i_arg_A, i_arg_B, cache_result, cache_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_A, i_arg_B;
    output logic [K-1:0] cache_result;
    output logic [3:0] cache_status;
    logic signed [K-1:0] s_divid;
    integer x;
    integer a;

    always_comb
    begin
        // Initialize outputs and variables
        cache_status = '0;
        x = 0;
        a = 0;
        cache_result = '0;

         // If i_arg_B = 0, display an error
        if (i_arg_B !== 0) 
        begin
            s_divid = i_arg_A / i_arg_B;
            // Check if o_div is within the valid range
            if (s_divid <= K-1) 
            begin
                cache_result = s_divid;
            end 
            else
                cache_status[3] = 1; // Set status bit 3 to 1 if o_div is out of range
        end 
        else
            cache_status[0] = 1;

        // Check if all bits in o_div are ones
        if (cache_result === (1 << K) - 1)
            cache_status[2] = 1; // Set status bit 2 to 1 if all bits in o_div are ones

        // Count the number of '1' bits in o_div
        for (a = 0; a < M; a++)
        begin
            if (cache_result[a] == 1)
                x = x + 1;
        end

        // Check if the number of '1' bits is even and o_div is not '0'
        if (x % 2 == 0 && cache_result != 0)
            cache_status[1] = 1; // Set status bit 1 to 1 if conditions are met
        
    end
    
endmodule

module right_shift_2 (i_arg_A, i_arg_B, cache_result, cache_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_A, i_arg_B;
    output logic [K-1:0] cache_result;
    output logic [3:0] cache_status;
    logic [M-1:0] s_s;
    integer x;
    integer a;

    always_comb
    begin
        // Initialize outputs and variables
        cache_result = '0;
        x = 0;
        a = 0;
        cache_status = '0;

        // Check if i_argB is non-negative
        if (i_arg_B >= 0)
        begin
            // Shift i_argA right by i_argB positions
            s_s = ~i_arg_A >> i_arg_B;
            
            // Check if o_newA is within the valid range
            if (s_s <= K-1)
            begin
                cache_result = s_s;
            end
            else
                cache_status[3] = 1; // Set status bit 3 to 1 if o_nawA is out of range
        end
        else
            cache_status[0] = 1; // Set status bit 0 to 1 if i_argB is negative

        // Check if all bits in o_newA are ones
        if (cache_result === (1 << K) - 1)
            cache_status[2] = 1; // Set status bit 2 to 1 if all bits in o_newA are ones

        // Count the number of '1' bits in o_newA
        for (a = 0; a < K; a++)
        begin
            if (cache_result[a] == 1)
                x = x + 1;
        end

        // Check if the number of '1' bits is even and o_newA is not '0'
        if (x % 2 == 0 && cache_result != 0)
            cache_status[1] = 1; // Set status bit 1 to 1 if conditions are met
    end
endmodule

module add_bit(i_arg_A, i_arg_B, cache_status, cache_result);

	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	

	logic [M-1:0] sum;
	logic signed [M-1:0] s_A, s_B;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/* changing the inputs to signed so its easier to perform operations on them */
        s_A = $signed(i_arg_A);
        s_B = $signed(i_arg_B);
        			 	 
        			 	
        /* checking for overflow and going out of bounds */
        			 	
        if ((s_A + s_B) > ((2**(M-1)) - 1)) begin
        	cache_status = 4'b1001;
    		cache_result = 8'bx;
        end 
        else if ((s_A + s_B) < -(2**(M-1))) begin
        	cache_status = 4'b1001;
    		cache_result = 8'bx;
        end else begin
        				
        /* Adding up both input vectors, A and B */
        				
        sum = s_A + s_B;
        				  
        /*	Changing the corresponded to B value bit in sum to 0 
        	keep in mind the bits are 0 indexed, so if B = 0001 then 
        	in "sum" the bit changed will be the 2^1 one. */ 

        sum = (sum & ~(1 << s_B));

        /* Assigning the sum to the temporary result output */
        				
        cache_result = sum;
        end
	end
endmodule

module comparison_2(i_arg_A, i_arg_B, cache_status, cache_result);

	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	
	logic [M-1:0] comp_A, comp_B;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/* if A is smaller than B then the output is NOT 0 */ 
                    	
        if ((i_arg_A[M-1] == 1) && (i_arg_B[M-1] == 0)) 
        begin
                		
        	cache_result = 2'b01; 
                    			
        end else 
                		
        /* if A is bigger than B then the output is 0 */ 
                		
        if (((i_arg_A[M-1] == 0) && (i_arg_B[M-1] == 1)) || (i_arg_A == i_arg_B)) 
        begin
                		
             cache_result = 0; // Output 0 if A >= B
                    			
        end else if ((i_arg_A[M-1] == 0) && (i_arg_B[M-1] == 0)) 
        begin
                		
        	if (i_arg_A < i_arg_B) 
        	begin
                			
        		cache_result = 2'b01; 
                				
        	end else 
        	begin 
                			
            	cache_result = 0;
                				
        	end
                			
        end else if ((i_arg_A[M-1] == 1) && (i_arg_B[M-1] == 1)) 
        begin
            comp_A = i_arg_A;
            comp_B = i_arg_B;
                			
            comp_A[M-1] = 0;
            comp_B[M-1] = 0;
                			
        	if (comp_A > comp_B) 
        	begin
                			
            	cache_result = 1;
                			
        	end else 
        	begin
                			
            	cache_result = 0;
                			
        	end
                		
        end

	end
endmodule

module sub_and_mul(i_arg_A, i_arg_B, cache_status, cache_result);

	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;
	

	logic [M-1:0] cache;
	logic [M-1:0] sum;
	
	logic signed [M-1:0] s_A, s_B;
	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		cache = (i_arg_B << 1);
    					
    					
    	/* changing the inputs to signed so its easier to perform operations on them */
        s_A = $signed(i_arg_A);
        s_B = $signed(cache);
        				
  		/* checking for overflow and going out of bounds */
        if ((s_A - s_B) > ((2**(M-1)) - 1)) 
        begin
        				
        	cache_status = 4'b1001;
    		cache_result = 8'bx;
    						
        end 
        else if ((s_A - s_B) < -(2**(M-1))) 
        begin
        				
        	cache_status = 4'b1001;
    		cache_result = 8'bx;
    						
        end else begin
        				
        /* if the overflow hasnt been detected, simply subtract the numbers and 
        				   assign the value of subtraction to temporary result */
        			
        	sum = s_A - s_B;
        	cache_result = sum;

        end
	end
endmodule

module u2_to_zm(i_arg_A, i_arg_B, cache_status, cache_result);

	parameter M = 8;
	parameter K = 8;
	
	input logic [M-1:0] i_arg_A;
	input logic [M-1:0] i_arg_B;
	output logic [K-1:0] cache_result;
	output logic [3:0] cache_status;

	
	always_comb begin
		
		cache_status = 4'b0;
		cache_result = 8'b0;
		
		/* if the number is negative, we invert all but first bits, then add 1 */
    					
    	if (i_arg_A == 8'b10000000) begin
    					
    		cache_status = 4'b1001;
    		cache_result = {1'b1, ~(i_arg_A[M-2:0]) + 1'b1};
    					
    	end
    	else if(i_arg_A[M-1] == 1) 
    	begin
    				
        	cache_result = {1'b1, ~(i_arg_A[M-2:0]) + 1'b1};
		
    	end 
    				
    	/* if the number is positive, then the output is the number itself*/
    				
    	else begin
    				
        	cache_result = i_arg_A;
        				
    	end
	end
endmodule

/*Poniżej widnieje zabytek starych czasów; na razie go nie usuwam*/

//`include "./../SUBMODULES/MACIEK/addition.sv"
//`include "./../SUBMODULES/MACIEK/division.sv"
//`include "./../SUBMODULES/MACIEK/right_shift.sv"
//`include "./../SUBMODULES/MACIEK/zm_to_u2.sv"

//`include "./../SUBMODULES/ADAM/sub_and_mul.sv"
//`include "./../SUBMODULES/ADAM/comparison_2.sv"
//`include "./../SUBMODULES/ADAM/add_bit.sv"
//`include "./../SUBMODULES/ADAM/u2_to_zm.sv"

//`include "./../SUBMODULES/KACPER/absolute.sv"
//`include "./../SUBMODULES/KACPER/comparison_1.sv"
//`include "./../SUBMODULES/KACPER/division.sv"
//`include "./../SUBMODULES/KACPER/right_shift_2.sv"

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

	absolute #(.M(M), .K(K)) mod_absolute(.i_arg_B(i_arg_B), .cache_status(K_absolute_status), .cache_result(K_absolute_result));
	comparison_1 #(.M(M), .K(K)) mod_comparison_1(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(K_comparison_1_status), .cache_result(K_comparison_1_result));	
	division #(.M(M), .K(K)) mod_division(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(K_division_status), .cache_result(K_division_result));	
	right_shift_2 #(.M(M), .K(K)) mod_right_shift_2(.i_arg_A(i_arg_A), .i_arg_B(i_arg_B), .cache_status(K_right_shift_2_status), .cache_result(K_right_shift_2_result));
	
	
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

