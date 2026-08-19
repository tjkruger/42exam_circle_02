#!/bin/bash
# bsq_trainer.sh – Study trainer for the BSQ solution.
# Shows each function's actual code and narrates it.
#
# Usage:
#   bash bsq_trainer.sh              – start from the beginning
#   bash bsq_trainer.sh [section]    – jump to a section
#   bash bsq_trainer.sh list         – list all section names
#
# Sections: free_map load_elements load_map min3 solve execute_bsq convert_file_pointer main
#
# Requires espeak-ng:  sudo apt install espeak-ng

VOICE="en"
SPEED=120

SECTIONS="free_map load_elements load_map min3 solve execute_bsq convert_file_pointer main"

if [[ "$1" == "list" ]]; then
    echo "Available sections:"
    for s in $SECTIONS; do echo "  $s"; done
    exit 0
fi

START="${1:-free_map}"
ACTIVE=false
[[ "$START" == "free_map" || -z "$1" ]] && ACTIVE=true

section() {
    local name="$1"
    if [[ "$ACTIVE" == false && "$name" == "$START" ]]; then
        ACTIVE=true
    fi
}

say() {
    [[ "$ACTIVE" == false ]] && return
    echo "    $*"
    espeak-ng -v "$VOICE" -s "$SPEED" "$*" 2>/dev/null
}

show_code() {
    [[ "$ACTIVE" == false ]] && return
    echo ""
    echo "$1"
    echo ""
}

pause() {
    [[ "$ACTIVE" == false ]] && return
    sleep "${1:-1}"
}

header() {
    [[ "$ACTIVE" == false ]] && return
    echo ""
    echo "══════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "══════════════════════════════════════════════════════════════"
}

# ══════════════════════════════════════════════════════════════
section free_map
header "free_map"
show_code 'static void	free_map(t_map *map)
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
}'
say "free underscore map. Static, returns void, takes a pointer to t underscore map."
pause 0.3
say "Declare int i, set to zero. Loop while i is less than map arrow height: free map arrow grid bracket i bracket. Increment i."
pause 0.3
say "After the loop: free map arrow grid – that frees the pointer array itself. Set map arrow grid to NULL to avoid a dangling pointer."
pause 1

# ══════════════════════════════════════════════════════════════
section load_elements
header "load_elements"
show_code 'static int	load_elements(FILE *file, t_elements *el)
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
	if (getline(&line, &cap, file) == -1)
	{
		free(line);
		return (-1);
	}
	free(line);
	return (0);
}'
say "load underscore elements. Static, returns int, takes a FILE pointer and a pointer to t underscore elements."
pause 0.3
say "Declare char pointer line set to NULL, size underscore t cap set to zero, int ret."
pause 0.3
say "Call fscanf with format percent d space percent c space percent c space percent c. Reads n underscore lines, empty, obstacle, and full. ret gets the count of successfully assigned items."
pause 0.4
say "Check one: if ret is not 4, or n underscore lines is zero or negative – return minus one."
pause 0.3
say "Check two: if any two of the three characters are equal – return minus one."
pause 0.3
say "Check three: if any character has an ASCII value below 32 – unprintable – return minus one."
pause 0.3
say "Check four: call getline to consume the rest of the header line. If it returns minus one, free line and return minus one."
pause 0.3
say "Otherwise free line and return zero."
pause 1

# ══════════════════════════════════════════════════════════════
section load_map
header "load_map"
show_code 'static int	load_map(FILE *file, t_map *map, t_elements *el)
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
		if (len > 0 && line[len - 1] == '\''\''\n'\'\'')
			line[--len] = '\''\''\0'\'\'';
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
}'
say "load underscore map. Static, returns int, takes FILE pointer, pointer to t underscore map, pointer to t underscore elements."
pause 0.3
say "Declare: char pointer line, size underscore t cap, ssize underscore t n, ints len, i, j."
pause 0.3
say "Set map arrow height to el arrow n underscore lines. Set map arrow width to minus one – unknown until first row."
pause 0.3
say "Malloc map arrow grid: height PLUS ONE times size of char pointer. The extra slot holds a NULL sentinel. If malloc fails return minus one. Immediately write NULL into the last slot."
pause 0.4
say "Loop i from zero while i less than map arrow height."
pause 0.2
say "Reset line to NULL and cap to zero. Call getline. If n is zero or negative: free line, set map arrow height to i, call free underscore map, return minus one."
pause 0.4
say "Cast n to int, store in len. If last char is newline, replace with null terminator and decrement len."
pause 0.3
say "If len is zero after stripping: blank row – clean up and return minus one."
pause 0.3
say "If map arrow width is minus one: first row, set width to len. Else if len differs: inconsistent widths – clean up and return minus one."
pause 0.3
say "Validate every character: if line bracket j is neither empty nor obstacle – clean up and return minus one."
pause 0.3
say "Assign line directly to map arrow grid bracket i bracket. Do NOT free line here – we keep it as the grid row. Increment i."
pause 0.3
say "Return zero after the loop."
pause 1

