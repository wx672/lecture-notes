#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char *argv[])
{
  if ( argc !=3 ) {
    perror(argv[0]);
	exit(errno);
  }  

  if ( link(argv[1], argv[2]) ) {
    perror("link");
	exit(errno);
  }
  
  return EXIT_SUCCESS;
}

/* symlink(argv[1], argv[2]); */
/* unlink(argv[1]); */


/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra link.c -o /tmp/ln" */
/* End: */
