#include<stdio.h>
int main(){
  int i = 5;
  printf("i = %d; ", i);
  
  int *p = &i;
  printf("*p = %d\n", *p);
  
  *p = 6;      /* i = 6 */
  printf("i = %d; ", i);
  printf("*p = %d\n", *p);

  return 0;
}
