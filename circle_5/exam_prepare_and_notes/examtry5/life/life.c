#include "life.h"

int fill_board(t_game *g)
{
    char c;
    while(read(0, &c, 1) > 0)
    {
        if(c == 'w' && g->penx > 0)
            g->penx--;
        if(c == 's' && g->penx < (g->height -1))
            g->penx++; 
        if(c == 'a' && g->peny > 0)
            g->peny--;
        if(c == 'd' && g->peny < (g->width -1))
            g->peny++;
        if(c == 'x')
            g->draw = !g->draw;
        if(g->draw)
            g->board[g->penx][g->peny] = 'O';
    }
    return 0;
}

int count_number(t_game *g, int i, int j)
{
    int c = 0;
    for(int ni = -1; ni <= 1; ni++)
    {
        for(int nj = -1; nj <= 1; nj++)
        {
            if(nj == 0 && ni == 0)
                continue;
            int na = i + ni;
            int nb = j + nj;
            if(na >= 0 && na < g->height && nb >= 0 && nb < g->width)
                if(g->board[na][nb] == 'O')
                    c++;
        }
    }
    return c;
}

void free_board(t_game *g)
{
    if(g)
    {
        for(int i = 0; i < g->height; i++)
        {
            if(g->board[i])
                free(g->board[i]);
        }
        free(g->board);
    }
}

void play_game(t_game *g)
{
    int nx = 0;
    int ny = 0;
    char **tmp = malloc(sizeof(char *) * g->height);
    for(int i = 0;i < g->height; i++)
            tmp[i] = malloc(g->width);
    for(int i = 0;i < g->height; i++)
    {
        for(int j = 0; j < g->width; j++)
        {
            int n = count_number(g, i, j);
            if (g->board[i][j] == 'O') tmp[i][j] = (n == 2 || n == 3) ? 'O' : ' ';
			else tmp[i][j] = (n == 3) ? 'O' : ' ';
        }
    }
    free_board(g);
    g->board = tmp;
}

void print_board(t_game *g)
{
    for(int i = 0; i < g->height; i++)
    {
        for(int j = 0; j < g->width; j++)
            putchar(g->board[i][j]);
        putchar('\n');
    }
}

int main(int ac, char **av)
{
    if(ac != 4)
        return 1;
    t_game g;
    g.width = atoi(av[1]);
    g.height = atoi(av[2]);
    g.iter = atoi(av[3]);
    g.penx = 0;
    g.peny = 0;
    g.draw = 0;
    g.board = malloc(sizeof(char *) * g.height);
    for(int i = 0; i < g.height; i++)
    {
        g.board[i] = malloc(sizeof(char) * g.width);
        for(int j = 0; j < g.width; j++)
            g.board[i][j] = ' ';
    
    }
    if(fill_board(&g) == -1)
        return 1;
    for(int i = 0;i < g.iter; i++)
    {
        play_game(&g);
    }
    print_board(&g);
    free_board(&g);
    return 0;
}