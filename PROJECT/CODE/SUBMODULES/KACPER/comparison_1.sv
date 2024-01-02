module comparison_1 (i_arg_A, i_arg_B, o_eqA, o_status);
    parameter M = 8;
    parameter K = 8;
    input logic signed [M-1:0] i_arg_A;
    input logic signed [M-1:0] i_arg_B;
    output logic [K-1:0] o_eqA;
    output logic [3:0] o_status;
    integer a;
    integer x;

    always_comb 
    begin

        o_status = '0;
        o_eqA = '0;
        a = 0;
        x = 0;

        if ((~i_arg_A) >= i_arg_B) begin
            o_eqA = 1;

            if (((i_arg_A >>> (M-1)) == 1) && ((i_arg_B >>> (M-1)) == 1) && ((o_eqA >>> (K-1)) == 0) ||
            ((i_arg_A >>> (M-1)) == 0) && ((i_arg_B >>> (M-1)) == 0) && ((o_eqA >>> (K-1)) == 1))
            begin
                o_status[3] = 1;
            end
        end
    end
endmodule