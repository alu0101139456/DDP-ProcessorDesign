#include<parser.hpp>




Parser::Parser(std::string fileInstructions) {
  
  if(LoadInstructionsFromFile(fileInstructions)){
    std::cout << "Instrucciones leidas correctamente" << std::endl;
  }else {
    std::cout << "Fallo al cargar instrucciones" << std::endl;
  }

  ShowInstructionsLoad();

}

Parser::~Parser()
{
}

bool Parser::LoadInstructionsFromFile(std::string fileInstructions) {

  std::ifstream file(fileInstructions);
  if(!file.is_open()) {
    std::cerr << "No se pudo abrir el fichero \"" << fileInstructions << "\"" << std::endl;
    return false;
  }
  int aux;
  // std::vector<int> regInt;
  std::vector<Register> regInt;
  std::vector<std::string> regs(4);
  std::string temp;
  while (!file.eof()) { 
    
    file >> regs[0] >> regs[1] >> regs[2] >> regs[3];
    
    for (size_t i = 0; i < regs.size(); i++) {
      
      std::stringstream inVal(regs[i]);
      inVal >> aux;
      regInt.push_back(Register(aux));
      // std::cout << regInt[i] << std::endl;
    }
    std::string nameInstruction;
    std::string opcode;
    int opcodeInt;
    file >> nameInstruction >> opcode;
    std::stringstream op(opcode);
    op >> opcodeInt;    
    std::cout << "Nombre: " << nameInstruction;
    std::cout << " Opcode: " << std::setfill('0') << std::setw(4) << opcodeInt << std::endl;

    instructions_.push_back(Instruction(nameInstruction, regInt, opcodeInt));


    // }

  }

    
  file.close();
  return true;

}

void Parser::ShowInstructionsLoad(void) {
  for (size_t i = 0; i < instructions_.size(); i++) {
    std::cout << instructions_[i].GetName();
    for (size_t i = 0; i < instructions_[i].GetRegisters().size(); i++) {
      std::cout << "R" << i << "= " << instructions_[i].GetRegisters().at(i).GetData() << " ";
    }
    std::cout << '\n';
     
  }
  
}