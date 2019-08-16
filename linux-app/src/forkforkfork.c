#include <signal.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    signal(SIGCHLD, SIG_IGN);  /* now I don't have to wait()! */

    fork();fork();fork();  /* Rabbits, rabbits, rabbits! */

	printf("PPID: %d; PID: %d\n", getppid(), getpid());
	
	return 0;
}
