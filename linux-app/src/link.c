#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  symlink(argv[1], argv[2]);
  /* link(argv[1], argv[2]); */
  /* unlink(argv[1]); */
	
  perror(argv[0]);
  return 0;
}


/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra link.c -o /tmp/ln" */
/* End: */
