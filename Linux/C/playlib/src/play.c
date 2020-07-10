#include "posix.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <time.h>

#include "play.h"
#include "toot.h"

#define MAX_LINE_LENGTH 120

struct timespec make_nano_timespec(int miliseconds)
{
    struct timespec time;
    time.tv_sec = miliseconds / 1000;
    time.tv_nsec = (miliseconds % 1000) * 1000000L;
    return time;
}

int check_params(float frequency, int length, int delay, int repeats)
{
    if (frequency < 0.0f || frequency > 20000.0f)
        return 1;

    if (length < 0)
        return 2;

    if (delay < 0)
        return 3;

    if (repeats < 0)
        return 4;

    return 0;
}

float string_to_float(char *str)
{
    return atof(str);
}

int string_to_int(char *str)
{
    return strtol(str, (char **)NULL, 10);
}

int check_play_result(int result, char *frequency_str, char *length_str, char *delay_str, char *repeats_str, int verbose)
{
    if (result == 1 && verbose)
        printf("Frequency %s is incorrect.\n", frequency_str);
    else if (result == 2 && verbose)
        printf("Length %s is incorrect.\n", length_str);
    else if (result == 3 && verbose)
        printf("Delay %s is incorrect.\n", delay_str);
    else if (result == 4 && verbose)
        printf("Repeats %s is incorrect.\n", repeats_str);

    return result;
}

int play(float frequency, int length, int delay, int repeats, int verbose)
{
    int check;
    struct timespec time;
    int i;

    check = check_params(frequency, length, delay, repeats);
    if (check)
        return check;

    toot_verbose = verbose;

    for (i = 0; i < repeats; i++)
    {
        toot(frequency, length);
        time = make_nano_timespec(delay);
        nanosleep(&time, NULL);
    }

    return 0;
}

int play_line(char *line, int verbose)
{
    char *frequency_str;
    char *length_str;
    char *delay_str;
    char *repeats_str;

    float frequency;
    int length;
    int delay;
    int repeats;

    int result;

    frequency_str = strtok(line, " \t");
    length_str = strtok(NULL, " \t");
    delay_str = strtok(NULL, " \t");
    repeats_str = strtok(NULL, " \t");
    if (!repeats_str)
        repeats_str = "1";

    frequency = string_to_float(frequency_str);
    length = strtol(length_str, (char **)NULL, 10);
    delay = strtol(delay_str, (char **)NULL, 10);
    repeats = strtol(repeats_str, (char **)NULL, 10);

    result = play(frequency, length, delay, repeats, verbose);
    return check_play_result(result, frequency_str, length_str, delay_str, repeats_str, verbose);
}

int play_sheet(char *path, int verbose)
{
    FILE *fp = NULL;
    char line[MAX_LINE_LENGTH];
    int i = 0;

    fp = fopen(path, "r");
    if (fp == NULL)
    {
        if (verbose)
            printf("Can't open %s\n", path);
        return 1;
    }

    while (fgets(line, MAX_LINE_LENGTH, fp))
    {
        if (play_line(line, verbose) && verbose)
            printf("Error in line %d. Skipping...\n", i);
        i++;
    }

    fclose(fp);

    return 0;
}