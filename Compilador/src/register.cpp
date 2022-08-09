#include "register.hpp"

Register::Register(int sz):sz_(sz) {}

Register::Register(int sz, int jump):
  sz_(sz), data_(jump) {}

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

void Register::SetEmpty() {
  data_ = 0;
  sz_ = 0;
}