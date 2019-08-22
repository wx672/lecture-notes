#include <stdio.h>
#include <string.h>             /* for strlen() */
#include <stdlib.h>
#include <unistd.h>             /* for fork() */
#include <sys/wait.h>           /* for waitpid() */
#include <signal.h> 

#define MAXLINE 4096

void sig_int(int signo)
{
    printf("Why Ctrl-c?\n-> ");
}

int main(void)
{
    char  buf[MAXLINE]; 
    pid_t pid;
    int   status;

    if (signal(SIGINT, sig_int) == SIG_ERR)
        perror("signal");

    printf("-> "); 
    while (fgets(buf, MAXLINE, stdin) != NULL) {
        buf[strlen(buf) - 1] = '\0'; /* null */

        if ( (pid = fork()) == 0 ) { /* child */
            execlp(buf, buf, (char *)0);
            perror("execlp");
            exit(127);
        }

        if ((pid = waitpid(pid, &status, 0)) < 0)
            perror("waitpid");
        printf("-> ");
    }
    exit(0);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra shell2.c -o shell2" */
/* End: */
