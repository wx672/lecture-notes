#include <stdio.h>
#include <stdlib.h>

int i=0;
int main()
{
  printf("%d ",i);
  i++;
  main();
  return 0;
}
