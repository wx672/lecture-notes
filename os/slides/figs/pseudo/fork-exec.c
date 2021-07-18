#include <stdio.h> 
#include <unistd.h> 

int main() 
{ 
  printf("Hello World!\n"); 
  if(fork() != 0 )
    printf("I am the parent process.\n");
  else {
    printf("A child is listing the directory contents...\n");    
    execl("/bin/ls", "ls", "-al", NULL);
  }
  return 0;
}  

