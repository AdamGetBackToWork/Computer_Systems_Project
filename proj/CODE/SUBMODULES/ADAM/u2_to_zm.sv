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
