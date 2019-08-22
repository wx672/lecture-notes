#include <unistd.h>

int main(void)
{
  write(1, "Hello, world!\n", 14);

  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra write.c -o write" */
/* End: */
