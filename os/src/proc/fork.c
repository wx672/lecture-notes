/* Basically, the fork() call, inside a process, creates an exact copy of that process somewhere
   else in the memory (meaning it'll copy variable values, etc...), and runs the copy from the point
   the call was made (for the assembly kids : it means that the relative value of the next
   instruction pointer is also copied)  */

/* When we launch this program, it first goes through the first printf(). Then, the fork() makes a
   copy of this program. Finally, each one of this program and its copy goes through the second
   printf().  */

#include <stdio.h> 
#include <unistd.h> 

int main () 
{ 
  printf("Hello World!\n"); 
  fork(); 
  printf("Goodbye Cruel World!\n"); 
  return 0;
}
/* Local Variables: */
/* compile-command: "gcc -Wall fork.c" */
/* End: */
