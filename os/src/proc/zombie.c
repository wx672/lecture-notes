/* zombie test. */
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
int main()
{
	pid_t pid;
	switch(pid = fork())
		{
		case 0:
			printf(" CHILD: My PID is %d, My parent's PID is %d\n", getpid(), getppid());
			exit(0);
		default:
			printf("PARENT: My PID is %d, My child's PID is %d\n", getpid(), pid);
			printf("PARENT: I'm now sleeping...\n");
			sleep(60);
		}
	exit(0);
}
/* Local Variables: */
/* compile-command: "gcc -Wall zombie.c" */
/* End: */
