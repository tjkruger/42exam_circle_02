#ifndef BSQ_H
# define BSQ_H

# include <unistd.h>
# include <stdio.h>
# include <stdlib.h>

typedef struct s_elements
{
    int n_lines;
    char empty;
    char full;
    char obstacle;
} t_elements;

typedef struct s_map
{
    char **grid;
    int width;
    int height;
} t_map;

typedef struct s_square
{
	int	size;
	int	row;
	int	col;
}	t_square;


#endif