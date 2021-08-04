#include<parser.hpp>




Parser::Parser(std::string fileInstructions, std::string fileAssambler) {
  
  if(LoadInstructionsFromFile(fileInstructions)&&LoadAssamblerFromFile(fileAssambler)){
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
  int sz=0;
  // std::vector<int> regInt;
  std::vector<Register> regInt;
  std::vector<std::string> regs(4);  
  std::string temp;
  while (!file.eof()) {
    file >> regs[0] >> regs[1] >> regs[2] >> regs[3];
    for (size_t i = 0; i < regs.size(); i++) {
      std::stringstream inVal(regs[i]);
      inVal >> sz;
      regInt.push_back(Register(sz));
    }
    std::string nameInstruction;
    std::string opcode;
    int opcodeInt;
    file >> nameInstruction >> opcode;
    std::stringstream op(opcode);
    op >> opcodeInt;    
    instructions_.push_back(Instruction(nameInstruction, regInt, opcodeInt));
    regInt.clear();
  }

    
  file.close();
  return true;

}

void Parser::ShowInstructionsLoad(void) {
  std::cout << "hay " << instructions_.size() << " instrucciones cargadas" << std::endl;

  for (size_t i = 0; i < instructions_.size(); i++) {
    std::cout << instructions_[i].GetName();
    for (size_t j = 0; j < instructions_[i].GetRegisters().size(); j++) {
      std::cout << " R" << j << "= " << instructions_[i].GetRegisters().at(j).GetSize() << " ";
      std::cout << " D[" << std::setfill('0') << std::setw(4) << instructions_[i].GetRegisters()[j].GetData() << "] ";
    }
    std::cout << '\n';
     
  }
  
}


bool Parser::LoadAssamblerFromFile(std::string fileAssambler) {

  
  std::ifstream file(fileAssambler);
  if(!file.is_open()) {
    std::cerr << "No se pudo abrir el fichero \"" << fileAssambler << "\"" << std::endl;
    return false;
  }
  std::string aux;
  while (!file.eof()) {
    file >> aux;
    if (aux[0] == '\n')
    std::cout << "pilot";
    std::cout << "*" << aux;
    

  }

    
  file.close();
  return true;



}