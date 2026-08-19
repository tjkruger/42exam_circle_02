#ifndef LIFE_H
#define LIFE_H

#include <stdlib.h>
#include <unistd.h>

typedef struct s_game {
	int w, h, iter;
	int pi, pj, draw;
	char **board;
} t_game;

int init_game(t_game *g, char **av);
void fill_board(t_game *g);
int count_neighbors(t_game *g, int i, int j);
int play(t_game *g);
void print_board(t_game *g);
void free_board(t_game *g);

#endif