# ══════════════════════════════════════════════════════════════
section min3
header "min3"
show_code 'static int	min3(int a, int b, int c)
{
	int	m;

	m = a;
	if (b < m)
		m = b;
	if (c < m)
		m = c;
	return (m);
}'
say "min 3. Static helper, returns int, takes three ints a, b, c."
pause 0.3
say "Declare int m, assign a. If b less than m assign b. If c less than m assign c. Return m."
pause 1

# ══════════════════════════════════════════════════════════════
section solve
header "solve"
show_code 'static void	solve(t_map *map, t_elements *el)
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
}'
say "solve. Static, returns void, takes pointer to t underscore map and pointer to t underscore elements."
pause 0.3
say "Declare double pointer to int dp, t underscore square sq, ints i and j."
pause 0.3
say "Malloc dp: height times size of int pointer. If it fails return early."
pause 0.3
say "Loop i from zero to height: calloc each dp bracket i bracket with width ints. calloc initialises all to zero."
pause 0.3
say "Set sq dot size, sq dot row, sq dot col all to zero."
pause 0.3
say "Double loop i and j over the grid."
pause 0.2
say "Rule one: if grid bracket i bracket bracket j is obstacle – dp is zero."
pause 0.2
say "Rule two: if i equals zero OR j equals zero – top or left edge – dp is one."
pause 0.2
say "Rule three: dp equals min 3 of dp bracket i minus one bracket bracket j, dp bracket i bracket bracket j minus one, dp bracket i minus one bracket bracket j minus one, plus one. We look at the cell above, left, and diagonally above-left. Take the minimum and add one."
pause 0.5
say "If dp bracket i bracket bracket j is greater than sq dot size: update sq. size equals dp value. row equals i minus dp value plus one. col equals j minus dp value plus one."
pause 0.4
say "After the main loop: stamp the best square. Loop i from sq dot row to sq dot row plus sq dot size, j from sq dot col to sq dot col plus sq dot size. Set grid bracket i bracket bracket j to el arrow full."
pause 0.3
say "Free each dp row, then free dp."
pause 1

# ══════════════════════════════════════════════════════════════
section execute_bsq
header "execute_bsq"
show_code 'int	execute_bsq(FILE *file)
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
}'
say "execute underscore bsq. Returns int, takes a FILE pointer."
pause 0.3
say "Declare t underscore elements el, t underscore map map, int i – all on the stack."
pause 0.3
say "Call load underscore elements with file and address of el. If it returns minus one, return minus one."
pause 0.3
say "Call load underscore map with file, address of map, address of el. If minus one, return minus one."
pause 0.3
say "Call solve with address of map and address of el."
pause 0.3
say "Print loop: while i less than map dot height, call fprintf stdout with format percent s backslash n and map dot grid bracket i. Increment i."
pause 0.3
say "Why percent s works: getline null-terminated every row when we stripped the newline. fprintf reads until backslash zero then appends the newline from the format string."
pause 0.4
say "Call free underscore map, return zero."
pause 1

# ══════════════════════════════════════════════════════════════
section convert_file_pointer
header "convert_file_pointer"
show_code 'int	convert_file_pointer(char *name)
{
	FILE	*file;
	int		ret;

	file = fopen(name, "r");
	if (!file)
		return (-1);
	ret = execute_bsq(file);
	fclose(file);
	return (ret);
}'
say "convert underscore file underscore pointer. Returns int, takes a char pointer called name – a filename string."
pause 0.3
say "Declare FILE pointer file and int ret."
pause 0.3
say "Call fopen on name with mode r for read-only. If file is NULL – file not found or no permission – return minus one."
pause 0.3
say "Call execute underscore bsq with the file pointer, store the return value in ret."
pause 0.3
say "Close the file with fclose to release the OS file descriptor. Return ret."
pause 0.3
say "This is a convenience wrapper: it handles the fopen and fclose around execute underscore bsq, so callers only need to pass a filename string."
pause 1

# ══════════════════════════════════════════════════════════════
section main
header "main"
show_code 'int	main(int ac, char **av)
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
}'
say "main. Returns int, takes int ac and char double pointer av."
pause 0.3
say "If ac equals one – no filename argument – call execute underscore bsq with stdin. stdin is a FILE pointer always open, connected to standard input."
pause 0.4
say "If ac equals two – one argument – the filename is in av bracket one. Call fopen with mode r. If f is NULL, return one immediately. Otherwise call execute underscore bsq with f, then fclose to release the descriptor."
pause 0.4
say "If ac is anything else – wrong argument count – return one."
pause 0.4
say "Return zero at the end of the valid paths."
pause 1

echo ""
echo "══════════════════════════════════════════════════════════════"
say "End of the B S Q trainer. Good luck on the exam."
echo "══════════════════════════════════════════════════════════════"
