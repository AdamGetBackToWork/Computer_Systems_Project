EXAMPLE = new_alu.sv
MODEL_FILES = ${new_alu}.sv
RTL_FILES = ${synthesized_new_alu}.sv
TB_FILES = testbench.sv
rtl:
# Uruchomienie syntezy yosys
yosys -s run.ys | tee synth.log
sim: compile
# Wykonanie skompilowanego programu symulacji
./${ALU}.iveri.run
compile: clear
# Kompilacja modulow verilog do programu wykonywalnego
iverilog -g2005-sv ${MODEL_FILES} ${RTL_FILES} ${TB_FILES} -o ${new_alu}.iveri.run |& tee ${EXAMPLE}.iveri.log
waves:
# Uruchomienie przegladarki przebiegow GTKWave
gtkwave signals.vcd &
clear:
# Usuwanie wyniku kompilacji Icarus Verilog
if [ -f ${EXAMPLE}.iveri.run ] ; \
then rm ${EXAMPLE}.iveri.run ; fi
