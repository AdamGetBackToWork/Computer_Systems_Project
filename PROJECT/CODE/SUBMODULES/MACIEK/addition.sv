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
