#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <time.h>

#include "toot/toot.h"

int play_line(char* line)
{
    char* frequencyStr = strtok(line," \t");
    char* lengthStr = strtok(NULL," \t");
    char* delayStr = strtok(NULL," \t");
    char* repeatsStr = strtok(NULL," \t");
    if(!repeatsStr)
        repeatsStr = "1";

    float frequency = strtof(frequencyStr, (char**)NULL);
    int length = strtol(lengthStr, (char**)NULL, 10);
    int delay = strtol(delayStr, (char**)NULL, 10);
    int repeats = strtol(repeatsStr, (char**)NULL, 10);

    if(frequency == 0.0f)
    {
        printf("Frequency %s is incorrect.\n", frequencyStr);
        return 1;
    }
    if(length == 0)
    {
        printf("Length %s is incorrect.\n", lengthStr);
        return 1;
    }
    if(delay == 0)
    {
        printf("Delay %s is incorrect.\n", delayStr);
        return 1;
    }
    if(repeats == 0)
    {
        printf("Repeats %s is incorrect.\n", repeatsStr);
        return 1;
    }

    for(int i = 0; i < repeats; i++)
    {
        toot(frequency, length);
        nanosleep((const struct timespec[]){{delay / 1000, (delay % 1000) * 1000000L }}, NULL);
    }

    return 0;
}

int main(int argc, char **argv)
{
    if(argc != 2)
    {
        printf("Exactly one argument is needed\n");
        return 1;
    }

    char* file_path = argv[1];

    FILE* fp = fopen(file_path, "r");
    if (fp == NULL)
    {
        printf("Can't open $s\n", file_path);
        return 2;
    }

    char* line = NULL;
    size_t len = 0;
    ssize_t read;

    int i = 0;
    while ((read = getline(&line, &len, fp)) != -1) {
        if(play_line(line))
            printf("Error in line %d. Skipping...\n", i);
        i++;
    }

    fclose(fp);
    free(line);

    return 0;
}