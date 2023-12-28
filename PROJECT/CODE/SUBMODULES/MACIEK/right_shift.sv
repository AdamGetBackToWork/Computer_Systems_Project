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
