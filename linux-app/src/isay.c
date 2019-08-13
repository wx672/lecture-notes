#include <stdio.h>

int main(int argc, char *argv[])
{
  int i;
  printf("You said:\n\t");
  
  for(i=1; i<argc; i++)
    printf("%s ",argv[i]);
  
  printf("\n\n\targc = %d\n", argc);
  
  for(i=0; i<argc; i++)
    printf("\targv[%d] = %s\n",i,argv[i]);

  return 0;
}
