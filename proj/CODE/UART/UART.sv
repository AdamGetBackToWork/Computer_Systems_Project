`include "UART_def.vh"

module UART (i_clk, i_Tx_DV, i_Tx_b, i_enable, i_select, o_Tx_active, o_Tx_serial, o_data_sent, o_ready, o_data_recieved);

parameter CLKS_PER_BIT = 1;
parameter m = 8;

input  logic i_clk;
input  logic i_Tx_DV;
input  logic [m-1:0] i_Tx_b;
input  logic i_enable;
input  logic i_select;
output logic o_Tx_active;
output logic o_Tx_serial;
output logic o_data_sent;
output logic o_ready;
output logic o_data_recieved;

/*Zmienne wewnętrznych rejestrów modułu*/
reg [2:0] curr_state = 0;
reg [7:0] r_clock_count = 0;
reg [2:0] r_bit_index = 0;
reg [m-1:0] r_Tx_data = 0;
   
/*Układ synchroniczny aktywowany wzrastającym zboczem zegarowym*/
always @(posedge i_clk) begin

    /*Sprawdzamy obecny stan automatu*/
    case (curr_state)
    
    /*Stan bezczynności*/
    `IDLE: begin
    
        /*Ustawienie domyślnych wartości wyjść*/
        o_Tx_serial <= 1'b1;
        o_ready <= 1'b1;
        o_data_recieved <= 1'b0;
        o_data_sent <= 1'b0;
        r_clock_count <= 0;
        r_bit_index <= 0;
         
        /*Sprawdź czy należy rozpocząć transmisje danych*/
        if (i_Tx_DV == 1'b1) begin
        
            /*Uaktualnij sygnały wyjściowe*/
            o_ready <= 1'b0;
            o_data_recieved <= 1'b1;
            o_Tx_active <= 1'b1;
            r_Tx_data <= i_Tx_b;
            
            /*Przejdź do następnego stanu automatu*/
            curr_state <= `START;
        end
        
        /*W przeciwnym wypadku - pozostań w tym samym stanie*/
        else begin
        	curr_state <= `IDLE;
       	end
    end
     
    /*Stan rozpoczęcia przesyłu danych*/
    `START: begin
    
        /*Sprawdź warunki konieczne do kontynuowania transmisji*/
        if (&{i_select, i_enable}) begin
        
            /*Rozpoczęcie transmisji danych*/
            o_Tx_serial <= 1'b0;
            
            /*Zmiana stanu automatu w zależności od momentu cyklu*/
            if (r_clock_count < CLKS_PER_BIT - 1) begin
                r_clock_count <= r_clock_count + 1;
                curr_state <= `START;
            end
            else begin
                r_clock_count <= 0;
                curr_state <= `DATA_BITS;
            end
        end
        
        /*Jeżeli warunki nie są spełnione - następuje powrót do stanu bezczynności*/
        else begin
        	curr_state <= `IDLE;
        end
    end

    /*Stan przesyłania danych*/
    `DATA_BITS: begin
    
        /*Sprawdź warunki konieczne do kontynuowania transmisji*/
        if (&{i_select, i_enable}) begin
        
            /*Wystawienie następnego bitu na wyjście*/
            o_Tx_serial <= r_Tx_data[r_bit_index];
            
            /*Zmiana stanu automatu w zależności od momentu cyklu*/
            if (r_clock_count < CLKS_PER_BIT - 1) begin
                r_clock_count <= r_clock_count + 1;
                curr_state <= `DATA_BITS;
            end
            else begin
                /*Reset cyklu*/
                r_clock_count <= 0;

                if (r_bit_index < 7) begin
                    r_bit_index <= r_bit_index + 1;
                    curr_state <= `DATA_BITS;
                end
                else begin
                    r_bit_index <= 0;
                    curr_state <= `STOP;
                end
            end
        end
        
        /*Jeżeli warunki nie są spełnione - następuje powrót do stanu bezczynności*/
        else begin
        	curr_state <= `STOP;
       	end
    end
      
    /*Stan zatrzymania transmisji*/
    `STOP: begin
    
        /*Zakończenie transmisji danych*/
        o_Tx_serial <= 1'b1;
        
        /*Zmiana stanu automatu w zależności od momentu cyklu*/
        if (r_clock_count < CLKS_PER_BIT - 1) begin
            r_clock_count <= r_clock_count + 1;
            curr_state <= `STOP;
        end
        else begin
            o_data_sent <= 1'b1;
            r_clock_count <= 0;
            curr_state <= `CLEAN;
            o_Tx_active <= 1'b0;
        end
    end  
       
    /*Stan "Sprzątania" - powrót wszystkich wyjśc i rejestrów do wartości domyślnych + przejście do stanu bezczynności*/
    `CLEAN: begin
        o_Tx_serial <= 1'b1;
        o_ready <= 1'b1;
        o_data_recieved <= 1'b0;
        o_data_sent <= 1'b0;
        r_clock_count <= 0;
        r_bit_index <= 0;
        curr_state <= `IDLE;
    end
       
    /*Stan domyślny, to przejście do stanu bezczynności*/
    default: curr_state <= `IDLE;

    endcase
end

endmodule
