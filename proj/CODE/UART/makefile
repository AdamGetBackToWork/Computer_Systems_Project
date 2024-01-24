NAME		= UART
MODEL_FILES = ${NAME}.sv
RTL_FILES   = ${NAME}_rtl.sv
TB_FILES    = ${NAME}_tb.sv

rtl: 
    # Uruchomienie syntezy yosys
	yosys -s run.ys | tee synth.log

sim: compile
    # Wykonanie skompilowanego programu symulacji
	./${NAME}.iveri.run

compile: clear
    # Kompilacja modulow verilog do programu wykonywalnego
	iverilog -g2012                               \
	    ${MODEL_FILES} ${RTL_FILES} ${TB_FILES}      \
		-o ${NAME}.iveri.run                  \
		    |& tee ${NAME}.iveri.log

waves:
    # Uruchomienie przegladarki przebiegow GTKWave
	gtkwave signals.vcd &
	
clear:
    # Usuwanie wyniku kompilacji Icarus Verilog
	if [ -f ${NAME}.iveri.run ] ; \
	    then rm ${NAME}.iveri.run ; fi