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
