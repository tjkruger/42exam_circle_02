#ifndef LIFE_H
#define LIFE_H

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct s_game{
    int w;
    int h;
    int iter;
    int i;
    int j;
    int draw;
    char **board;
} t_game;



#endif