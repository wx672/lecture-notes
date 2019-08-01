do {
  while(TestAndSet(lock));

  /* critical section */

  lock = false;

  /* remainder section */

 }while(1);
