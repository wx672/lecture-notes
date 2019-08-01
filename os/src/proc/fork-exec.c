#include<stdio.h> 
#include<unistd.h> 
#include<sys/wait.h>

int main() 
{ 
	printf("Main process (%d) saying hello!\n", getpid()); 
	if(fork() == 0 ){ /* child */

		printf("Child (%d) is listing the source file...\n", getpid());
		/* https://unix.stackexchange.com/questions/315812/why-does-argv-include-the-program-name */
		execl("/bin/ls", "", NULL); 

		/*shouldn't be any code after execl() since it doesn't return on success.*/
		printf("You can't see this line unless execl() failed.\n");
	} else { /* parent */
		int i=60;
		printf("parent (%d) is sleeping for %d seconds...\n", getpid(),i);
		sleep(60);
	}
	/* only the one who doesn't call execl() can do the following. */
	printf("Hello again from process %d\n", getpid());
	return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall fork-exec.c" */
/* End: */
