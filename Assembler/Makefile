CXX		  := g++
CXX_FLAGS := -std=c++17 -ggdb

BIN		:= bin
SRC		:= src
INCLUDE	:= include

EXECUTABLE	:= assembler


all: $(BIN)/$(EXECUTABLE)

run: clean all
	clear
	./$(BIN)/$(EXECUTABLE) ../Processor/Instrucciones.txt ../Processor/test ../Processor/progfile.dat

$(BIN)/$(EXECUTABLE): $(SRC)/*.cpp
	$(CXX) $(CXX_FLAGS) -I$(INCLUDE) $^ -o $@ 

clean:
	-rm $(BIN)/*
