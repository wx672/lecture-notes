#include<stdio.h>

int i=0;

int main(void)
{
#ifdef DEBUG	 
  printf("%d\t",i++);
#endif   
  main();
  return 0;
}
