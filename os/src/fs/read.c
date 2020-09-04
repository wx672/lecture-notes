#include <unistd.h>
#include <stdlib.h>

int main(void)
{
  char buffer[10];

  read(0, buffer, 10);

  write(1, buffer, 10);

  return EXIT_SUCCESS;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra read.c -o read" */
/* End: */
