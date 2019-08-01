/* http://timmurphy.org/2010/05/04/pthreads-in-c-a-minimal-working-example/ */
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

/* this function is run by the second thread */
void *inc_x(void *x_void_ptr)
{
  /* increment x to 100 */
  int *x_ptr = (int *)x_void_ptr;
  
  while(++(*x_ptr) < 10){
    printf("In child: x = %d\n",*x_ptr);
    /* sleep(1); */
  }
  
  printf("x increment finished\n");

  /* the function must return something - NULL will do */
  return NULL;
}

int main()
{
  int x = 0, y = 0;

  /* show the initial values of x and y */
  printf("x: %d, y: %d\n", x, y);

  /* this variable is our reference to the second thread */
  pthread_t inc_x_thread;

  /* create a second thread which executes inc_x(&x) */
  if(pthread_create(&inc_x_thread, NULL, inc_x, &x)) {

    fprintf(stderr, "Error creating thread\n");
    return 1;
  }

      /* sleep(1); */
  /* increment y to 10 in the first thread */
  while(++y < 10){
    printf("In parent: y = %d\n",y);
    /* sleep(1); */
  }

  printf("y increment finished\n");

  /* wait for the second thread to finish */
  if(pthread_join(inc_x_thread, NULL)) {
    fprintf(stderr, "Error joining thread\n");
    return 2;
  }

  /* show the results - x is now 10 thanks to the second thread */
  printf("x: %d, y: %d\n", x, y);
  

  return 0;
}
/* Local Variables: */
/* compile-command: "gcc -Wall thread5.c" */
/* End: */
