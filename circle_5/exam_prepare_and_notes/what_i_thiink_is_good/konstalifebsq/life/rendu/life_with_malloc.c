#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int	main(int ac, char **av)
{
	if (ac != 4)
		return (1);

	int	width = atoi(av[1]);
	int	height = atoi(av[2]);
	int	iterations = atoi(av[3]);

	if (width < 0 || height < 0 || iterations < 0)
		return (1);

	int	x = 0, y = 0;
	int	pen = 0;
	char	c;

	int	***grid = (int ***)malloc(2 * sizeof(int **));
	for (int b = 0; b < 2; b++)
	{
		grid[b] = (int **)malloc((height + 2) * sizeof(int *));
		for (int i = 0; i < height + 2; i++)
		{
			grid[b][i] = (int *)calloc(width + 2, sizeof(int));
		}
	}

	while (read(0, &c, 1) > 0)
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

	for (int it = 0; it < iterations; it++)
	{
		int	cur = it % 2;
		int	next = (it + 1) % 2;

         // Clear the next buffer (safety & clarity)
        for (int i = 0; i < height + 2; i++)
            for (int j = 0; j < width + 2; j++)
                grid[next][i][j] = 0;
        // i add it extra to guarantees no garbage carries over.        

		// Compute next generation
        for (int i = 1; i <= height; i++)
		{
			for (int j = 1; j <= width; j++)
			{
				int	n = 0;
				for (int dy = -1; dy <= 1; dy++)
				{
					for (int dx = -1; dx <= 1; dx++)
						if (dx != 0 || dy != 0)
							n += grid[cur][i + dy][j + dx];
				}
				if (grid[cur][i][j] == 1)
					grid[next][i][j] = (n == 2 || n == 3);
				else
					grid[next][i][j] = (n == 3);
			}
		}
	}

	int	final = iterations % 2;
	for (int i = 1; i <= height; i++)
	{
		for (int j = 1; j <= width; j++)
		{
			if (grid[final][i][j])
				putchar('O');
			else
				putchar(' ');
		}
		putchar('\n');
	}

	for (int b = 0; b < 2; b++)
	{
		for (int i = 0; i < height + 2; i++)
			free(grid[b][i]);
		free(grid[b]);
	}
	free(grid);

	return (0);
}