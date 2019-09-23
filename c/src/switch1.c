#include <stdio.h>
#include <unistd.h>

int main()
{
	char grade[1];

  while(1){
	  /* write(1, "Input an uppercase letter: ", 27); */
	  /* read(0, &grade, 2); */
	  printf("Input an uppercase letter: ");
	  /* grade = getchar(); getchar(); */
	  /* scanf(" %c", &grade); /\* try without the space *\/ */

	  scanf("%s",grade);
    switch(grade[0]) {
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
