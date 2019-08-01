#include <stdlib.h>
#include <unistd.h>
#define _GNU_SOURCE
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
