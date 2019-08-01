#include<stdio.h>
int main(){
    int a;

    printf("Input an int: ");
    scanf("%d", &a);

    if( a != 10 ) printf("It\'s not 10.\n");

    if( a < 10 )
        printf("It\'s a small number.\n");

    if( a > 10 ){
        if( a < 20 )
            printf("It\'s between 10 and 20.\n");
        else if( a > 100 )
            printf("It\'s larger than 100.\n");
        else
            printf("It\'s between 20 and 100.\n");
    }
    return a;
}
