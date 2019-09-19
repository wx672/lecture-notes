#include <stdio.h>

int main(int argc, char *argv[])
{
  int arg;

  for(arg = 0; arg < argc; arg++) {
    if(argv[arg][0] == '-')
      printf("option: %s\n", argv[arg]);
    else
      printf("argv[%d]: %s\n", arg, argv[arg]);
  }
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra args.c -o /tmp/a.out" */
/* End: */
