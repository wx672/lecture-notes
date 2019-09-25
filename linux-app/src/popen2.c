#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
  FILE *fp;
  char buf[BUFSIZ + 1];

  sprintf(buf, argv[1]);

  if( (fp = popen("od -c", "w")) != NULL ) {
    fwrite(buf, sizeof(char), strlen(buf), fp);
    pclose(fp);
    exit(EXIT_SUCCESS);
  }
  exit(EXIT_FAILURE);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra popen2.c -o /tmp/popen2" */
/* End: */
