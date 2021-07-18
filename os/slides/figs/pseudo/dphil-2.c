void take_forks(int i)          /* i: philosopher number */
{
  down(&mutex);                 /* enter critical region */
  state[i] = HUNGRY;
  test(i);                      /* try to acquire 2 forks */
  up(&mutex);                   /* exit critical region */
  down(&s[i]);                  /* block if forks were not acquired */
}
void put_forks(i)               /* i: philosopher number */
{
  down(&mutex);                 /* enter critical region */
  state[i] = THINKING;
  test(LEFT);                   /* see if left neighbor can now eat */
  test(RIGHT);                  /* see if right neighbor can now eat */
  up(&mutex);                   /* exit critical region */
}
void test(i)                    /* i: philosopher number */
{
  if(state[i] == HUNGRY && state[LEFT] != EATING && state[RIGHT] != EATING)
	{
      state[i] = EATING;
      up(&s[i]);
    }
}  

