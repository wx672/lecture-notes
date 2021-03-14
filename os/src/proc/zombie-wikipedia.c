/*
 * To catch the zombies:
 * 1) in a terminal window, run:
 *       while true; do ps -el | grep Z; sleep 1; done
 *    or,
 *       watch -n.1 'ps -el | grep Z'
 * 2) run your 'a.out' in another terminal window.
 */
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
 
int main(void)
{
	pid_t pids[5];
	int i;
 
	for (i = 4; i >= 0; --i) {
		printf("Parent (pids[%d], %d) forking...\n", i,getpid());
		pids[i] = fork();
    
		if (pids[i] == 0) { /* child */
			printf("Child pids[%d] sleeping for %d seconds...\n",i,i+1); 
			sleep(i+1);
			printf("pids[%d] waking up after %d seconds sleep.\n",i,i+1);
			_exit(0);
		}
		else { /* parent */
			printf("Parent says: My child pids[%d] = %d\n",i,pids[i]);
			/* waitpid(pids[i], NULL, 0); */
		}
	}
 
	for (i = 4; i >= 0; --i){ /* only for parent */
		printf("Waiting for pids[%d] (%d)...",i,pids[i]);
		/* waitpid(pids[i], NULL, 0); */
		sleep(3);
		printf("done.\n");
	}
	return 0;
}
/* Local Variables: */
/* compile-command: "gcc -Wall zombie-wikipedia.c -o /tmp/a.out" */
/* End: */
