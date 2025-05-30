#define N 5              /* number of philosophers */
#define LEFT (i+N-1)%N   /* number of i's left neighbor */
#define RIGHT (i+1)%N    /* number of i's right neighbor */
#define THINKING 0       /* philosopher is thinking */
#define HUNGRY 1         /* philosopher is trying to get forks */
#define EATING 2         /* philosopher is eating */
typedef int semaphore;
int state[N];            /* state of everyone */
semaphore mutex = 1;     /* for critical regions */
semaphore s[N];          /* one semaphore per philosopher */

void philosopher(int i)  /* i: philosopher number, from 0 to N-1 */
{
  while(TRUE) {   
    think();   
    take_forks(i); /* acquire two forks or block */
    eat();     
    put_forks(i);  /* put both forks back on table */
  }
}
