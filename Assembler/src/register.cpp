#include "register.hpp"

Register::Register(int sz):sz_(sz) {}

void Register::SetData(int data) {
  data_ = data;
}

int Register::GetData(void) {
  return data_;
}

int Register::GetSize(void) {
  return sz_;
}

Register& Register::operator=(const Register& rhs) {
  data_ = rhs.data_;
  sz_ = rhs.sz_;
  return *this;
}