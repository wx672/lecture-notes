#include<stdio.h>

int main(void)
{
  int a[] = {9,8,0,1};
  int i = 0;

  while (a[i] != 0)
    ++i;

  printf("ZERO at a[%d].\n", i);
  
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra array2.c -o /tmp/array2" */
/* End: */
