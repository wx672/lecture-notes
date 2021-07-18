#include <stdio.h>

void hi(char* arg)
{
	static char x[1024000]={1}; /* make program bigger */
	printf ("Hi, %s!\n", arg);
}

/* https://stackoverflow.com/questions/5311515/gcc-fpic-option */

/* Local Variables: */
/* compile-command: "gcc -Wall -fPIC -c hi.c" */
/* End: */
