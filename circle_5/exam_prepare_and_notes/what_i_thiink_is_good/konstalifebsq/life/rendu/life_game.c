#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int ***init_grid(int width, int height)
{
    int ***grid = (int ***)malloc(2 * sizeof(int **));
    for(int buffer = 0; buffer < 2; buffer++)
    {
        grid[buffer] = (int **)malloc((height + 2) * sizeof(int *));
        for(int i = 0; i < height + 2; i++)
        {
            grid[buffer][i] = (int *)calloc(width + 2, sizeof(int));
        }
    }
    return (grid);
}

void input_handler(int ***grid, int width, int height)
{
    int x = 0, y = 0;
    int pen = 0;
    char c;

    while(read(0, &c, 1) > 0)
    {
        if (c == 'w' && y > 0)
            y--;
        else if (c == 's' && y < height - 1)
            y++;
        else if (c == 'a' && x > 0)
            x--;
        else if (c == 'd' && x < width - 1)
            x++;
        else if (c == 'x')
            pen = !pen;
        
        if (pen)
            grid[0][y + 1][x + 1] = 1;
    }
}

void simulate(int ***grid, int width, int height, int iter)
{
    for(int it = 0; it < iter; it++)
    {
        int curr = it % 2;
        int next = (it + 1) % 2;

        for(int i = 0; i < height + 2; i++)
            for(int j = 0; j < width + 2; j++)
                grid[next][i][j] = 0;
        
        for(int i = 1; i <= height; i++)
        {
            for(int j = 1; j <= width; j++)
            {
                int n = 0;
                for(int dy = -1; dy <= 1; dy++)
                {
                    for(int dx = -1; dx <= 1; dx++)
                        if (dx != 0 || dy != 0)
                            n += grid[curr][i + dy][j + dx];
                }

                if (grid[curr][i][j] == 1)
                    grid[next][i][j] = (n == 2 || n == 3);
                else
                    grid[next][i][j] = (n == 3);
            }
        }
    }
}

void display_grid(int ***grid, int width, int height, int iter)
{
    int final = iter % 2;
    for(int i = 1; i <= height; i++)
    {
        for(int j = 1; j <= width; j++)
        {
            if (grid[final][i][j])
                putchar('O');
            else
                putchar(' ');
        }
        putchar('\n');
    }
}

void free_grid(int ***grid, int width, int height)
{
    for(int b = 0; b < 2; b++)
    {
        for(int i = 0; i < height + 2; i++)
            free(grid[b][i]);
        free(grid[b]);
    }
    free(grid);
}

int main(int ac, char **av)
{
    if (ac != 4)
        return(1);
    
    int width = atoi(av[1]);
    int height = atoi(av[2]);
    int iter = atoi(av[3]);

    if (width < 0 || height < 0 || iter < 0)
        return(0);
    
    int ***grid = init_grid(width, height);
    input_handler(grid, width, height);
    simulate(grid, width, height, iter);
    display_grid(grid, width, height, iter);
    free_grid(grid, width, height);

    return(0);
}
