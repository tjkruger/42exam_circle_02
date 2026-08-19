#ifndef BSQ_H
#define BSQ_H
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct s_ele{
    int _lines;
    char full;
    char empt;
    char obstl;
} t_ele;

typedef struct s_map{
    int x;
    int y;
}t_map;

typedef struct s_sq_l{
    int width;
    int height;
    char **board;
}t_sq_l;

#endif