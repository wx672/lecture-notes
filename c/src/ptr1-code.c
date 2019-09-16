#include<stdio.h>

int main(void)
{
  int   a = 1966;
  char  b = 'A';
  float c = 3.1415926;
  int   *a_ptr = &a; /* a pointer to an integer */			
  char  *b_ptr = &b; /* a pointer to a  char    */
  float *c_ptr = &c; /* a pointer to a  float   */

  printf("&a = %p, sizeof(a) = %ld\n", a_ptr, sizeof(a));
  printf("&b = %p, sizeof(b) = %ld\n", b_ptr, sizeof(b));
  printf("&c = %p, sizeof(c) = %ld\n", c_ptr, sizeof(c));
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ptr1-code.c -o /tmp/a.out" */
/* End: */
