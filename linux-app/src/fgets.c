#include <stdio.h>
#include <string.h>

int main(void)
{
	char buf[4096];
	
    while ( fgets(buf,4096,stdin) != NULL ){
		buf[strlen(buf)-1] = 0;
		printf("strlen=%ld\n", strlen(buf));
		printf("%s\n", buf);
	}
		
    return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra fgets.c -o fgets" */
/* End: */
