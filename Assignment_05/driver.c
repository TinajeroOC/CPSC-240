#include <stdio.h>
#include <stdlib.h>

extern double manager();
extern void show_wall_time();

int main(int argc, char *argv[]) {
    printf("%s", "Welcome to Quicksort Benchmark by John Doe.\n"
    "This program will measure the execution time of a sort function.\n\n");

    double result = manager();
    printf("The main program received %1.15f.\n", result);

    show_wall_time();
    
    printf("%s", "Have a great rest of your day. Zero will be sent to the OS.\n"
    "See you next semester in 440. Bye.\n");
}