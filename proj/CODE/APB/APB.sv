// Include file with definitions mentioned in this file
`include "APB_defines.vh"

// Module definition
module APB (
    // MOdule's inputs
    PCLK, PRESET, PSEL0, PSEL1, PSEL2, PSEL3, 
    PENABLE, PWRITE, PWDATA, PREADY, PRDATA, 
    i_data, i_data_ready, i_alu_error, i_data_check, 
    i_protocol_sel, o_waiting, o_transfer_done
);

// Parameter for data width
parameter m = 8;

// Input ports
input logic PCLK;
input logic PRESET;
input logic PREADY;
input logic PRDATA;
input logic [m-1:0] i_data;
input logic i_data_ready;
input logic i_alu_error;
input logic [1:0] i_protocol_sel;
input logic i_data_check;

// Output ports
output logic PSEL0;
output logic PSEL1;
output logic PSEL2;
output logic PSEL3;
output logic PENABLE;
output logic PWRITE;
output logic [m-1:0] PWDATA;
output logic o_waiting;
output logic o_transfer_done;

// Internal registers
reg [1:0] curr_state;
reg [1:0] next_state;
reg fb_check;
reg fb;

// Combinational logic for output assignment
always @(curr_state or PRESET or PREADY 
		 or PRDATA or i_data or i_data_ready 
		 or i_alu_error or i_protocol_sel 
		 or i_data_check) 
	begin
    
    // Default values for outputs
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

    // State machine logic
    case (curr_state)
    
        // Inactive state
        `INACTIVE: begin
        
            // Default output values
            PSEL0 = 0;
            PSEL1 = 0;
            PSEL2 = 0;
            PSEL3 = 0;
            PENABLE = 0;
            PWDATA = 0;
            PWRITE = `WRITE;
            o_transfer_done = fb;
            
            // Check for errors and waiting conditions
            if (i_alu_error & PRESET & PREADY & fb_check) begin
                o_waiting = 1;
                o_transfer_done = 0;
            end
            
            else if (PRESET == 0) begin
                o_waiting = 0;
                o_transfer_done = 0;
            end
            
            else if (PRESET & PREADY & fb_check) o_waiting = 1;
            
            // Determine next state based on conditions
            if (((i_data_ready & ~i_alu_error & o_waiting)|i_data_check) & PREADY) next_state = `SETUP;
            else next_state = `INACTIVE;
        end
        
        // Setup state
        `SETUP: begin
        
            // Default values
            PENABLE = 0;
            o_waiting = 0;
            o_transfer_done = 0;
            
            // Check for read or write operation
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
            
            // Assign appropriate PSEL values based on protocol selection
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
            
            // Move to the next state
            next_state = `ACTIVE;
            
        end
        
        // Active state - ACCESS mom APB
        `ACTIVE: begin
        
            // Enable the peripheral and capture feedback
            PENABLE = 1;
            fb = PRDATA;
            
            // Check for conditions to transition to SETUP or INACTIVE
            if (PREADY & ((i_data_ready & ~i_alu_error)|i_data_check)) next_state = `SETUP;
            else if (PREADY) next_state = `INACTIVE;
            else next_state = `ACTIVE;
        end
        
        // Default case for unknown states
        default: next_state = `INACTIVE;
        
    endcase
    
end

// State transition logic with positive edge clock trigger
always @(posedge PCLK) begin

    // Reset to INACTIVE state on preset
    if (PRESET == 0) begin
        curr_state = `INACTIVE;
    end
    
    // Update current state based on the next state
    else begin
        curr_state = next_state;
    end
    
end
endmodule

