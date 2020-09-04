#include <sys/types.h>
#include <dirent.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char *argv[])
{
  DIR *dp;
  struct dirent *entry;

  if ( argc != 2 ) {
	  perror(argv[0]);
	  exit(errno);
  }
  
  if ( (dp = opendir(argv[1])) == NULL ) {
	  perror("opendir");
	  exit(errno);
  }

  while ( (entry = readdir(dp)) != NULL ){
    printf("%s\n", entry->d_name);
  }
  
  closedir(dp);
      
  return EXIT_SUCCESS;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ls.c -o /tmp/ls" */
/* End: */
