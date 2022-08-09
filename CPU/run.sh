#!/bin/zsh

cd Codigos
./Convert.sh
cd ..

iverilog *.v
./a.out
echo "Abriendo GTKWave"
#gtkwave cpu_tb.vcd 
gtkwave ./GTKWaveFiles/cheking.gtkw