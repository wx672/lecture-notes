#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void sig_usr(int);

int main(void)
{
  printf("PID = %d\n", getpid());
  
  if( signal(SIGUSR1, sig_usr) == SIG_ERR ){
    perror("signal<SIGUSR1>");
	exit(EXIT_FAILURE);
  }
  
  for(;;) pause();
}

void sig_usr(int signo) 
{
  if (signo == SIGUSR1)
	puts("received SIGUSR1.");
  else{
    perror("sig_usr");
	exit(EXIT_FAILURE);
  }
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra sigusr.c -o /tmp/sigusr" */
/* End: */
