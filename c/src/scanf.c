#include <stdio.h>

int main () {
    char name[20];
    int age;
   
    printf("Enter name: ");
    scanf("%s", name);
    printf("Enter age: ");
    scanf("%d", age);

    printf("Your name is: %s\n", name);
    printf("Your age is: %d\n", age);
    return 0;
}
