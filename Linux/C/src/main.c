#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <play.h>

char *get_argument(int argc, char **argv, int pos, char *default_value)
{
    if (pos >= argc)
        return default_value;
    return argv[pos];
}

int main(int argc, char **argv)
{
    char *file_path = NULL;
    char *verbose_str = NULL;
    int verbose = 0;
    int result;

    file_path = get_argument(argc, argv, 1, NULL);
    if (file_path == NULL)
    {
        printf("You have to specify a file path\n");
        return 1;
    }

    verbose_str = get_argument(argc, argv, 2, NULL);

    if (verbose_str != NULL && (!strcmp(verbose_str, "-v") || !strcmp(verbose_str, "-verbose")))
        verbose = 1;

    result = play_sheet(file_path, verbose);
    if (result)
        return 1 + result;
    return result;
}