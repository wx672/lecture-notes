#include <signal.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    signal(SIGCHLD, SIG_IGN);  /* no wait()! */

    fork();fork();fork();

	printf("PPID: %d; PID: %d\n", getppid(), getpid());
	
	return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra forkforkfork.c -o /tmp/fff" */
/* End: */
