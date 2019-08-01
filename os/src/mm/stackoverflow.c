#include <stdio.h>

int stackoverflow(int i)
{
  printf("%d ",i);
  stackoverflow(i+1);
  return 0;
}

int main(int argc, char *argv[])
{
  stackoverflow(0);
  return 0;
}
