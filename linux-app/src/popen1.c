#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>				/* BUFSIZ 8192 */
#include <string.h>

int main()
{
  FILE *fp;
  char buf[BUFSIZ + 1];
  memset(buf, '\0', sizeof(buf));
  
  if( (fp = popen("uname -a", "r")) != NULL ) {
    if( (fread(buf, sizeof(char), BUFSIZ, fp)) > 0) {
      printf("Output:\n%s\n", buf);
    }
    pclose(fp);
    exit(EXIT_SUCCESS);
  }
  exit(EXIT_FAILURE);
}


/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra popen1.c -o /tmp/popen1" */
/* End: */
