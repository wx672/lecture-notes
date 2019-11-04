#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

int main()
{
  char c;
  int in;
  in = open("/tmp/1m.test", O_RDONLY);

  while (read(in, &c, 1) == 1);

  return 0;
}


/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra open.c -o /tmp/open" */
/* End: */
