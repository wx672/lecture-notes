#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void sig_usr(int);

int main(void)
{
  printf("PID = %d\n", getpid());
  
  if (signal(SIGUSR1, sig_usr) == SIG_ERR)
    perror("signal<SIGUSR1>");

  for ( ; ; )
    pause();
}

void sig_usr(int signo) 
{
  if (signo == SIGUSR1)
    printf("received SIGUSR1\n");
  else
    perror("sig_usr");
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra sigusr.c -o sigusr" */
/* End: */
