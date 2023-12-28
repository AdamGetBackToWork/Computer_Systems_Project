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
