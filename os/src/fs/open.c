#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  char c;
  int in;
  in = open("/tmp/1m.test", O_RDONLY);

  while ( read(in, &c, 1) == 1 );

  close(in);
  
  return EXIT_SUCCESS;
}

/*
  dd if=/dev/zero of=/tmp/1m.test bs=1k count=1024
  strace -c /tmp/fopen # buffered I/O
  strace -c /tmp/open  # un-buffered I/O
 */

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra open.c -o /tmp/open" */
/* End: */
