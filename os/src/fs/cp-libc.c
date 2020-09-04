#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char *argv[])
{
  FILE *in, *out; 
  int c=0;

  if (argc != 3) {
	  perror(argv[0]);
	  exit(errno);
  }

  in  = fopen(argv[1], "r");
  out = fopen(argv[2], "w");

  while( (c = fgetc(in)) != EOF )
    fputc(c, out);

  return EXIT_SUCCESS;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra cp-libc.c -o /tmp/cp-libc" */
/* End: */
