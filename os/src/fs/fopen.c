#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  FILE *stream;
    
  stream = fopen("/tmp/1m.test", "r");

  while ( fgetc(stream) != EOF );
    
  fclose(stream);
    
  return EXIT_SUCCESS;
}

/*
  dd if=/dev/zero of=/tmp/1m.test bs=1k count=1024
  strace -c /tmp/fopen # buffered I/O
  strace -c /tmp/open  # un-buffered I/O
 */

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra fopen.c -o /tmp/fopen" */
/* End: */
