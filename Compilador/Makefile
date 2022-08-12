CXX		  := g++
CXX_FLAGS := -std=c++17 -ggdb

BIN		:= bin
SRC		:= src
INCLUDE	:= include

EXECUTABLE	:= assembler


all: $(BIN)/$(EXECUTABLE)

run: clean all
	clear
	./$(BIN)/$(EXECUTABLE) ../CPU/Codigos/Instrucciones.txt ../CPU/Codigos/f_instr.txt ../CPU/progfile.dat

$(BIN)/$(EXECUTABLE): $(SRC)/*.cpp
	$(CXX) $(CXX_FLAGS) -I$(INCLUDE) $^ -o $@ 

clean:
	-rm $(BIN)/*
