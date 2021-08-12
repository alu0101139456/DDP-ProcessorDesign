#include<instructions.hpp>



Instruction::Instruction(/* args */) {
}

// Instruction::Instruction(std::string name, int r1, int r2, int r3, int r4) {
//   for (size_t i = 0; i < 4; i++)
//   {
//     /* code */
//   }
  
// }

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