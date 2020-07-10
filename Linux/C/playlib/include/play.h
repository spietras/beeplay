#ifndef PLAY_H
#define PLAY_H

int play(float frequency, int length, int delay, int repeats, int verbose);
int play_line(char *line, int verbose);
int play_sheet(char *path, int verbose);

#endif /* PLAY_H */