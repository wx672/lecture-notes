#define _GNU_SOURCE
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  char c, *f;
  
  asprintf(&f, "%sXXXXXX", argv[1]);
  int tmp = mkstemp(f);
  
  while ( read(0, &c, 1) == 1)
    write(tmp, &c, 1);

  unlink(f);
  free(f);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra mkstemp.c -o mkstemp" */
/* End: */
