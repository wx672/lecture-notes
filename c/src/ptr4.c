#include <stdio.h>
void inc_count(int *count_ptr){
    ++(*count_ptr);
} 

int main(){
    int count = 0; 
   
    while(count < 10){
        inc_count(&count); 
        printf("%d\n", count);
    } 
    
    return 0;
}
