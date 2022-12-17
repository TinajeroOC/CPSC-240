#include <stdio.h>

extern "C" void displayArray(long int array[], size_t size);

void displayArray(long int array[], size_t size) {
    for (size_t i = 0; i < size; i++) {
        printf("%ld ", array[i]);
    }
}