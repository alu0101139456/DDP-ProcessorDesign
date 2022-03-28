#include<parser.hpp>




Parser::Parser(std::string fileInstructions, std::string fileAssambler) {
  
  if(LoadInstructionsFromFile(fileInstructions)&&LoadAssamblerFromFile(fileAssambler)){
    std::cout << "Instrucciones leidas correctamente" << std::endl;
    SetJumps();
  }else {
    std::cout << "Fallo al cargar instrucciones" << std::endl;
  }

  // ShowInstructionsLoad();
  // ShowCreatedInstructions();
  // ShowJumpsTable();
  
  ShowCreatedInstructions();
  MakeBinaryFile("p");
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
  std::cout << "Hay " << instructions_.size() << " instrucciones cargadas" << std::endl;

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

void Parser::ShowCreatedInstructions(void) {
  
  for (size_t i = 0; i < makedInst_.size(); i++) {
    std::cout << makedInst_[i].GetName();
    if (instructions_[i].GetName() == "" ) std::cout << "Etiqueta";
    for (size_t j = 0; j < makedInst_[i].GetRegisters().size(); j++) {
      if(makedInst_[i].GetRegisters().at(j).GetSize() > 0) {
      std::cout << " R" << j << " Sz=" << makedInst_[i].GetRegisters().at(j).GetSize() << " ";
      
      std::cout << " D[" << std::setfill('0') << std::setw(makedInst_[i].GetRegisters().at(j).GetSize()) << makedInst_[i].GetRegisters()[j].GetData() << "] ";
      }
    }
    std::cout << '\n';
     
  }
  
}

void Parser::MakeBinaryFile(std::string outName) {
  for (size_t i = 0; i < makedInst_.size(); i++) {
    for (size_t j = 0; j < makedInst_[i].GetRegisters().size(); j++) {
      if(makedInst_[i].GetRegisters().at(j).GetSize() != 0)
      std::cout << std::setfill('0') << std::setw(makedInst_[i].GetRegisters().at(j).GetSize()) << makedInst_[i].GetRegisters()[j].GetData();
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
    
    int j=0;
    std::stringstream ss(aux);
    isSame = false;
    while (std::getline(ss, aux, ' ')) {
      aux.erase(remove(aux.begin(), aux.end(), ','), aux.end());
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
        if(temp.GetRegisters().at(j).GetSize() == 0) { 
          j++;
          std::cout << "Tamaño del registro: " << temp.GetRegisters().at(j).GetSize() << std::endl;
        }
        Register regTemp(temp.GetRegisters().at(j).GetSize());
        regTemp.SetData(ConvertToBinary(aux));
        temp.SetRegister().at(j) = regTemp;
        
      } 
      else if (aux.find(':') != std::string::npos) {
        aux.erase(remove(aux.begin(), aux.end(), ':'), aux.end());
        if(isSame) {
          std::cout << "Etiqueta \"" << aux << "\" en linea " << line  << std::endl;
          temp.SetNameJump(aux);
          
        }else {
          jumps_.push_back(std::pair<std::string, int>(aux, line));
          std::cout << "\""<< aux << "\" en línea : " << line << std::endl;
          Instruction aux(ConvertToBinary(std::to_string(line)));
          temp = aux;
        }

      }
      else {
        std::cout << "Number: " ;
        std::cout << ConvertToBinary(aux) << " ->";
        std::cout << "Selecionado registro: " << j << std::endl;
        Register regTemp(temp.GetRegisters().at(j).GetSize());
        regTemp.SetData(ConvertToBinary(aux));
        temp.SetRegister().at(j) = regTemp;
      }
      j++;     
      std::cout << std::endl;
    }
    
    makedInst_.push_back(temp);

    line++;
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


void Parser::ShowJumpsTable() {

  for (size_t i = 0; i < jumps_.size(); i++) {
    std::cout << "Etiqueta: " << jumps_[i].first << " linea: " << jumps_[i].second << std::endl;
  }

}

void Parser::SetJumps() {

  for (size_t i = 0; i < jumps_.size(); i++) {
    for (size_t k = 0; k < makedInst_.size(); k++) {
      if(makedInst_[k].IsJump() && (makedInst_[k].GetNameJump() == jumps_[i].first)) {
        makedInst_[k].SetDirJump(ConvertToBinary(std::to_string(jumps_[i].second)));
      }
    }
    
  }
   

}