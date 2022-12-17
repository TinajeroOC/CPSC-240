#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// This function is defined in supervisor.asm
extern double supervisor();

int main(int argc, char *argv[]) {
    printf("Welcome to Harmonic Mean by John Doe.\n\n");
    printf("This program will compute the harmonic mean of your numbers.\n\n");

    double mean = supervisor();

    printf("The main function received this number %0.10e and will keep it for a while.\n\n", mean);
    printf("Enjoy your winter break.\n");

    return 0;
}