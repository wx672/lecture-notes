#include <stdio.h>

int i=0;

int main()
{
  printf ("%d ",i++);
  main();
  return 0;
}
/* Local Variables: */
/* compile-command: "gcc -Wall main-recur.c" */
/* End: */
