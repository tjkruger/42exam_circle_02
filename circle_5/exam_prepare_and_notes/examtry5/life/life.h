#ifndef LIFE_H
#define LIFE_H

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct s_game{
    int width;
    int height;
    int iter;
    int penx;
    int peny;
    int draw;
    char **board;
} t_game;

#endif