#define N 5               /* number of philosophers */

void philosopher(int i)   /* i: philosopher number, from 0 to 4 */
{
  while (TRUE) {
    think();              /* philosopher is thinking */
    take_fork(i);         /* take left fork */
    take_fork((i+1) % N); /* take right fork; % is modulo operator */
    eat();                /* yum-yum, spaghetti */
    put_fork(i);          /* put left fork back on the table */
    put_fork((i+1) % N);  /* put right fork back on the table */
  }
}
