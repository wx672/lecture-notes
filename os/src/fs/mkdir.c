#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char *argv[])
{
  char s[100];
  
  if ( argc != 2 ) exit(EXIT_FAILURE);
  
  if ( mkdir(argv[1], S_IRUSR|S_IXUSR) != 0 ) {
	  perror("mkdir");
	  exit(EXIT_FAILURE);
  }

  if ( chdir(argv[1]) != 0 ) {
	  perror("chdir");
	  exit(errno);
  }
  
  printf("PWD = %s\n", getcwd(s,100));

  chdir("..");
  
  if ( rmdir(argv[1]) != 0 ) {
	  perror("rmdir");
	  exit(errno);
  }

  return EXIT_SUCCESS;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra mkdir.c -o /tmp/mkdir" */
/* End: */
