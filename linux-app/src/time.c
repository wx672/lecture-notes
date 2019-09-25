#include <time.h>
#include <stdio.h>

int main(void)
{
  time_t t = time(NULL); /* long int */
  
  printf("epoch time:\t%ld\n",t);
  printf("calendar time:\t%s", ctime(&t));
  
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra time.c -o /tmp/time" */
/* End: */
