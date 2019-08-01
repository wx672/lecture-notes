/* gcc -Wall badpow.c -lm */

#include <stdio.h>  
/* #include <math.h>
*/
int
main (void)
{
  double x = pow (2.0, 3.0);         /* need math.h */
  printf ("Two cubed is %f\n", x);
  return 0;
}
