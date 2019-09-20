#include <string.h>
#include <stdio.h>

char line[100]; /* Line we are looking at */

int main()
{
  printf("Enter a line: ");

  fgets(line, sizeof(line), stdin);

  printf("The length of the line is: %ld\n", strlen(line));
  puts(line);

  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra fgets1.c -o /tmp/a.out" */
/* End: */
