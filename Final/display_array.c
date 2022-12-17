#include <stdio.h>

void displayArray(double array[], size_t length) {
    for (size_t i = 0; i < length; i++) {
        printf("%0.10e\n", array[i]);
    }
    printf("\n");
}