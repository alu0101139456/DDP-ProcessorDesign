#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
#include "instructions.hpp"


class Parser
{
 private:
   std::vector<Instruction> instructions_;
   std::vector<Instruction> makeInst_;

 public:
  Parser(std::string, std::string);
  ~Parser();
  bool LoadInstructionsFromFile(std::string);
  bool LoadAssamblerFromFile(std::string);

  void ShowInstructionsLoad();

  void ShowCreateInstructions();

  Instruction IsInstruction(std::string);
  
  int ConvertToBinary(std::string);

};

