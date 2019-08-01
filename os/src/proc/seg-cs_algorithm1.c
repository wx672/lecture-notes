/*
 * Algorithm 1 - Igloo with blackboard inside
 *
 *  - Problem :: Not *progressive*, since it requires *strict alternation* of processes in the
 *                execution of the CS. For example, if turn==0, and t1 is ready to enter its CS, but
 *                t0 is in its loooong non-CS ...
 */
thread0() {
  do{
      while(turn != 0); /* busy waiting */
    
      /* ... Critical section of code ... */

      turn = 1;

      /* ... Non-critical code...
       * could be loooong. if t1 finished its CS and set turn==0, and I am still in my loooong
       * non-CS, and haven't set turn==1, so that t1 cannot get into its CS again.
       */
  } while(true);
}

thread1() {
  do{
      while(turn != 1); /* busy waiting */
    
      /* ... Critical section of code ... */

      turn = 0;

      /* ... Non-critical code ... */
  } while(true);
}

