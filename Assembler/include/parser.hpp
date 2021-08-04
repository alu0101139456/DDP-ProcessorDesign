#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include "instructions.hpp"


class Parser
{
 private:
   std::vector<Instruction> instructions_;

 public:
  Parser(std::string, std::string);
  ~Parser();
  bool LoadInstructionsFromFile(std::string);
  bool LoadAssamblerFromFile(std::string);

  void ShowInstructionsLoad();
 
};

