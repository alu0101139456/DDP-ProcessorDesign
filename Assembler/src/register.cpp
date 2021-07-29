#include "register.hpp"



void Register::SetData(int data) {
  data_ = data;
}

int Register::GetData(void) {
  return data_;
}

int Register::GetSize(void) {
  return sz_;
}