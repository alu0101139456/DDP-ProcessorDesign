#include<iostream>
#include<vector>
#include "register.hpp"


class Instruction
{
 private:
  std::vector<Register> inst_;
  std::string name_;

 public:
  Instruction(/* args */);
  // Instruction(std::string, int, int, int, int);
  Instruction(std::string name,std::vector<int> regs, int);
  ~Instruction();

  std::string GetName();
  std::vector<Register> GetRegisters();
  
};


