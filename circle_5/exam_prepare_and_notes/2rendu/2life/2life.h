#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

typedef struct s_life
{
    int width; //logisch
    int height; //logisch
    int iterations; //loogisch aber hatte ich schon wieder raus
    int j; //semi fein kann man da keine norm auch 1000 zeile main machen 
    int i;
    char dead; //hier semi frage war wo ich schaue musste welcher typ losung nimmt char
    char alive;
    int on_the_board; // int anstatt bool (C hat kein bool ohne stdbool.h)
    char **grid;
}               t_life;

//noch anderes auser prototypen nopie

