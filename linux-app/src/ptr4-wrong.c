#include <stdio.h>                

void inc_count(int count){
  ++count;
  printf("inc_count: &count = %p\n", &count);
  printf("inc_count: count = %d\n", count);
}                                 

int main(){
  int count = 0;
  printf("main: &count = %p\n", &count);
                               
  inc_count(count);        
  printf("main: count = %d\n", count);
  
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall ptr4-wrong.c -o ptr4-wrong -o /tmp/ptr4-wrong" */
/* End: */
