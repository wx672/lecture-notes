#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

void *thread_function(void *arg) {
  int i;
  for ( i=0; i<10; i++ ) {
    printf("Thread says hi!, %d\n",i);
    /* sleep(1); */
  }
  return NULL;
}

int main(void) {

  //pthread_t mythread;
  
  /* if ( pthread_create( &mythread, NULL, thread_function, NULL) ) { */
  /*   printf("error creating thread."); */
  /*   abort(); */
  /* } */

  thread_function(NULL);
  
  /* if ( pthread_join ( mythread, NULL ) ) { */
  /*   printf("error joining thread."); */
  /*   abort(); */
  /* } */
  // sleep(2);
  exit(0);

}
/* Local Variables: */
/* compile-command: "gcc -Wall thread1n.c" */
/* End: */
