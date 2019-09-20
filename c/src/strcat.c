#include <string.h>
#include <stdio.h>

char first[100];     /* first name */
char last[100];      /* last name  */
char full_name[200]; /* full name  */

int main()
{
  strcpy(first, "John");    /* Initialize first name */
  strcpy(last, "Lennon");   /* Initialize last name  */
  strcpy(full_name, first); /* full = "John"  */
  strcat(full_name, " ");   /* full = "John " */
  strcat(full_name, last);  /* full = "John Lennon"  */

  printf("The full name is %s\n", full_name);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra strcat.c -o /tmp/a.out" */
/* End: */
