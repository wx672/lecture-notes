#include <stdio.h>

void hi(char* arg)
{
	static char x[1024000]; /* make program bigger */
	printf ("Hi, %s!\n", arg);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -c hi.c" */
/* End: */
