#include<stdio.h>

int main()
{
  int a;

  puts("Input an int: ");
  scanf("%d", &a);

  if( a != 10 )
	puts("It\'s not 10.");

  if( a < 10 )
    puts("It\'s a small number.");

  if( a > 10 ){
    if( a < 20 )
      puts("It\'s between 10 and 20.");
    else if( a > 100 )
      puts("It\'s larger than 100.");
    else
      puts("It\'s between 20 and 100.");
  }
  return a;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra if1.c -o /tmp/a.out" */
/* End: */
