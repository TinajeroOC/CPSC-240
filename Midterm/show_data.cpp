#include <stdio.h>

extern "C" void showArray(double array[], size_t size);

void showArray(double array[], size_t size) {
    for (size_t i = 0; i < size; i++) {
        printf("%.10lf\n", array[i]);
    }
}