#include<instructions.hpp>

Instruction::Instruction(/* args */) {
}


Instruction::Instruction(int jump) {
  name_ = "";
  isLabel_ = true;
  inst_.push_back(Register(16, jump));
}



Instruction::Instruction(std::string name,std::vector<int> regs, int opcode) {
  name_ = name;
  for (size_t i = 0; i < regs.size(); i++) {
    inst_.push_back(Register(regs[i]));

  }
  
  inst_[0].SetData(opcode);

}

Instruction::Instruction(std::string name,std::vector<Register> regs, int opcode) {
  name_ = name;
  inst_ = regs;
  inst_[0].SetData(opcode);
   
}
Instruction::~Instruction()
{
}


std::string Instruction::GetName() {
  return name_;
}

std::vector<Register> Instruction::GetRegisters() {
  return inst_;
}

void Instruction::DelInst() {
  inst_.clear();
  name_.clear();
}

std::vector<Register>& Instruction::SetRegister() {
  return inst_;
}

void Instruction::SetName(std::string rhs) {
 name_ = rhs; 
}

int Instruction::GetOpcode() {
  return inst_[0].GetData();
}

void Instruction::SetNameJump(std::string rhs) {
  isJump_ = true;
  nameJump_ = rhs;
}

std::string Instruction::GetNameJump() {
  return nameJump_;
}

bool Instruction::IsJump() {
  return isJump_;
}

int Instruction::SetDirJump(int rhs) {
  
    inst_[1].SetData(rhs);
  
  return inst_[1].GetData();
}

Instruction& Instruction::operator=(const Instruction& rhs) {
  inst_ = rhs.inst_;
  name_ = rhs.name_;
  nameJump_ = rhs.nameJump_;
  isJump_ = rhs.isJump_;
  return *this;
}