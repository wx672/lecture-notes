#include <stdio.h>

int main()
{
  char grade;
  while(1){
    puts("Input an uppercase letter: ");
    scanf(" %c", &grade); /* try without the space */
    
    switch(grade) {
    case 'A' :
      puts("Excellent!"); break;
    case 'B' :
    case 'C' :
      puts("Well done."); break;
    case 'D' :
      puts("You passed."); break;
    case 'F' :
      puts("Better try again."); break;
    default :
      puts("Invalid grade.");
    }
  }
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra switch1.c -o /tmp/a.out" */
/* End: */
