#include <sys/types.h>
#include <dirent.h>
#include <stddef.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  DIR *dp;
  struct dirent *entry;

  dp = opendir(argv[1]);

  while ( (entry = readdir(dp)) != NULL ){
    printf("%s\n", entry->d_name);
  }
  
  closedir(dp);
      
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ls.c -o ls" */
/* End: */
