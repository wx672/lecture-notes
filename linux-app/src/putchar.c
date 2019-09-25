#include <stdio.h>
#include <unistd.h>

int main(void)
{
    char c;
	while (read(0,&c,1) == 1) putchar(c);
    return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra putchar.c -o /tmp/putchar" */
/* End: */
