#include<stdio.h>

int main(void)
{
  int i = 5;
  int *p;
  p = &i; /* now p pointing to i */
  *p = 6; /* i = 6 */
  
  printf("&i = %p, i = %d, *p = %d\n", &i, i, *p);
  printf("&p = %p, p = %p\n", &p, p);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ptr2-code.c -o /tmp/ptr2-code" */
/* End: */
