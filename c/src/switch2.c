#include <stdio.h>

int main(void)
{
  int result=10, value;
  char operator;

  scanf("%c%d", &operator, &value);

  switch (operator) {
  case '+':
	printf("%d\n", result += value); break;
  case '-':
	printf("%d\n", result -= value); break;
  case '*':
	printf("%d\n", result *= value); break;
  case '/':
    if (value == 0)
      puts("Divide by zero.");
    else
	  printf("%d\n", result /= value); break;
  default:
    printf("Unknown operator %c\n", operator);
    break;
  }
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra switch2.c -o /tmp/a.out" */
/* End: */
