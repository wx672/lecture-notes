#include <stdio.h>

float data[3];  /* data to average and total */
float total;    /* the total of the data items */
float average;  /* average of the items */

int main()
{
  data[0] = 34.0;
  data[1] = 27.0;
  data[2] = 45.0;

  total = data[0] + data[1] + data[2];
  average = total / 3.0;
  printf("Total %f Average %f\n", total, average);
  return 0;
}
