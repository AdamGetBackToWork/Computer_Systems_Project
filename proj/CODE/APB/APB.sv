`include "APB_defines.vh"

module APB (
    PCLK, PRESET, PSEL0, PSEL1, PSEL2, PSEL3, 
    PENABLE, PWRITE, PWDATA, PREADY, PRDATA, 
    i_data, i_data_ready, i_alu_error, i_data_check, 
    i_protocol_sel, o_waiting, o_transfer_done
);

parameter m = 8;

input logic PCLK;
input logic PRESET;
input logic PREADY;
input logic PRDATA;
input logic [m-1:0] i_data;
input logic i_data_ready;
input logic i_alu_error;
input logic [1:0] i_protocol_sel;
input logic i_data_check;

output logic PSEL0;
output logic PSEL1;
output logic PSEL2;
output logic PSEL3;
output logic PENABLE;
output logic PWRITE;
output logic [m-1:0] PWDATA;
output logic o_waiting;
output logic o_transfer_done;

reg [1:0] curr_state;
reg [1:0] next_state;
reg fb_check;
reg fb;

    

always @(curr_state or PRESET or PREADY 
		 or PRDATA or i_data or i_data_ready 
		 or i_alu_error or i_protocol_sel 
		 or i_data_check) 
	begin
    
	PSEL0 = 0;
    PSEL1 = 0;
    PSEL2 = 0;
    PSEL3 = 0;
    PENABLE = 0;
    PWRITE = 0;
    PWDATA = 0;
    o_waiting = 0;
    o_transfer_done = 0;
    fb_check = 1;
	fb = 0;
    //i_data_check = 0;
    //i_protocol_sel = 0;


    case (curr_state)
    
        `INACTIVE: begin
        
            PSEL0 = 0;
            PSEL1 = 0;
            PSEL2 = 0;
            PSEL3 = 0;
            PENABLE = 0;
            PWDATA = 0;
            PWRITE = `WRITE;
            o_transfer_done = fb;
            
            if (i_alu_error & PRESET & PREADY & fb_check) begin
                o_waiting = 1;
                o_transfer_done = 0;
            end
            
            else if (PRESET == 0) begin
                o_waiting = 0;
                o_transfer_done = 0;
            end
            
            else if (PRESET & PREADY & fb_check) o_waiting = 1;
            if (((i_data_ready & ~i_alu_error & o_waiting)|i_data_check) & PREADY) next_state = `SETUP;
            else next_state = `INACTIVE;
        end
        
        `SETUP: begin
        
            PENABLE = 0;
            o_waiting = 0;
            o_transfer_done = 0;
            
            if (i_data_check) begin
                PWRITE = `READ;
                PWDATA = 0;
                fb_check = 1;
            end
            
            else begin
                PWRITE = `WRITE;
                PWDATA = i_data;
                fb_check = 0;
            end
            
            case (i_protocol_sel)
                2'b00: begin
                    PSEL0 = 1;
                    PSEL1 = 0;
                    PSEL2 = 0;
                    PSEL3 = 0;
                end
                
                2'b01: begin
                    PSEL0 = 0;
                    PSEL1 = 1;
                    PSEL2 = 0;
                    PSEL3 = 0;
                end
                
                2'b10: begin
                    PSEL0 = 0;
                    PSEL1 = 0;
                    PSEL2 = 1;
                    PSEL3 = 0;
                end
                
                2'b11: begin
                    PSEL0 = 0;
                    PSEL1 = 0;
                    PSEL2 = 0;
                    PSEL3 = 1;
                end
                
            endcase
            
            next_state = `ACTIVE;
            
        end
        
        `ACTIVE: begin
        
            PENABLE = 1;
            fb = PRDATA;
            if (PREADY & ((i_data_ready & ~i_alu_error)|i_data_check)) next_state = `SETUP;
            else if (PREADY) next_state = `INACTIVE;
            else next_state = `ACTIVE;
        end
        
        default: next_state = `INACTIVE;
        
    endcase
    
end

always @(posedge PCLK) begin

    if (PRESET == 0) begin
        curr_state = `INACTIVE;
    end
    
    else begin
        curr_state = next_state;
    end
    
end

endmodule

