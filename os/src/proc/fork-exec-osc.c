#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<sys/wait.h>

int main()
{
  pid_t pid;

  pid = fork();
  if(pid < 0) {        /* error */
    fprintf(stderr, "Fork Failed");
    exit(-1);
  }
  else if(pid == 0){   /* child */
    execlp("/bin/ls", "ls", NULL);
  }
  else {               /* parent */
    wait(NULL);
    puts("Child Complete");
    exit(EXIT_SUCCESS);
  }
  return 0;
}  

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra fork-exec-osc.c -o /tmp/a.out" */
/* End: */
