#define N 5
semaphore mutex=1;
  
void philosopher(int i)
{
  while (TRUE) {
    think();
    wait(&mutex);
      take_fork(i);
      take_fork((i+1) % N);
      eat();
      put_fork(i);
      put_fork((i+1) % N);
    signal(&mutex);
  }
}        
