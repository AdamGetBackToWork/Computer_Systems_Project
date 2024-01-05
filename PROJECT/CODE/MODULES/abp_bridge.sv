module abp_bridge(PCLK, PRESET, PADDR, PSELx, PENABLE, PWRITE, PRDATA, PWDATA, PREADY, PRDATA, i_data, i_data_ready, i_alu_error, i_protocol_sel, o_waiting, o_transfer_done)
	
	parameter N = 4;
	parameter M = 8;
	parameter K = 8;
	
	/*Deklaracja portów ze standardu APB*/
	input logic PCLK;
	input logic PRESET;
	output logic [1:0] PADDR;
	output logic [1:0] PSELx;
	output logic PENABLE;
	output logic PWRITE;
	output logic [M-1:0] PWDATA;
	input logic PREADY;
	input logic PRDATA;
	
	/*Deklaracja portów na potrzeby naszego ALU*/
	input logic [M-1:0] i_data;
	input logic i_data_ready;
	input logic i_alu_error;
	input logic [1:0] i_protocol_sel;
	output logic o_waiting;
	output logic o_transfer_done;
	

endmodule
