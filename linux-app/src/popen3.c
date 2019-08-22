#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main()
{
  FILE *fp;
  char buf[1025];
  int rc;

  memset(buf, '\0', sizeof(buf));
  
  if( (fp = popen("ps ax", "r")) != NULL ) {
    rc = fread(buf, sizeof(char), 1024, fp);
    while (rc > 0) {
      buf[rc - 1] = '\0';
      printf("Reading %d:-\n %s\n", 1024, buf);
      rc = fread(buf, sizeof(char), 1024, fp);
    }
    pclose(fp);
    exit(EXIT_SUCCESS);
  }
  exit(EXIT_FAILURE);
}


/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra popen3.c -o popen3" */
/* End: */
