#include <stdio.h>

void hi(char* arg)
{
	static char x[1024000]={1}; /* make program bigger */
	printf ("Hi, %s!\n", arg);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -fPIC -c hi.c" */
/* ref: "https://stackoverflow.com/questions/5311515/gcc-fpic-option" */
/* End: */
