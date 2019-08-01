#include <stdio.h>
#include "defs.h"

int command();
int search();
int insert();
int files();
int kbd();
int display();
int utils();

int main(int argc, char *argv[])
{
  printf ("Let's go...\n");
  command();
  search();
  insert();
  files();
  kbd();
  display();
  utils();
  return 0;
}
