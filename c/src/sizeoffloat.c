#include <stdio.h>
#include <float.h>
int main() {
    printf("Size for float : %d \n", sizeof(float));
    printf("Min float positive value: %E\n", FLT_MIN );
    printf("Max float positive value: %E\n", FLT_MAX );
    printf("Precision value: %d\n", FLT_DIG );
    return 0;
}
