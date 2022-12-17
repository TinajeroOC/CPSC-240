#include <stdio.h>

void display(double array[], size_t index, size_t len) {
    for (size_t i = index; i < (index + len); i++) {
        printf("%0.10e\n", array[i]);
    }
    printf("\n");
}