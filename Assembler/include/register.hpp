#include<iostream>


class Register
{
 private:
  int data_ = 0;
  int sz_ = 0;

public:
  Register(int sz);
  Register(int sz, int data);
  
  ~Register(){}

  void SetData(int data);

  int GetSize(void);

  int GetData(void);

  Register& operator=(const Register& rhs);
};



