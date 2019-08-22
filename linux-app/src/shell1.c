#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAXLINE 4096

int main(void)
{
    char  buf[MAXLINE];
    pid_t pid;
    int   status;

    printf(" ");   
    while ( fgets(buf, MAXLINE, stdin) != NULL ) {
		buf[strlen(buf) - 1] = 0; /* replace newline with null */

        if ( (pid = fork()) < 0 )
			perror("fork");
		else if (pid == 0) { /* child */
            execlp(buf, buf, (char *)0);
            perror("execlp");
            exit(127);
        }

        if ( (pid = waitpid(pid, &status, 0)) < 0 )
            perror("waitpid");
        printf(" ");   
    }
    exit(0);
}
/* apue-3e. p12, fig 1.7*/

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra shell1.c -o shell1" */
/* End: */
