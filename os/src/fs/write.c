#include <unistd.h>
#include <stdlib.h>

int main(void)
{
  write(1, "Hello, world!\n", 14);

  return EXIT_SUCCESS;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra write.c -o /tmp/write" */
/* End: */
