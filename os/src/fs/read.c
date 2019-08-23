#include <unistd.h>

int main(void)
{
  char buffer[10];

  read(0, buffer, 10);

  write(1, buffer, 10);

  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra read.c -o read" */
/* End: */
