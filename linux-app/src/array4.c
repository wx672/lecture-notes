#include<stdio.h>

void print_msg(char *ptr_a[], int n)
{
  int i;
  for (i = 0; i < n; i++)     
    printf(" %s", ptr_a[i]);

  puts(".");
}

int main()
{
  char *message[9] = 
    {"Dennis", "Ritchie", "designed",
        "the",       "C", "language",
         "in",     "the",    "1970s"};
  print_msg(message, 9);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra array4.c -o /tmp/array4" */
/* End: */
