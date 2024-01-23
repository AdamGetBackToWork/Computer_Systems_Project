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
