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
   std::vector<Instruction> makedInst_;
  //  std::vector<std::pair<std::string, int>> jumps_;
  std::vector<std::pair<std::string, int>> jumps_;
  std::vector<std::string> saltos_ = {"JUMP", "BEZ", "BNZ", "JAL"} ;
  bool jump = false;

 public:
  Parser(std::string, std::string, std::string);
  ~Parser();
  bool LoadInstructionsFromFile(std::string);
  bool LoadAssamblerFromFile(std::string);

  void ShowInstructionsLoad();

  void ShowCreatedInstructions();

  Instruction IsInstruction(std::string);
  bool IsInst(std::string);
  
  bool IsJump(std::string);

  int ConvertToBinary(std::string);

  void ShowJumpsTable();

  void SetJumps();

  void MakeBinaryFile(std::string);

};

