/*
   7 6 5 4 3 2 1 0  
  ┌─┬─┬─┬─┬─┬─┬─┬─┐  E ─ error; D ─ done;
  │E│D│B│T│ │ │ │ │  B ─ busy;  T ─ trigger;
  └─┴─┴─┴─┴─┴─┴─┴─┘  0x40 = 01000000b  
*/

char status;
status |= 0x40;     /*   set 'D' bit */
if (status & 0x40); /*  test 'D' bit */
status &= ~0x40;    /* clear 'D' bit */
