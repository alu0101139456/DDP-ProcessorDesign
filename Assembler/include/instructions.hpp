#include<iostream>
#include<vector>
#include "register.hpp"


class Instruction
{
 private:
  std::vector<Register> inst_;
  std::string name_;
  std::string nameJump_;
  bool isJump_ = false;
  bool isLabel_ = false;

 public:
  Instruction(/* args */);
  Instruction(int);
  Instruction(std::string name,std::vector<int> regs, int);
  Instruction(std::string name,std::vector<Register> regs, int);
  ~Instruction();

  std::string GetName();
  void SetName(std::string);
  std::vector<Register> GetRegisters();
  void DelInst();
  std::vector<Register>& SetRegister();
  int GetOpcode();
  int GetDirJump();
  void SetNameJump(std::string);
  bool IsJump();
  bool IsLabel();
  std::string GetNameJump();
  void SetDirJump(int);
  Instruction& operator=(const Instruction& rhs);
  
};

