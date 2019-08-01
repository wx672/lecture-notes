#include <stdio.h>

int main(void)
{
  FILE *stream;
    
  stream = fopen("/tmp/1m.test", "r");

  while ( fgetc(stream) != EOF );
    
  fclose(stream);
    
  return 0;
}
