#include "life.h"

int init_game(t_game *g, char **av) {
	g->w = atoi(av[1]); 
	g->h = atoi(av[2]); 
	g->iter = atoi(av[3]);
	g->pi = 0; 
	g->pj = 0; 
	g->draw = 0;
	g->board = malloc(g->h * sizeof(char *));
	if (!g->board) return -1;
	for (int i = 0; i < g->h; i++) 
	{
		g->board[i] = malloc(g->w);//ugly malloc but works
		if (!g->board[i]) return -1; // malloc check
		for (int j = 0; j < g->w; j++) 
			g->board[i][j] = ' ';//fill board 1st time
	}
	return 0;
}

void fill_board(t_game *g) {
	char c;
	while (read(0, &c, 1) == 1) {// bc of the subject we get the stdin from the pipe of the stdout by compilation chosee echo > "blub" | cc -Wall life.c life.h 
		if (c == 'w' && g->pi > 0) g->pi--;//w key then up so decrease with
		if (c == 's' && g->pi < g->h - 1) g->pi++; // south down 
		if (c == 'a' && g->pj > 0) g->pj--;
		if (c == 'd' && g->pj < g->w - 1) g->pj++;
		if (c == 'x') g->draw = !g->draw;
		if (g->draw) g->board[g->pi][g->pj] = 'O';
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

int play(t_game *g) {
	char **tmp = malloc(g->h * sizeof(char *));
	if (!tmp) return -1;
	for (int i = 0; i < g->h; i++) {
		tmp[i] = malloc(g->w);
		if (!tmp[i]) return -1;
	}
	for (int i = 0; i < g->h; i++)
		for (int j = 0; j < g->w; j++) {
			int n = count_neighbors(g, i, j);
			if (g->board[i][j] == 'O') tmp[i][j] = (n == 2 || n == 3) ? 'O' : ' ';
			else tmp[i][j] = (n == 3) ? 'O' : ' ';
		}
	free_board(g);
	g->board = tmp;
	return 0;
}

void print_board(t_game *g) {
	for (int i = 0; i < g->h; i++) {
		for (int j = 0; j < g->w; j++) write(1, &g->board[i][j], 1);
		write(1, "\n", 1);
	}
}

void free_board(t_game *g) {
	if (g->board) {
		for (int i = 0; i < g->h; i++) if (g->board[i]) free(g->board[i]);
		free(g->board);
	}
}

int main(int ac, char **av) {
	if (ac != 4) return 1; //check ac need to be 4
	t_game g;//init game struct
	if (init_game(&g, av) == -1) return 1; //fill game struct
	fill_board(&g);// fill boardmap 
	for (int i = 0; i < g.iter; i++) if (play(&g) == -1) { free_board(&g); return 1; }
	print_board(&g);
	free_board(&g);
	return 0;
}
