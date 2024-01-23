module absolute (i_arg_B, o_newB, o_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_B;
    output logic [K-1:0] o_newB;
    output logic [3:0] o_status;
    integer a;
    integer x;

    always_comb
    begin
        // Initialize outputs and variables
        o_newB = '0;
        x = 0;
        a = 0;
        o_status = '0;
         
        begin
            if (i_arg_B >= 0) 
                begin
                    o_newB = i_arg_B;
                end 
            else 
                begin
                    o_newB = -i_arg_B;
                end
        end
        
        // Check if all bits in o_newB are ones
        if (o_newB === (1 << M) - 1)
            o_status[2] = 1; // Set status bit 2 to 1 if all bits in o_newB are ones

        // Count the number of '1' bits in o_newB
        for (a = 0; a < M; a++)
        begin
            if (o_newB[a] == 1)
                x = x + 1;
        end

        // Check if the number of '1' bits is even and o_newB is not '0'
        if (x % 2 == 0 && o_newB != 0)
            o_status[1] = 1; // Set status bit 1 to 1 if conditions are met
            
        // Check if the number couldn't be converted properly
        if (i_arg_B < -(2**(M-1)) || i_arg_B >= 2**(M-1)) begin
            o_status[0] = 1; // Set status bit 0 to 1 if the number couldn't be converted properly
        end
    end
endmodule

