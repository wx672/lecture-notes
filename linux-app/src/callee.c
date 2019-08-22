#include <stdio.h>

int main(int argc, char **argv) {
  if (argc == 0 && argv[0] == NULL)
      puts("yup");
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra callee.c -o callee" */
/* End: */
