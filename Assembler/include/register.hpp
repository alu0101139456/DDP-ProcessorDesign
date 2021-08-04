#include<iostream>


class Register
{
 private:
  int data_=0;
  int sz_;

public:
  Register(int sz);
  
  
  ~Register(){}

  void SetData(int data);

  int GetSize(void);

  int GetData(void);

  Register& operator=(const Register& rhs);
};



