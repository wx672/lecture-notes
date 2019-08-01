#include <stdio.h>
#include <string.h>

char first[100]; /* first name */
char  last[100]; /*  last name */
char  full[200]; /*  full name */

int main() {
    printf("Enter first name: ");
    fgets(first, sizeof(first), stdin);

    printf("Enter last name: ");
    fgets(last, sizeof(last), stdin);

    strcpy(full, first);
    strcat(full, " ");
    strcat(full, last);

    printf("The name is %s\n", full);
    return 0;
}
