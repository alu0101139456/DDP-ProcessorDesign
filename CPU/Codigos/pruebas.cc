
int f15;
int led_v;  

int main() {

  int botones;

    
  while (true) {
    
    if(botones == 0001) {
      f15 = 1;    
    } 
    else {  
      f15 = 0;
    } 
    
  } 


}


void timer() {
  if (f15 == 1) 
    led_v = 1;
}