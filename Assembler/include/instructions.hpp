#include<iostream>
#include<vector>
#include "register.hpp"


class Instruction
{
 private:
  std::vector<Register> inst_;
  std::string name_;
  std::string nameJump_;
  bool isJump_;

 public:
  Instruction(/* args */);
  // Instruction(std::string, int, int, int, int);
  Instruction(std::string name,std::vector<int> regs, int);
  Instruction(std::string name,std::vector<Register> regs, int);
  ~Instruction();

  std::string GetName();
  void SetName(std::string);
  std::vector<Register> GetRegisters();
  void DelInst();
  std::vector<Register>& SetRegister();
  int GetOpcode();

  void SetNameJump(std::string);
  std::string GetNameJump();
  
};


