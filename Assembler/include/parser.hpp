#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
#include "instructions.hpp"
#include <set>
#include <utility>





class Parser
{
 private:
   std::vector<Instruction> instructions_;
   std::vector<Instruction> makeInst_;
  //  std::vector<std::pair<std::string, int>> jumps_;
  std::vector<std::pair<std::string, int>> jumps_;


 public:
  Parser(std::string, std::string);
  ~Parser();
  bool LoadInstructionsFromFile(std::string);
  bool LoadAssamblerFromFile(std::string);

  void ShowInstructionsLoad();

  void ShowCreateInstructions();

  Instruction IsInstruction(std::string);
  bool IsInst(std::string);
  
  int ConvertToBinary(std::string);

  void ShowJumpsTable();

  bool FindJump(std::string);
};

