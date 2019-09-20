#include <stdio.h>
#include <string.h>

char first[100]; /* first name */
char  last[100]; /*  last name */
char  full[200]; /*  full name */

int main()
{
  printf("Enter first name: ");
  fgets(first, sizeof(first), stdin);
  /* first[strlen(first)-1] = '\0'; */
	
  printf("Enter last name: ");
  fgets(last, sizeof(last), stdin);

  strcpy(full, first);
  strcat(full, " ");
  strcat(full, last);

  printf("The name is %s\n", full);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra fgets2.c -o /tmp/a.out" */
/* End: */
