#define _GNU_SOURCE
#include <unistd.h> 
#include <sched.h> 
#include <sys/types.h> 
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
#include <fcntl.h> 
 
int variable;
 
int do_something() {
   variable = 42;
   _exit(0);
}
 
int main(void) {
   void *child_stack;
 
   variable = 9;
   child_stack = (void *) malloc(8192); // WRONG!
   /* child_stack = (void **) malloc(8192) + 8192 / sizeof(*child_stack); // Right! */
   printf("The variable was %d\n", variable);
   
   clone(do_something, child_stack, CLONE_FS | CLONE_VM | CLONE_FILES, NULL);
   sleep(1);
 
   printf("The variable is now %d\n", variable);
   return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall clone.c -o /tmp/a.out" */
/* ref: "http://stackoverflow.com/questions/5255320/reason-for-segmentation-fault" */
/* End: */
