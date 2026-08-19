#include "life.h"


int fillboard(t_game *g, char **av)
{
    g->w = atoi(av[1]);
    g->h = atoi(av[2]);
    g->iter = atoi(av[3]);
    g->i = 0;
    g->j = 0;
    g->draw = 0;
    g->board = malloc(sizeof(char *) * g->h);
    for(int i = 0; i < g->h; i++)
    {
        g->board[i] = malloc(g->w);
        for(int j = 0; j < g->w; j++)
        {
            g->board[i][j] = ' ';
        }
    }
    return 0;
}

int read_input(t_game *g)
{
    char c;
    while(read(0, &c, 1) > 0)
    {
		if (c == 'w' && g->i > 0) g->i--;
		if (c == 's' && g->i < g->h - 1) g->i++;
		if (c == 'a' && g->j > 0) g->j--;
		if (c == 'd' && g->j < g->w - 1) g->j++;
		if (c == 'x') g->draw = !g->draw;
		if (g->draw) g->board[g->i][g->j] = 'O';
    }
    return 0;
}

void print_board(t_game *g)
{
    for(int i = 0; i < g->h; i++)
    {
        for(int j = 0; j < g->w; j++)
        {
            putchar(g->board[i][j]);
        }
        putchar('\n');
    }
}

void free_board(t_game *g)
{
    if(g)
    {
        for(int i = 0; i < g->h; i++)
            free(g->board[i]);
        free(g->board);
    }
}

int count_neighbors(t_game *g, int i, int j) {
	int c = 0;
	for (int di = -1; di <= 1; di++)
		for (int dj = -1; dj <= 1; dj++) {
			if (di == 0 && dj == 0) continue;
			int ni = i + di, nj = j + dj;
			if (ni >= 0 && ni < g->h && nj >= 0 && nj < g->w && g->board[ni][nj] == 'O') c++;
		}
	return c;
}

void play(t_game *g) {
	char **tmp = malloc(g->h * sizeof(char *));
	for (int i = 0; i < g->h; i++) {
		tmp[i] = malloc(g->w);
	}
	for (int i = 0; i < g->h; i++)
		for (int j = 0; j < g->w; j++) {
			int n = count_neighbors(g, i, j);
			if (g->board[i][j] == 'O') tmp[i][j] = (n == 2 || n == 3) ? 'O' : ' ';
			else tmp[i][j] = (n == 3) ? 'O' : ' ';
		}
	free_board(g);
	g->board = tmp;
}

int main(int ac, char **av)
{
    if(ac != 4)
        return (1);
    t_game g;
    if(fillboard(&g, av) == 1)
        return 1;
    if(read_input(&g) == 1)
        return 1;
    for(int i = 0; i < g.iter; i++)
    {
        play(&g);
    }
    print_board(&g);
    free_board(&g);
    return 0;
}