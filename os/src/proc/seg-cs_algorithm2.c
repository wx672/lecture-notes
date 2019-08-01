/* Algorithm 2 - Each thread has its own igloo
 *
 * Version 1
 *
 *    - Problem :: Not mutex. Both t1_in_crit and t2_in_crit are initialize to false, what if t1 and
 *                 t2 start at the same time? They both can get into the CS.
 */
t1(){
     while (true) {
         while (t2_in_crit == true); /* do nothing */
         t1_in_crit = true;
         /* ... critical section of code ... */
         t1_in_crit = false;
         /* ... other non-critical code ... */
     }
}

t2(){
     while (true) {
         while (t1_in_crit == true); /* do nothing */
	 t2_in_crit = true;
	 /* ... critical section of code ... */
	 t2_in_crit = false;
	 /* ... other non-critical code ... */
     }
}

/*
 * Version 2
 *
 *    - Problem :: Not progressive. if t1 and t2 start at the same time, they both loop forever.
 */
t1(){
     while (true) {
         t1_in_crit = true;
         while (t2_in_crit == true); /* do nothing */
         /* ... critical section of code ... */
         t1_in_crit = false;
         /* ... other non-critical code ... */
     }
}

t2(){
     while (true) {
	 t2_in_crit = true;
         while (t1_in_crit == true); /* do nothing */
	 /* ... critical section of code ... */
	 t2_in_crit = false;
	 /* ... other non-critical code ... */
     }
}
