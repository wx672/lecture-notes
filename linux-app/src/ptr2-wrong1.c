#include<stdio.h>

int main(void)
{
  int i = 5;
  /* int *i = (int *)5; */ /* segfault */
  printf("*i = %d\n", *i); /* Wrong! */
  
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ptr2-wrong1.c -o /tmp/ptr2-wrong1" */
/* End: */
