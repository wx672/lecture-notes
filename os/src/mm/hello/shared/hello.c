#include <stdio.h>

void hello(char *arg)
{
  printf("Hello, %s!\n", arg);
}

/* https://stackoverflow.com/questions/5311515/gcc-fpic-option */

/* Local Variables: */
/* compile-command: "gcc -Wall -fPIC -c hello.c" */
/* End: */
