#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

void *thread_function(void *arg) {
  int i;
  for ( i=0; i<10; i++ ) {
    printf("Thread says hi!, %d\n",i);
    sleep(1);
  }
  return NULL;
}

int main(void) {

  pthread_t mythread;
  
  if ( pthread_create(&mythread, NULL, thread_function, NULL) ) {
    printf("error creating thread.");
    abort();
  }
  printf("Can you see my thread working?\n");
  
 if ( pthread_join ( mythread, NULL ) ) {
    printf("error joining thread.");
    abort();
  }
  exit(0);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra thread1.c -o thread1 -pthread" */
/* End: */
