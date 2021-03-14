/* The wait() call is used to tell a process to wait for one of his childs to end, before going on
   with it's own task. wait() takes the adress of an int, in which it puts the exit status of the
   child it waited for (to know what you can do with that status, look at 'man 2 wait')  */
#include <stdio.h> 
#include <stdlib.h>
#include <unistd.h> 
#include <sys/wait.h>

int main () 
{ 
  int pid, status; 

  if(fork()) 
	  { /* parent */
		  puts("I'm the Father, and waiting for 30s..."); 
		  sleep(30); 
		  pid = wait(&status); 
		  printf("I'm the Father:\n - my son's PID is %d\n - my son's exit status is %d\n", pid, status);
	  }
  else
	  { /* child */
		  puts("I'm the Son, and exiting...");
		  puts("Try 'ps aux | grep a.out' to see a zombie.");
		  exit(0);
	  }
  
  printf("Goodbye Cruel World!\n"); 
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall fork-wait.c -o /tmp/a.out" */
/* End: */
