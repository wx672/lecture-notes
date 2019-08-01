/* To test, try
 *   $ ./a.out /bin/echo aaaa bbbbb ccccc dddddd eeeeee
 *   /bin/echo if execl()
 *   echo if execlp()
 *
 * Try
 *  $ watch -n.1 'ps aux | grep multisleep'
 *  $ ./a.out sleep 9 8 7 6 5
 */
#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <sys/types.h>
#include <sys/wait.h>

int main (int ac, char * av[]) 
{
	if(ac < 3){ 
		printf("usage: multifork command arg1 arg2 ...\n"); 
		exit(EXIT_FAILURE); 
	}
	else{
		int i; 
		char * command = av[1], * arg; 
		for(i = 2; i < ac; i++){			
			arg = av[i]; 
			if(!fork()){/* child */
				execlp(command, "multisleep", arg, NULL);
			}
		} 
		for(i = 2; i < ac; i++) 
			{ 
				int status; 
				wait(&status); 
			} 
		exit(EXIT_SUCCESS); 
    } 
}
/* Local Variables: */
/* compile-command: "gcc -Wall multifork.c" */
/* End: */
