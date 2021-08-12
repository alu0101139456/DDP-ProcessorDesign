#include<parser.hpp>




Parser::Parser(std::string fileInstructions, std::string fileAssambler) {
  
  if(LoadInstructionsFromFile(fileInstructions)&&LoadAssamblerFromFile(fileAssambler)){
    std::cout << "Instrucciones leidas correctamente" << std::endl;
  }else {
    std::cout << "Fallo al cargar instrucciones" << std::endl;
  }

  // ShowInstructionsLoad();
  ShowCreateInstructions();

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
      if(instructions_[i].GetRegisters().at(j).GetSize() > 0) {
      std::cout << " R" << j << "= " << instructions_[i].GetRegisters().at(j).GetSize() << " ";
      
      std::cout << " D[" << std::setfill('0') << std::setw(instructions_[i].GetRegisters().at(j).GetSize()) << instructions_[i].GetRegisters()[j].GetData() << "] ";
      }
    }
    std::cout << '\n';
     
  }
  
}

void Parser::ShowCreateInstructions(void) {
  
  for (size_t i = 0; i < makeInst_.size(); i++) {
    std::cout << makeInst_[i].GetName();
    for (size_t j = 0; j < makeInst_[i].GetRegisters().size(); j++) {
      if(makeInst_[i].GetRegisters().at(j).GetSize() > 0) {
      std::cout << " R" << j << " Sz=" << makeInst_[i].GetRegisters().at(j).GetSize() << " ";
      
      std::cout << " D[" << std::setfill('0') << std::setw(makeInst_[i].GetRegisters().at(j).GetSize()) << makeInst_[i].GetRegisters()[j].GetData() << "] ";
      }
    }
    std::cout << '\n';
     
  }
  
}



bool Parser::LoadAssamblerFromFile(std::string fileAssambler) {
  int line=0;
  bool isSame=false;
  Instruction temp;
  std::ifstream file(fileAssambler);
  if(!file.is_open()) {
    std::cerr << "No se pudo abrir el fichero \"" << fileAssambler << "\"" << std::endl;
    return false;
  }
  
  std::string aux;
  while (std::getline(file, aux)) {
    std::cout << "linea = " << line << "\n";
    line++;
    int j=0;
    std::stringstream ss(aux);
    isSame = false;
    while (std::getline(ss, aux, ' ')) {
      aux.erase(remove(aux.begin(), aux.end(), ','), aux.end());
      // temp = IsInstruction(aux);
      // if(temp.GetName() != ""){
        if(IsInst(aux)) {
          temp = IsInstruction(aux);
      std::cout << "Encontrado " << temp.GetName() << " con opcode: " << temp.GetOpcode() << std::endl;
      std::cout << "Registros con valores: ";
      for (size_t i = 0; i < temp.GetRegisters().size(); i++ ){
        std::cout << temp.GetRegisters().at(i).GetSize();
      }
      std::cout << std::endl;
      }
      if( temp.GetName() == aux )  {
        isSame = true;
        temp.SetName(aux);
        std::cout << "Instruction: " << temp.GetName();
      }
      else if( aux.find('R') != std::string::npos && isSame) {
        std::cout << "Register " ;
        aux.erase(remove(aux.begin(), aux.end(), 'R'), aux.end());
        std::cout << ConvertToBinary(aux) << " ->";
        std::cout << "Selecionado registro: " << j << std::endl;
        
        std::cout << "Tamaño del registro: " << temp.GetRegisters().at(j).GetSize() << std::endl;
        Register regTemp(temp.GetRegisters().at(j).GetSize());
        regTemp.SetData(ConvertToBinary(aux));
        temp.SetRegister().at(j) = regTemp;
        // temp.SetRegister().push_back(ConvertToBinary(aux));
        
      } 
      else if (aux.find(':') != std::string::npos) {
        std::cout << "Jump ";
      }
      else {
        std::cout << "Number: " ;
        std::cout << ConvertToBinary(aux);
        Register regTemp(temp.GetRegisters().at(j).GetSize());
        regTemp.SetData(ConvertToBinary(aux));
        temp.SetRegister().at(j) = regTemp;
      }
      j++;     
      std::cout << std::endl;
    }
    // std::cout << "Mostrando : " << std::endl;
    // for (size_t i = 0; i < temp.GetRegisters().size(); i++)
    // {
    //   std::cout << temp.GetRegisters().at(i).GetData() << "/";
    // }
    
    makeInst_.push_back(temp);
    // temp.DelInst();
    // i=1;

  }

    
  file.close();
  return true;



}



Instruction Parser::IsInstruction(std::string rhs) {
  Instruction a;
  for (size_t i = 0; i < instructions_.size(); i++) {
    if(rhs == instructions_[i].GetName()){
      return instructions_[i];
    }
  }
  return a;
  
}


bool Parser::IsInst(std::string rhs) {

  for (size_t i = 0; i < instructions_.size(); i++) {
    if(rhs == instructions_[i].GetName()){
      return true;
    }
  }
  return false;
  
}



int Parser::ConvertToBinary(std::string rsh ) {
  int aux;
  std::stringstream inVal(rsh);
  inVal >> aux;

  int binarynum = 0;
	int mod, place = 1;
 
	while (aux != 0){
		mod = aux % 2;
		aux = aux / 2;
		binarynum = binarynum + (mod * place);
		place = place * 10;
	}
	return binarynum;
  
   


}