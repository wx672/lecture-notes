#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void cry(int sig)
{
  puts("C: I'm crying...");
  kill(getppid(),sig);
}

void complain(int sig)
{
  puts("P: You're noisy.");
}

int main()
{
  if ( fork() == 0 ){
    signal(SIGALRM, cry);
    alarm(2);
    pause();
  }

  signal(SIGALRM, complain);
  pause();
  exit(0);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra alarm.c -o /tmp/alarm" */
/* End: */
