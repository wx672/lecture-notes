#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
	int i=0;
	char *run_argv[argc];
	char *const run_envp[] = {"PATH=/bin:/usr/bin", NULL};
	
	for (;i<argc;i++)
		{
			run_argv[i] = argv[i+1];
			/* printf("run_argv[%d]=%s\n", i, run_argv[i]); */
		}

	execve(argv[1], run_argv, run_envp);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra run.c -o run" */
/* End: */
