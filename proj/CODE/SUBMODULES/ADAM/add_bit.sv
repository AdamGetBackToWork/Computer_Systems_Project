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
