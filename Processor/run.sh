#!/bin/zsh

echo "Primer paso"
iverilog *.v
echo "Segundo paso"
./a.out
echo "Abriendo GTKWave"
gtkwave cpu_tb.vcd 
