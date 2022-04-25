#include<parser.hpp>




Parser::Parser(std::string fileInstructions, std::string fileAssambler, std::string fileOutput) {
  
  if(LoadInstructionsFromFile(fileInstructions)&&LoadAssamblerFromFile(fileAssambler)){
    std::cout << "Instrucciones leidas correctamente" << std::endl;
    SetJumps();
    ShowJumpsTable();
  }else {
    std::cout << "Fallo al cargar instrucciones" << std::endl;
  }

  ShowCreatedInstructions();
  MakeBinaryFile(fileOutput);
}

Parser::~Parser(){

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
  if(dev) std::cout << "Hay " << instructions_.size() << " instrucciones cargadas" << std::endl;

  for (size_t i = 0; i < instructions_.size(); i++) {
    if(dev) std::cout << instructions_[i].GetName();
    for (size_t j = 0; j < instructions_[i].GetRegisters().size(); j++) {
      if(instructions_[i].GetRegisters().at(j).GetSize() > 0) {
      if(dev) std::cout << " R" << j << "= " << instructions_[i].GetRegisters().at(j).GetSize() << " ";
      
      if(dev) std::cout << " D[" << std::setfill('0') << std::setw(instructions_[i].GetRegisters().at(j).GetSize()) << instructions_[i].GetRegisters()[j].GetData() << "] ";
      }
    }
    if(dev) std::cout << '\n';
     
  }
  
}

void Parser::ShowCreatedInstructions(void) {
  
  for (size_t i = 0; i < makedInst_.size(); i++) {
    if(dev) std::cout << makedInst_[i].GetName();
    if(!dev) if (instructions_[i].GetName() == "" ) std::cout << "Etiqueta";
    for (size_t j = 0; j < makedInst_[i].GetRegisters().size(); j++) {
      if(makedInst_[i].GetRegisters().at(j).GetSize() > 0) {
      if(dev) std::cout << " R" << j << " Sz=" << makedInst_[i].GetRegisters().at(j).GetSize() << " ";
      
      if(dev) std::cout << " D[" << std::setfill('0') << std::setw(makedInst_[i].GetRegisters().at(j).GetSize()) << makedInst_[i].GetRegisters()[j].GetData() << "] ";
      }
    }
    if(dev) std::cout << '\n';
     
  }
  
}

void Parser::MakeBinaryFile(std::string outFile) {
  std::ofstream out(outFile);
  for (size_t i = 0; i < makedInst_.size(); i++) {
    for (size_t j = 0; j < makedInst_[i].GetRegisters().size(); j++) {
      if(makedInst_[i].GetRegisters().at(j).GetSize() != 0)
      out << std::setfill('0') << std::setw(makedInst_[i].GetRegisters().at(j).GetSize()) << makedInst_[i].GetRegisters()[j].GetData();
    }
    out << '\n';
  }
  int i =0;
  out << "0000000000000000";
  while ( i < (1023 - makedInst_.size())) {
    out << "\n0000000000000000";
    i++;
  }
  
  out.close();
}



