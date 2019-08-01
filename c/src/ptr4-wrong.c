#include <stdio.h>                
void inc_count(int count){
    ++count;
}                                 

int main(){
    int count = 0;                
                                   
    while(count < 10){
        inc_count(count);        
        printf("%d\n", count);
    }                         
    
    return 0;
}
