`timescale 1ns/1ps

module APBtb;

parameter m = 8;

logic PCLK;
logic PRESET;
logic PREADY;
logic PRDATA;
logic [m-1:0] i_data;
logic i_data_ready;
logic i_alu_error;
logic [1:0] i_protocol_sel;
logic i_data_check;

reg PSEL0;
reg PSEL1;
reg PSEL2;
reg PSEL3;
reg PENABLE;
reg PWRITE;
reg [m-1:0] PWDATA;
reg o_waiting;
reg o_transfer_done;

reg PSEL0_synth;
reg PSEL1_synth;
reg PSEL2_synth;
reg PSEL3_synth;
reg PENABLE_synth;
reg PWRITE_synth;
reg [m-1:0] PWDATA_synth;
reg o_waiting_synth;
reg o_transfer_done_synth;

APB #(.m(m))   
		model    		
				(.PCLK(PCLK), 
				 .PRESET(PRESET),
				 .PREADY(PREADY), 
				 .PRDATA(PRDATA), 
				 .i_data_check(i_data_check), 
				 .i_data(i_data), 
				 .i_data_ready(i_data_ready), 
				 .i_alu_error(i_alu_error), 
				 .i_protocol_sel(i_protocol_sel), 
				 .PSEL0(PSEL0), .PSEL1(PSEL1), 
				 .PSEL2(PSEL2), .PSEL3(PSEL3), 
				 .PENABLE(PENABLE), .PWRITE(PWRITE), 
				 .PWDATA(PWDATA), .o_waiting(o_waiting), 
				 .o_transfer_done(o_transfer_done)
				 );
				 
APBrtl                              
		synth    		
				(.PCLK(PCLK), 
				 .PRESET(PRESET), 
				 .PREADY(PREADY), 
				 .PRDATA(PRDATA), 
				 .i_data_check(i_data_check), 
				 .i_data(i_data), 
				 .i_data_ready(i_data_ready), 
				 .i_alu_error(i_alu_error), 
				 .i_protocol_sel(i_protocol_sel), 
				 .PSEL0(PSEL0_synth), .PSEL1(PSEL1_synth), 
				 .PSEL2(PSEL2_synth), .PSEL3(PSEL3_synth), 
				 .PENABLE(PENABLE_synth), .PWRITE(PWRITE_synth), 
				 .PWDATA(PWDATA_synth), .o_waiting(o_waiting_synth), 
				 .o_transfer_done(o_transfer_done_synth)
				 );


initial PCLK = 0;
always #1 PCLK = ~PCLK;                 

initial begin 

    $dumpfile("signals.vcd"); 
    $dumpvars(0,APBtb); 

    PRESET = 0;
    PREADY = 0;
    PRDATA = 0;
    
    i_data = 8'b11110011;
    i_data_ready = 0;
    i_alu_error = 0;
    i_protocol_sel = 0;
    i_data_check = 0;
    
    #3
    PRESET = 1;
    #1
    PREADY = 1;
    #2
    i_data_ready = 1;
    #4
    PREADY = 0;
    i_data_ready = 0;
    #2
    PREADY = 1;
    #4
    i_data_check = 1;
    PRDATA = 1;
    #4
    PREADY = 0;
    #1
    i_data_check = 0;
    #3
    PREADY = 1;
    #2
    PRDATA = 0;
    #4
    
    $finish;
    
end

endmodule

