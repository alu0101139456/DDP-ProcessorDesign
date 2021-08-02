#include<parser.hpp>




Parser::Parser(std::string fileInstructions) {
  
  if(LoadInstructionsFromFile(fileInstructions)){
    std::cout << "Instrucciones leidas correctamente" << std::endl;
  }else {
    std::cout << "Fallo al cargar instrucciones" << std::endl;
  }

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
  std::vector<int> regInt;
  std::vector<std::string> regs(4);
  std::string temp;
  while (!file.eof()) { 
    getline(file, temp);
    if( temp != "" && temp[0] != '#') {
      file >> regs[0] >> regs[1] >> regs[2] >> regs[3];
      for (size_t i = 0; i < regs.size(); i++) {
        std::stringstream inVal(regs[i]);
        inVal >> aux;
        regInt.push_back(aux);
      }
      std::string nameInstruction;
      std::string opcode;
      int opcodeInt;
      file >> nameInstruction >> opcode;
      std::stringstream op(opcode);
      op >> opcodeInt;    
      
      
      instructions_.push_back(Instruction(nameInstruction, regInt, opcodeInt));
      
      
    }

  }

    
  file.close();
  return true;

}

void Parser::ShowInstructionsLoad(void) {
  for (size_t i = 0; i < instructions_.size(); i++) {
    std::cout << instructions_[i].name_
  }
  
}