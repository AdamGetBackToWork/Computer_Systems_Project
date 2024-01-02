module right_shift_2 (i_arg_A, i_arg_B, o_newA, o_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_A, i_arg_B;
    output logic [K-1:0] o_newA;
    output logic [3:0] o_status;
    logic [M-1:0] s_s;
    integer x;
    integer a;

    always_comb
    begin
        // Initialize outputs and variables
        o_newA = '0;
        x = 0;
        a = 0;
        o_status = '0;

        // Check if i_argB is non-negative
        if (i_arg_B >= 0)
        begin
            // Shift i_argA right by i_argB positions
            s_s = ~i_arg_A >> i_arg_B;
            
            // Check if o_newA is within the valid range
            if (s_s <= K-1)
            begin
                o_newA = s_s;
            end
            else
                o_status[3] = 1; // Set status bit 3 to 1 if o_nawA is out of range
        end
        else
            o_status[0] = 1; // Set status bit 0 to 1 if i_argB is negative

        // Check if all bits in o_newA are ones
        if (o_newA === (1 << K) - 1)
            o_status[2] = 1; // Set status bit 2 to 1 if all bits in o_newA are ones

        // Count the number of '1' bits in o_newA
        for (a = 0; a < K; a++)
        begin
            if (o_newA[a] == 1)
                x = x + 1;
        end

        // Check if the number of '1' bits is even and o_newA is not '0'
        if (x % 2 == 0 && o_newA != 0)
            o_status[1] = 1; // Set status bit 1 to 1 if conditions are met
    end
endmodule


