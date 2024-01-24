NAME		= APB
MODEL_FILES = ${NAME}.sv
RTL_FILES   = ${NAME}rtl.sv
TB_FILES    = APBtb.sv

rtl: 
	yosys -s run.ys | tee synth.log

sim: compile
	./${NAME}.iveri.run

compile: clear
	iverilog -g2012 ${MODEL_FILES} ${RTL_FILES} ${TB_FILES} -o ${NAME}.iveri.run | tee ${NAME}.iveri.log

signals:
	gtkwave signals.vcd &
	
clear:
	if [ -f ${NAME}.iveri.run ] ; \
	    then rm ${NAME}.iveri.run ; fi

