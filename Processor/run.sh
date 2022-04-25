#!/bin/zsh

iverilog *.v
./a.out
echo "Abriendo GTKWave"
#gtkwave cpu_tb.vcd 
gtkwave ./GTKWaveFiles/cheking.gtkw