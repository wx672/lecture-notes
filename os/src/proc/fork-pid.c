/*
 * Now, here's something more about the fork() call : it returns an int.  
 * And that's the part that most people are not at ease with :  
 * The fork is executed only once, but it returns two different values.  
 *
 * - In the copied process, called the parent (the one that made the call), it returns the PID of
 *   the copy.
 * - In the copy, the child, it returns 0.
 *
 * So, the parent "knows" who his childs are, but a child doesn't "know" his parent.  
 *
 * Moreover, by testing the return value of fork(), you can learn which one of the parent or the
 * child is running.
 */

#include <stdio.h> 
#include <unistd.h> 

int main () 
{ 
  int pid; 
  printf("Hello World!\n");

  pid = fork();

  if(pid != 0)
    printf("I'm the Father and my son's PID is %d.\n",pid);
  else
    printf("I'm the Son\n");

  printf("Goodbye Cruel World!\n"); 

  return 0;
}
/* Local Variables: */
/* compile-command: "gcc -Wall fork-pid.c" */
/* End: */
