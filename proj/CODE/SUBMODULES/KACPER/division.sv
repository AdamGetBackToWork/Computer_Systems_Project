module division (i_arg_A, i_arg_B, o_div, o_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_A, i_arg_B;
    output logic [K-1:0] o_div;
    output logic [3:0] o_status;
    logic signed [K-1:0] s_divid;
    integer x;
    integer a;

    always_comb
    begin
        // Initialize outputs and variables
        o_status = '0;
        x = 0;
        a = 0;
        o_div = '0;

         // If i_arg_B = 0, display an error
        if (i_arg_B !== 0) 
        begin
            s_divid = i_arg_A / i_arg_B;
            // Check if o_div is within the valid range
            if (s_divid <= K-1) 
            begin
                o_div = s_divid;
            end 
            else
                o_status[3] = 1; // Set status bit 3 to 1 if o_div is out of range
        end 
        else
            o_status[0] = 1;

        // Check if all bits in o_div are ones
        if (o_div === (1 << K) - 1)
            o_status[2] = 1; // Set status bit 2 to 1 if all bits in o_div are ones

        // Count the number of '1' bits in o_div
        for (a = 0; a < M; a++)
        begin
            if (o_div[a] == 1)
                x = x + 1;
        end

        // Check if the number of '1' bits is even and o_div is not '0'
        if (x % 2 == 0 && o_div != 0)
            o_status[1] = 1; // Set status bit 1 to 1 if conditions are met
        
    end
    
endmodule
