#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
	int pid = fork();

	if (pid == 0) {
		printf("child: My pid is %d and my parent's pid is %d.\n", getpid(), getppid());
	}
	else {
		printf("parent: My pid is %d and my child's pid is %d.\n", getpid(), pid);
	}

	return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall fork-ppid.c" */
/* End: */
