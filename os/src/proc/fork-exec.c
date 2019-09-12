#include<stdio.h> 
#include<unistd.h> 
#include<sys/wait.h>

int main() 
{ 
  printf("Main process (%d) saying hello!\n", getpid()); 

  if(fork() == 0 ){ 			/* child */
    printf("Child (%d) is listing the source file...\n", getpid());
    
    execl("/bin/ls", "", NULL); 

    /* useless after execl() */
    puts("You can't see this line unless execl() failed.\n");
  }
  else { 						/* parent */
    int i=60;
    printf("parent (%d) is sleeping for %d seconds...\n", getpid(),i);
    sleep(i);					/* for zombie */
  }
  
  /* only the one who doesn't call execl() can do the following. */
  printf("Hello again from process %d\n", getpid());

  return 0;
}

/* https://unix.stackexchange.com/questions/315812/why-does-argv-include-the-program-name */

/* Local Variables: */
/* compile-command: "gcc -Wall fork-exec.c" */
/* End: */
