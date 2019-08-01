#include <stdio.h> 
int inc_count(int count){
    return ++count;
} 

int main(){
    int count = 0; 
   
    while(count < 10){
        count = inc_count(count); 
        printf("%d\n", count); 
    } 
    
    return 0;
}
