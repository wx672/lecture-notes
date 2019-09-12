#include "hello.h"

int main(int argc, char *argv[]){
  if (argc != 2)
    printf ("Usage: %s needs an argument.\n", argv[0]);
  else 
    hi(argv[1]);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra hello2.c hi.c -o hello2" */
/* End: */
