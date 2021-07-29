#include<iostream>


class Register
{
 private:
  int data_;
  int sz_;

public:
  Register(int sz):sz_(sz) {}
  
  ~Register(){}

  void SetData(int data);

  int GetSize(void);

  int GetData(void);
};



