#include "lib.h"

int main(int argc, char* argv[])
{
  int i=1;

  for (; i<argc; i++)
    {
      hello(argv[i]);
      hi(argv[i]);
    }
  return 0;
}


/* Local Variables: */
/* compile-command: "ar crv libhi.a hello.o hi.o && gcc -Wall -o main main.c libhi.a" */
/* End: */
