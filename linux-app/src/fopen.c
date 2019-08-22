#include <stdio.h>

int main(void)
{
  FILE *stream;
    
  stream = fopen("/tmp/1m.test", "r");

  while ( fgetc(stream) != EOF );
    
  fclose(stream);
    
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra fopen.c -o fopen" */
/* End: */
