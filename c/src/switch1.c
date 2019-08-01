#include <stdio.h>
 
int main() {
    char grade;
    while(1){
        printf("Input an uppercase letter: ");
        scanf(" %c", &grade);/* try without the space */
        
        switch(grade) {
        case 'A' :
            printf("Excellent!\n");
            break;
        case 'B' :
        case 'C' :
            printf("Well done\n");
            break;
        case 'D' :
            printf("You passed\n");
            break;
        case 'F' :
            printf("Better try again\n");
            break;
        default :
            printf("Invalid grade\n");
        }
    }
    return 0;
}
