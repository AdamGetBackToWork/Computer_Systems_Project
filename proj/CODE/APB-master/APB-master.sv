module APB_master (PCLK, PRESET, PSEL0, PSEL1, PSEL2, PSEL3, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, i_data, i_data_ready, i_alu_error, i_protocol_sel, o_waiting, o_transfer_done);

parameter m = 8;
parameter IDLE=0, SETUP=1, ACCESS=2;

input logic PCLK;
input logic PRESET;
input logic PREADY;
input logic PRDATA;
input logic [m-1:0] i_data;
input logic i_data_ready;
input logic i_alu_error;
input logic [1:0] i_protocol_sel;

output logic PSEL0;
output logic PSEL1;
output logic PSEL2;
output logic PSEL3;
output logic PENABLE;
output logic PWRITE;
output logic [m-1:0] PWDATA;
output logic o_waiting;
output logic o_transfer_done;

reg [1:0] state;

always @(state) begin
    case (state)
        IDLE: begin
            PENABLE <= 0;
            PWDATA <= 0;
            PSEL0 <= 0;
            PSEL1 <= 0;
            PSEL2 <= 0;
            PSEL3 <= 0;
        end

        SETUP: begin
            case (i_protocol_sel)
            
                2'b00: begin
                    PSEL0 <= 1;
                    PSEL1 <= 0;
                    PSEL2 <= 0;
                    PSEL3 <= 0;
                end
                
                2'b01: begin
                    PSEL0 <= 0;
                    PSEL1 <= 1;
                    PSEL2 <= 0;
                    PSEL3 <= 0;
                end
                
                2'b10: begin
                    PSEL0 <= 0;
                    PSEL1 <= 0;
                    PSEL2 <= 1;
                    PSEL3 <= 0;
                end
                
                2'b11: begin
                    PSEL0 <= 0;
                    PSEL1 <= 0;
                    PSEL2 <= 0;
                    PSEL3 <= 1;
                end
            endcase
            PENABLE <= 0;
        end

        ACCESS: begin
            PENABLE <= 1;
            PWDATA <= i_data;
            PWRITE <= 1;
        end

    endcase
end


always @(posedge PCLK) begin

    if (PRESET == 0) begin
        state = IDLE;
        o_waiting <= 0;
        o_transfer_done <= 0;
    end

    else begin

        case (state)

            IDLE: begin
            
                if (i_data_ready == 1 & i_alu_error != 1) begin
                    state = SETUP;
                end
                
            end

            SETUP: begin
            
                state = ACCESS;
                
            end


            ACCESS: begin
            
                if (PREADY == 1 & i_data_ready == 1 & i_alu_error != 1) begin
                    state = SETUP;
                end

                else if (PREADY == 1 & (i_data_ready == 0 | i_alu_error == 1)) begin
                    state = IDLE;
                end
                
            end

            default:

            state = IDLE;

        endcase

    end
end

endmodule

