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
