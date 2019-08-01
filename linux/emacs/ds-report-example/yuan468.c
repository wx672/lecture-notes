/*
Suppose that the result of n! * 2^n is a integer(int),
suppose that the size of the array is 20,in fact we know that the
n(i1) is 10,the result of n!*2^n is negative(overflow),
the meaning of when the result is a negative(wrong number) is overflow,the program suspended. 
 */
#include <stdio.h>
int main()
{
  int i = 2,t1 = 1,t2 = 1,j,i1 = 2,t,a[20];
  t = t1*t2;
  while (t > 0)
    {
      while (i != 1)
        {
          t1 = t1 * i;
          i--;
        }
      for (j = 0; j <= i1 - 1;j++)
        {
          t2 = t2 * 2;
        }
	t = t1*t2;
	a[i1] = t;
        i1++,i = i1;
        t1 = 1,t2 = 1;
    }
  a[0] = 1,a[1] = 2;
  printf("All the result of n!*2^n are (n:from 0 to 9):\n");
  for (i1 = 0;i1 <= 9;i1++)
    {
      printf("%d\n",a[i1]);
    }
  printf("The maximum of n is:%d\n",i1-1);
  return 0;
}
