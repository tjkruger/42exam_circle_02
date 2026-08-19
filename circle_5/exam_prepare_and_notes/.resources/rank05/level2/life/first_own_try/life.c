#include "life.h"


int init_game_parse_argv_and_figure_out_runflow_while_inuse(t_life* life, char* argv[])
{
    life->width = atoi(argv[1]);
    life->height = atoi(argv[2]);
    life->iterations = atoi(argv[3]);
    life->dead = ' ';
    life->alive = '0';
    life->i = 0;
    life->j = 0;
    life->on_the_board = 0; // 0 = false (kein bool in C)

    life->grid = (char **)malloc(life->height * sizeof(char *));
    if (!(life->grid))
        return (-1);
    for (int i = 0; i < life->height; i++)
    {
        life->grid[i] = (char *)malloc(life->width * sizeof(char));
        if (!(life->grid[i]))
        {
            for (int j = 0; j < i; j++)
                free(life->grid[j]);
            free(life->grid);
            return (-1);
        }
        for (int j = 0; j < life->width; j++)
            life->grid[i][j] = life->dead;
    }
    return (0);
}

int fill_board_while_handling_input(t_life* life) //meh muss ich nochmal uber suggestion schauen.
{
    char buffer;
    int flag = 0;

    while (read(STDIN_FILENO, &buffer, 1) == 1)
    {
        switch (buffer)
        {
        case 'w':
            if (life->i > 0)
                life->i--;
            break;
        case 's':
            if (life->i < (life->height - 1))
                life->i++;
            break;
        case 'a':
            if (life->j > 0)
                life->j--;
            break;
        case 'd':
            if (life->j < (life->width - 1))
                life->j++;
            break;
        case 'x':
            life->on_the_board = !(life->on_the_board);
            break;
        default:
            flag = 1;
        }
        if (flag == 1)
        {
            flag = 0;
            continue;
        }
        if (life->on_the_board == 1)
            life->grid[life->i][life->j] = life->alive;
        else
            life->grid[life->i][life->j] = life->dead;
    }
    return (0);
}

int count_neighbors(t_life* life, int row, int col)
{
    int count = 0;
    for (int di = -1; di <= 1; di++)
    {
        for (int dj = -1; dj <= 1; dj++)
        {
            if (di == 0 && dj == 0)
                continue;
            
            int ni = row + di;
            int nj = col + dj;
            
            // Check boundaries
            if (ni >= 0 && ni < life->height && nj >= 0 && nj < life->width)
            {
                if (life->grid[ni][nj] == life->alive)
                    count++;
            }
        }
    }
    return count;
}

int play(t_life* life)
{
    char** temp = (char**)malloc((life->height) * sizeof(char *));
    if(!temp)
        return(-1);
    for(int i = 0; i < life->height; i++)
    {
        temp[i] = (char *)malloc((life->width) * sizeof(char));
        if(!(temp[i]))
            return(-1);
    }

    for(int i = 0; i < life->height; i++)
    {
        for(int j = 0; j < life->width; j++)
        {
            int neighbors = count_neighbors(life, i, j);
            if(life->grid[i][j] == life->alive) {
                if(neighbors == 2 || neighbors == 3) {
                    temp[i][j] = life->alive;
                }
                else
                    temp[i][j] = life->dead;
            }
            else {
                if(neighbors == 3) {
                    temp[i][j] = life->alive;
                }
                else
                    temp[i][j] = life->dead;
            }
        }
    }

    for(int i = 0; i < life->height; i++)
        free(life->grid[i]);
    free(life->grid);
    life->grid = temp;
    return(0);
}

void print_board(t_life* life)
{
	for(int i = 0; i < life->height; i++)
	{
		for(int j = 0; j < life->width; j++)
		{
			putchar(life->grid[i][j]);
		}
		putchar('\n');
	}
}

int main(int ac, char **av)
{
    if (ac != 4)
        return (1);
    t_life life;
    if (init_game_parse_argv_and_figure_out_runflow_while_inuse(&life, av) == -1)//should be fine besides getting all needed variables in my head when exam
        return (1);
    if (fill_board_while_handling_input(&life) == -1)//get this note frome the subject with what needs to be checked//also dependening on loop and logic be aware to not go out of bounds
        return (1);

    // then came play time //also for play the echo part is already done so no use in platime
    for (int i = 0; i < life.iterations; i++)
    {
        if (play(&life) == -1)
        {
            for (int j = 0; j < life.height; j++)
                free(life.grid[j]);
            free(life.grid);
            return (-1);
        }
    }
    // and after that print the board
    print_board(&life);
    
    // Free memory
    for (int i = 0; i < life.height; i++)
        free(life.grid[i]);
    free(life.grid);
    
    return (0);
}