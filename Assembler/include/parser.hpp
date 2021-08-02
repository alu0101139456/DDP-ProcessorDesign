#include <iostream>
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
  Parser(std::string fileInstructions);
  ~Parser();
  bool LoadInstructionsFromFile(std::string);

  void ShowInstructionsLoad();
 
};

    // int test = 0;
    // std::string temp;
    // file >> temp;
    // if(temp[0] != '#') {
    //   std::stringstream intValue(temp);
    //   intValue >> test;
    //   regs.push_back(test);
    //   count += test;
    //   if(count == 16) {
    //     for (size_t i = 0; i < regs.size(); i++) {
    //       std::cout << "[" << regs[i] << "]";
    //     }
    //     count = 0;        
    //   }
    //   std::cout << temp << std::endl;
      
