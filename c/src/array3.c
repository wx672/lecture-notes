#include <stdio.h>

#define MAX 5
void init_array_1(int*);
void init_array_2(int*);

int main(void)
{
  int a[MAX], i;

  init_array_1(a);
  printf("init_array_1: ");
  for(i=0; i<MAX; i++)
    printf("a[%d]=%d, ", i, a[i]);
  puts("");
  
  init_array_2(a);
  printf("init_array_2: ");
  for(i=0; i<MAX; i++)
    printf("a[%d]=%d, ", i, a[i]);
  puts("");
  
  return 0;
}

void init_array_1(int a[])
{
  int i;

  for (i=0; i<MAX; ++i)
      a[i] = 0;
}

void init_array_2(int *ptr)
{
  int i;

  for (i=0; i<MAX; ++i)
      *(ptr + i) = i;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra array3.c -o /tmp/a.out" */
/* End: */
