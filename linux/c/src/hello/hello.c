#include <stdio.h>

#define HELLO "Hello, world!"

int main(int argc, char *argv[])
{
  int i;
  for (i=0; i < 10; ++i)
    {
#ifdef DEBUG
      printf("i=%d\t",i);	
#endif      
      printf ("%s\n", HELLO);
    }
  return 0;
}
