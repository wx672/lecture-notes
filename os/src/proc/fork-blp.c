#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
int main()
{
    pid_t pid;
    char *message;
    int n;
	int status;
    printf("fork program starting\n");
    pid = fork();
    switch(pid)
    {
    case -1:
        perror("fork failed");
        exit(1);
    case 0:
        message = "This is the child";
        n = 7;
        break;
    default:
        message = "This is the parent";
        n = 3;
		/* wait(&status); */
        break;
    }
    for(; n > 0; n--) {
        puts(message);
        sleep(1);
    }
	
	/* It's not necessasry to have both parent and child process do wait() though it doesn't hurt.*/
	wait(&status);

	exit(0);
}

/* Local Variables: */
/* compile-command: "gcc -Wall fork-blp.c" */
/* End: */
