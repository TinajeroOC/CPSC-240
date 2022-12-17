#include <stdio.h>
#include <time.h>

void show_wall_time() {
    time_t raw_time;
    struct tm* time_info;
    char time_str[500];
    
    time(&raw_time);
    time_info = localtime(&raw_time);
    strftime(time_str, 500, "The time on the wall is now %b %d, %G at %I:%M%p.", time_info);

    printf("%s\n\n", time_str);
}