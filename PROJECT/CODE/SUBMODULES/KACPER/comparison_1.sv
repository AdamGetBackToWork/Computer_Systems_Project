module comparison(i_arg_A, i_arg_B, o_eqA, o_status);
    parameter m = 8;
    input logic signed [m-1:0] i_arg_A;
    input logic signed [m-1:0] i_arg_B;
    output logic [m-1:0] o_eqA;
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

            if (((i_arg_A >>> (m-1)) == 1) && ((i_arg_B >>> (m-1)) == 1) && ((o_eqA >>> (m-1)) == 0) ||
            ((i_arg_A >>> (m-1)) == 0) && ((i_arg_B >>> (m-1)) == 0) && ((o_eqA >>> (m-1)) == 1))
            begin
                o_status[3] = 1;
            end
        end
    end
endmodule