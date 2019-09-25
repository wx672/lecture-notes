#include<stdio.h>

int main(void)
{
  int a[] = {9,8,0,1};
  int *pa = a;

  while ((*pa) != 0)
    ++pa;

  printf("ZERO at a[%ld].\n", pa - a);
  printf("pa = %p; a = %p\n",pa,a);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra array2-2.c -o /tmp/array2-2" */
/* End: */
