/* RIGHT: gcc -Wall calc.c -lm
   WRONG: gcc -Wall -lm calc.c

   ORDER is important! gcc cannot find sqrt() after calc.c
 */

//#include<math.h>
#include<stdio.h>

int main (void)
{
  printf ("The square root of 2.0 is %f\n", sqrt(2.0));
  return 0;
}
