/* The algorithm uses two variables, flag and turn. A flag value of 1 indicates that the process
   wants to enter the critical section. The variable turn holds the ID of the process whose turn it
   is. Entrance to the critical section is granted for process P0 if P1 does not want to enter its
   critical section or if P1 has given priority to P0 by setting turn to 0. */

t1_in_crit = false;
t2_in_crit = false;
turn;

t1(){
  do{
    t1_in_crit = true; // t1 wants to get into its CS
    turn = 2;          // but graciously waiting
    
    while (t2_in_crit == true && turn == 2); //busy waiting

    // critical section
    //    ... 
    // end of critical section 
    t1_in_crit = false; // t1 left its CS
    // other non-cs code ...
  }
}

t2(){
  do{
    t2_in_crit = true;
    turn = 1; 
    while (t1_in_crit == true && turn == 1); //busy waiting

    // critical section
    //    ... 
    // end of critical section 
    t2_in_crit = false;
    // other non-cs code ...
  }
}
