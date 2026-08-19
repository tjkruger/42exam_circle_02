#include "bsq.h"

static void	free_map(t_map *map)
{
	int	i;

	i = 0;
	while (i < map->height)
	{
		free(map->grid[i]);
		i++;
	}
	free(map->grid);
	map->grid = NULL;
}

static int	load_elements(FILE *file, t_elements *el)
{
	char	*line;
	size_t	cap;
	int		ret;

	line = NULL;
	cap = 0;
	ret = fscanf(file, "%d %c %c %c",
			&el->n_lines, &el->empty, &el->obstacle, &el->full);
	if (ret != 4 || el->n_lines <= 0)
		return (-1);
	if (el->empty == el->obstacle || el->empty == el->full
		|| el->obstacle == el->full)
		return (-1);
	if (el->empty < 32 || el->obstacle < 32 || el->full < 32)
		return (-1);
	/* consume rest of header line */
	if (getline(&line, &cap, file) == -1)
	{
		free(line);
		return (-1);
	}
	free(line);
	return (0);
}

static int	load_map(FILE *file, t_map *map, t_elements *el)
{
	char	*line;
	size_t	cap;
	ssize_t	n;
	int		len;
	int		i;
	int		j;

	map->height = el->n_lines;
	map->width = -1;
	map->grid = malloc((map->height + 1) * sizeof(char *));
	if (!map->grid)
		return (-1);
	map->grid[map->height] = NULL;
	i = 0;
	while (i < map->height)
	{
		line = NULL;
		cap = 0;
		n = getline(&line, &cap, file);
		if (n <= 0)
		{
			free(line);
			map->height = i;
			free_map(map);
			return (-1);
		}
		len = (int)n;
		if (len > 0 && line[len - 1] == '\n')
			line[--len] = '\0';
		if (len == 0)
		{
			free(line);
			map->height = i;
			free_map(map);
			return (-1);
		}
		if (map->width < 0)
			map->width = len;
		else if (len != map->width)
		{
			free(line);
			map->height = i;
			free_map(map);
			return (-1);
		}
		j = 0;
		while (j < len)
		{
			if (line[j] != el->empty && line[j] != el->obstacle)
			{
				free(line);
				map->height = i;
				free_map(map);
				return (-1);
			}
			j++;
		}
		map->grid[i] = line;
		i++;
	}
	return (0);
}

static int	min3(int a, int b, int c)
{
	int	m;

	m = a;
	if (b < m)
		m = b;
	if (c < m)
		m = c;
	return (m);
}

static void	solve(t_map *map, t_elements *el)
{
	int		**dp;
	t_square	sq;
	int		i;
	int		j;

	dp = malloc(map->height * sizeof(int *));
	if (!dp)
		return ;
	i = 0;
	while (i < map->height)
	{
		dp[i] = calloc(map->width, sizeof(int));
		i++;
	}
	sq.size = 0;
	sq.row = 0;
	sq.col = 0;
	i = 0;
	while (i < map->height)
	{
		j = 0;
		while (j < map->width)
		{
			if (map->grid[i][j] == el->obstacle)
				dp[i][j] = 0;
			else if (i == 0 || j == 0)
				dp[i][j] = 1;
			else
				dp[i][j] = min3(dp[i - 1][j], dp[i][j - 1],
						dp[i - 1][j - 1]) + 1;
			if (dp[i][j] > sq.size)
			{
				sq.size = dp[i][j];
				sq.row = i - dp[i][j] + 1;
				sq.col = j - dp[i][j] + 1;
			}
			j++;
		}
		i++;
	}
	i = sq.row;
	while (i < sq.row + sq.size)
	{
		j = sq.col;
		while (j < sq.col + sq.size)
		{
			map->grid[i][j] = el->full;
			j++;
		}
		i++;
	}
	i = 0;
	while (i < map->height)
	{
		free(dp[i]);
		i++;
	}
	free(dp);
}

int	execute_bsq(FILE *file)
{
	t_elements	el;
	t_map		map;
	int			i;

	if (load_elements(file, &el) == -1)
		return (-1);
	if (load_map(file, &map, &el) == -1)
		return (-1);
	solve(&map, &el);
	i = 0;
	while (i < map.height)
	{
		fprintf(stdout, "%s\n", map.grid[i]);
		i++;
	}
	free_map(&map);
	return (0);
}

int	convert_file_pointer(char *name)
{
	FILE	*file;
	int		ret;

	file = fopen(name, "r");
	if (!file)
		return (-1);
	ret = execute_bsq(file);
	fclose(file);
	return (ret);
}

int	main(int ac, char **av)
{
	if (ac == 1)
		execute_bsq(stdin);
	else if (ac == 2)
	{
		FILE	*f = fopen(av[1], "r");

		if (!f)
			return (1);
		execute_bsq(f);
		fclose(f);
	}
	else
		return (1);
	return (0);
}
