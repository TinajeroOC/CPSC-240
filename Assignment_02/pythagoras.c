#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// This function is defined in triangle.asm
extern double hypotenuse();

int main(int argc, char* argv[]) {
    printf("Welcome to the Right Triangles program maintained by John Doe.\n\n"
    "If errors are discovered please report them to John Doe at john@columbia.com for a quick fix.\n"
    "At Columbia Software the customer comes first.\n");

    double length = hypotenuse();

    printf("\nThe main function received this number %1.15f and plans to keep it.\n\n"
    "An integer zero will be returned to the operating system. Bye.\n", length);

    return 0;
}