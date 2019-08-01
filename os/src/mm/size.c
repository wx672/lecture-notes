#include<unistd.h>
/* 
 * gcc -o size size.c && echo; size size; echo; ls -l size; echo
 *
 * to see binary info:        [objdump -x size]
 * to see binary dump:        [hexdump -C size]    
 * to see process memory map: [pmap pid]
 */

/* uninitialized global data will be stored in BSS segment */
char x[1024000];    

/* initialized global data will be stored in DATA segment */
//char x[1024000]={[1 ... 1023999] = 1}; //GCC-only syntax
//char x[1024000]={1}; 

int main (void)
{
  sleep(3600);
  /*
   * local variable will be stored in the stack
   */
//  int i=1;       
  return 0;
}