bool Parser::LoadAssamblerFromFile(std::string fileAssambler) {
  int line=0;
  bool isSame=false;
  bool empty=false;
  Instruction temp;
  std::ifstream file(fileAssambler);
  if(!file.is_open()) {
    std::cerr << "No se pudo abrir el fichero \"" << fileAssambler << "\"" << std::endl;
    return false;
  }
  
  std::string aux;
  while (std::getline(file, aux)) {
    temp.SetEmpty();
    if(dev) std::cout << "linea = " << line << "\n";
    if (aux == "") {
      std::cout << "ENTRA EN VACIO  CON EL OPCODE : " << temp.GetOpcode() << "\n";
      empty = true;
      temp.SetEmpty();
      line++;
    }
    int j=0;
    std::stringstream ss(aux);
    isSame = false;
    while (!empty && std::getline(ss, aux, ' ')) {
      
      aux.erase(remove(aux.begin(), aux.end(), ','), aux.end());
      if(IsInst(aux)) {
        
        temp = IsInstruction(aux);
        if(dev) std::cout << "Encontrado " << temp.GetName() << " con opcode: " << temp.GetOpcode() << std::endl;
        if(dev) std::cout << "Registros con valores: ";
        for (size_t i = 0; i < temp.GetRegisters().size(); i++ ){
          if(dev) std::cout << temp.GetRegisters().at(i).GetSize();
        }
        if(dev) std::cout << std::endl;
      }
      if( temp.GetName() == aux )  {
        isSame = true;
        temp.SetName(aux);
        if(dev) std::cout << "Instruction: " << temp.GetName();
        if (IsJump(temp.GetName())) {
          std::cout << " Es un salto asi que se guarda: " << aux;
          std::getline(ss, aux, ' ');
          std::cout << " con siguiente linea: >> "<< aux << " fin de linea y seteamos:"; 
          temp.SetNameJump(aux);
          std::cout << "Nos queda temp.name=  " << temp.GetName() << " temp.GetNameJump= " << temp.GetNameJump() << " en linea: " << line << std::endl;
          
        }
        line++;
      }
      else if( aux.find('R') != std::string::npos && isSame) {
        if(dev) std::cout << "Register " ;
        aux.erase(remove(aux.begin(), aux.end(), 'R'), aux.end());
        if(dev) std::cout << ConvertToBinary(aux) << " ->";
        if(dev) std::cout << "Selecionado registro: " << j << std::endl;
        
        if(dev) std::cout << "Tamaño del registro: " << temp.GetRegisters().at(j).GetSize() << std::endl;
        if(temp.GetRegisters().at(j).GetSize() == 0) { 
          j++;
          if(dev) std::cout << "Tamaño del registro: " << temp.GetRegisters().at(j).GetSize() << std::endl;
        }
        Register regTemp(temp.GetRegisters().at(j).GetSize());
        regTemp.SetData(ConvertToBinary(aux));
        temp.SetRegister().at(j) = regTemp;
        
      } 
      else if (aux.find(':') != std::string::npos) {
        aux.erase(remove(aux.begin(), aux.end(), ':'), aux.end());
        
        if(isSame) {
          if(dev) std::cout << "EtiquetaXXX \"" << aux << "\" en linea " << line  << std::endl;
          temp.SetNameJump(aux);
          
        }else {
          jumps_.push_back(std::pair<std::string, int>(aux, line));
          if(dev) std::cout << "\""<< aux << "\" en línea : " << line << std::endl;
          temp.SetNameJump(aux);
          // std::vector<Instruction>::iterator it = makedInst_.end();
          // it->SetNameJump(aux);
          // Instruction aux(ConvertToBinary(std::to_string(line)));
          jump = true;
        }

      }
      else {
        if(dev) std::cout << "Number: " ;
        if(dev) std::cout << ConvertToBinary(aux) << " ->";
        if(dev) std::cout << "Selecionado registro: " << j << std::endl;
        Register regTemp(temp.GetRegisters().at(j).GetSize());
        regTemp.SetData(ConvertToBinary(aux));
        temp.SetRegister().at(j) = regTemp;
      }
      j++;     
      if(dev) std::cout << std::endl;
    }
    if (!jump || empty ) makedInst_.push_back(temp);
    empty = false;
    jump = false;
    temp.SetEmpty();
    // line++;
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

  for (size_t j = 0; j < makedInst_.size(); j++) {
    for (size_t i = 0; i < jumps_.size(); i++) {
      if( (jumps_[i].first == makedInst_[j].GetNameJump()) && IsJump(makedInst_[j].GetName())) {
        // std::cout << jumps_[i].first << "=="<< makedInst_[j].GetNameJump() << std::endl;
        // std::cout << "Numero decimal: " << jumps_[i].second << " Numero binario: " <<  ConvertToBinary(std::to_string(jumps_[i].second)) << std::endl; 
        // std::cout << makedInst_[j].GetName() << " dir " << makedInst_[j].GetDirJump() << std::endl;
        makedInst_[j].SetDirJump(ConvertToBinary(std::to_string(jumps_[i].second)));
        // std::cout << makedInst_[j].GetDirJump() << std::endl;
      }
    

    }
    
  }
  
   

}

bool Parser::IsJump( std::string aux) {  
  for (size_t i = 0; i < saltos_.size(); i++) {
    if(aux == saltos_[i]) {
      // std::cout << "Is " << aux << " == " << saltos_[i] << "!\n";
      return true; 
    }
  }
  return false;  
}