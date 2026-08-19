#!/bin/bash

# ============================================================================
# BSQ TRAINER — 42 Rank 05 / Level 2
# Architecture matches rendu/bsq/bsq.c exactly:
#   t_elements + t_map + t_square, fscanf header, getline map, 2D dp
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/bsq_training"

exercises=(
    "load_elements"
    "load_map"
    "solve"
    "execute_bsq_main"
)

# ─── Names ───────────────────────────────────────────────────────────────────

get_name() {
    case $1 in
        "load_elements")    echo "load_elements()    — fscanf header + 4 checks + consume rest" ;;
        "load_map")         echo "load_map()          — getline rows, validate, store pointers" ;;
        "solve")            echo "solve()             — 2D DP table, find & stamp biggest square" ;;
        "execute_bsq_main") echo "execute_bsq()+main() — pipeline: parse→load→solve→print" ;;
    esac
}

# ─── Common C header (structs + includes) ────────────────────────────────────

c_header() {
cat << 'EOF'
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct s_elements
{
	int		n_lines;
	char	empty;
	char	obstacle;
	char	full;
}	t_elements;

typedef struct s_map
{
	char	**grid;
	int		width;
	int		height;
}	t_map;

typedef struct s_square
{
	int	size;
	int	row;
	int	col;
}	t_square;

EOF
}

# ─── Helpers — always pre-implemented ────────────────────────────────────────

sol_helpers() {
cat << 'EOF'
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

EOF
}

# ─── Solutions ────────────────────────────────────────────────────────────────

sol_load_elements() {
cat << 'EOF'
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
	if (getline(&line, &cap, file) == -1)
	{
		free(line);
		return (-1);
	}
	free(line);
	return (0);
}

EOF
}

sol_load_map() {
cat << 'EOF'
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

EOF
}

sol_solve() {
cat << 'EOF'
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

EOF
}

sol_execute_bsq_main() {
cat << 'EOF'
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
EOF
}

# ─── Skeletons ────────────────────────────────────────────────────────────────

skel_load_elements() {
cat << 'EOF'
static int	load_elements(FILE *file, t_elements *el)
{
	/*
	 * TODO: Parse the header line and fill el
	 *
	 * Format: "[n_lines] [empty] [obstacle] [full]\n"
	 *   e.g.  "9.ox\n"  → n_lines=9, empty='.', obstacle='o', full='x'
	 *         (no spaces needed — fscanf's " %c" skips optional whitespace)
	 *
	 * Steps:
	 *   1. Declare: char *line = NULL, size_t cap = 0, int ret
	 *   2. Call fscanf(file, "%d %c %c %c", &el->n_lines, &el->empty,
	 *                                        &el->obstacle, &el->full)
	 *      → ret = number of items assigned (must be 4)
	 *
	 *   3. Check 1: ret != 4 || el->n_lines <= 0  → return (-1)
	 *   4. Check 2: any two of the three chars are equal → return (-1)
	 *   5. Check 3: any char has ASCII value < 32 → return (-1)
	 *   6. Check 4: getline(&line, &cap, file) == -1
	 *               → free(line); return (-1)
	 *      (consumes the rest of the header line so next read starts at row 1)
	 *   7. free(line); return (0)
	 *
	 * TRAP: fscanf leaves the '\n' in the buffer — you MUST consume it with
	 *       getline, otherwise load_map's first getline reads an empty line.
	 */
	(void)file;
	(void)el;
	return (-1);
}

EOF
}

skel_load_map() {
cat << 'EOF'
static int	load_map(FILE *file, t_map *map, t_elements *el)
{
	/*
	 * TODO: Read el->n_lines rows from file and store them in map->grid
	 *
	 * Setup:
	 *   map->height = el->n_lines;
	 *   map->width  = -1;   (unknown until first row)
	 *   map->grid   = malloc((map->height + 1) * sizeof(char *));
	 *   map->grid[map->height] = NULL;   // NULL sentinel
	 *
	 * Loop i from 0 to map->height:
	 *   1. line = NULL; cap = 0;
	 *   2. n = getline(&line, &cap, file)
	 *      if n <= 0  → free(line); map->height = i; free_map(map); return (-1)
	 *   3. len = (int)n;
	 *      if line[len-1] == '\n'  → line[--len] = '\0';   (strip newline)
	 *   4. if len == 0  → clean up and return (-1)   (blank row)
	 *   5. if map->width < 0  → map->width = len;   (first row sets width)
	 *      else if len != map->width  → clean up and return (-1)
	 *   6. Validate every char: if line[j] != el->empty && != el->obstacle
	 *      → clean up and return (-1)
	 *   7. map->grid[i] = line;   (store pointer — do NOT free line here!)
	 *      i++;
	 *
	 * "clean up" means: free(line); map->height = i; free_map(map); return (-1)
	 *
	 * TRAP: never copy the line — store the pointer getline gave you.
	 * TRAP: set map->height = i BEFORE calling free_map on error, so free_map
	 *       knows how many valid pointers are in map->grid.
	 */
	(void)file;
	(void)map;
	(void)el;
	return (-1);
}

EOF
}

skel_solve() {
cat << 'EOF'
static void	solve(t_map *map, t_elements *el)
{
	/*
	 * TODO: DP — find the biggest all-empty square, then fill it
	 *
	 * Allocate a 2D dp table — one int* per row:
	 *   int **dp = malloc(map->height * sizeof(int *));
	 *   dp[i]    = calloc(map->width, sizeof(int));   (calloc → all zeros)
	 *
	 * Declare t_square sq = {0, 0, 0};
	 *
	 * DP rule at each cell (i, j):
	 *   if obstacle          → dp[i][j] = 0
	 *   if i == 0 || j == 0 → dp[i][j] = 1   (edge cell, at most 1×1)
	 *   else                 → dp[i][j] = min3(dp[i-1][j],    ← above
	 *                                          dp[i][j-1],    ← left
	 *                                          dp[i-1][j-1])  ← diagonal
	 *                                     + 1
	 *
	 * Track best — update ONLY when strictly greater:
	 *   if dp[i][j] > sq.size:
	 *     sq.size = dp[i][j]
	 *     sq.row  = i - dp[i][j] + 1   (top-left row)
	 *     sq.col  = j - dp[i][j] + 1   (top-left col)
	 *
	 * Stamp the square:
	 *   loop i from sq.row to sq.row + sq.size (exclusive)
	 *     loop j from sq.col to sq.col + sq.size (exclusive)
	 *       map->grid[i][j] = el->full
	 *
	 * Free dp: free each dp[i] row, then free dp.
	 *
	 * TRAP: free dp even on early return if malloc for dp[i] fails.
	 *       (simplest: if any calloc fails just return — accepted in exam.)
	 */
	(void)map;
	(void)el;
}

EOF
}

skel_execute_bsq_main() {
cat << 'EOF'
int	execute_bsq(FILE *file)
{
	/*
	 * TODO: Orchestrate the full pipeline for one file/stream
	 *
	 *   Declare on the stack: t_elements el, t_map map, int i
	 *
	 *   1. if (load_elements(file, &el) == -1)  → return (-1)
	 *   2. if (load_map(file, &map, &el) == -1) → return (-1)
	 *   3. solve(&map, &el)
	 *   4. Print loop: while i < map.height
	 *        fprintf(stdout, "%s\n", map.grid[i]);  i++
	 *   5. free_map(&map)
	 *   6. return (0)
	 *
	 * TRAP: use map.grid[i] (dot, not arrow — map is on the stack, not a ptr)
	 * TRAP: fprintf format is "%s\n" — works because getline null-terminated
	 *       each row when we stripped the newline in load_map.
	 */
	(void)file;
	return (-1);
}

int	main(int ac, char **av)
{
	/*
	 * TODO: Entry point — decide where input comes from
	 *
	 *   if ac == 1  → execute_bsq(stdin)
	 *                 stdin is always open — no fopen needed
	 *   if ac == 2  → FILE *f = fopen(av[1], "r")
	 *                 if (!f) return (1)
	 *                 execute_bsq(f)
	 *                 fclose(f)
	 *   else        → return (1)
	 *   return (0)
	 *
	 * TRAP: do NOT check the return value of execute_bsq in main.
	 *       Invalid maps are silently ignored (no error output).
	 */
	(void)ac;
	(void)av;
	return (1);
}
EOF
}

# ─── Generate bsq.c (one skeleton, rest solutions) ───────────────────────────

generate_bsq_c() {
    local skip=$1

    {
        c_header
        sol_helpers

        for fn in load_elements load_map solve execute_bsq_main; do
            if [ "$fn" = "$skip" ]; then
                eval "skel_${fn}"
            else
                eval "sol_${fn}"
            fi
        done
    } > "$WORK_DIR/bsq.c"
}

# ─── Reference binary ─────────────────────────────────────────────────────────

compile_ref() {
    cat > "$WORK_DIR/ref_bsq.c" << 'REFSRC'
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>

typedef struct { int n_lines; char empty, obstacle, full; } t_el;
typedef struct { char **grid; int width, height; } t_map;

static void free_map(t_map *m) {
    int i = 0;
    while (i < m->height) { free(m->grid[i]); i++; }
    free(m->grid); m->grid = NULL;
}
static int min3(int a, int b, int c) {
    int m = a; if (b < m) m = b; if (c < m) m = c; return m;
}
static int load_el(FILE *f, t_el *el) {
    char *line = NULL; size_t cap = 0; int ret;
    ret = fscanf(f, "%d %c %c %c", &el->n_lines, &el->empty, &el->obstacle, &el->full);
    if (ret != 4 || el->n_lines <= 0) return -1;
    if (el->empty == el->obstacle || el->empty == el->full || el->obstacle == el->full) return -1;
    if ((unsigned char)el->empty < 32 || (unsigned char)el->obstacle < 32 || (unsigned char)el->full < 32) return -1;
    if (getline(&line, &cap, f) == -1) { free(line); return -1; }
    free(line); return 0;
}
static int load_map(FILE *f, t_map *map, t_el *el) {
    char *line; size_t cap; ssize_t n; int len, i, j;
    map->height = el->n_lines; map->width = -1;
    map->grid = malloc((map->height + 1) * sizeof(char *));
    if (!map->grid) return -1;
    map->grid[map->height] = NULL;
    i = 0;
    while (i < map->height) {
        line = NULL; cap = 0;
        n = getline(&line, &cap, f);
        if (n <= 0) { free(line); map->height = i; free_map(map); return -1; }
        len = (int)n;
        if (len > 0 && line[len-1] == '\n') line[--len] = '\0';
        if (len == 0) { free(line); map->height = i; free_map(map); return -1; }
        if (map->width < 0) map->width = len;
        else if (len != map->width) { free(line); map->height = i; free_map(map); return -1; }
        j = 0;
        while (j < len) {
            if (line[j] != el->empty && line[j] != el->obstacle) {
                free(line); map->height = i; free_map(map); return -1;
            }
            j++;
        }
        map->grid[i] = line; i++;
    }
    return 0;
}
static void solve(t_map *map, t_el *el) {
    int **dp; int sq_size = 0, sq_row = 0, sq_col = 0; int i, j;
    dp = malloc(map->height * sizeof(int *));
    if (!dp) return;
    i = 0; while (i < map->height) { dp[i] = calloc(map->width, sizeof(int)); i++; }
    i = 0;
    while (i < map->height) {
        j = 0;
        while (j < map->width) {
            if (map->grid[i][j] == el->obstacle) dp[i][j] = 0;
            else if (i == 0 || j == 0) dp[i][j] = 1;
            else dp[i][j] = min3(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1;
            if (dp[i][j] > sq_size) {
                sq_size = dp[i][j];
                sq_row = i - dp[i][j] + 1;
                sq_col = j - dp[i][j] + 1;
            }
            j++;
        }
        i++;
    }
    i = sq_row;
    while (i < sq_row + sq_size) {
        j = sq_col;
        while (j < sq_col + sq_size) { map->grid[i][j] = el->full; j++; }
        i++;
    }
    i = 0; while (i < map->height) { free(dp[i]); i++; } free(dp);
}
static int execute_bsq(FILE *f) {
    t_el el; t_map map; int i;
    if (load_el(f, &el) == -1) return -1;
    if (load_map(f, &map, &el) == -1) return -1;
    solve(&map, &el);
    i = 0; while (i < map.height) { fprintf(stdout, "%s\n", map.grid[i]); i++; }
    free_map(&map); return 0;
}
int main(int ac, char **av) {
    if (ac == 1) execute_bsq(stdin);
    else if (ac == 2) { FILE *f = fopen(av[1], "r"); if (!f) return 1; execute_bsq(f); fclose(f); }
    else return 1;
    return 0;
}
REFSRC
    gcc -std=c99 -o "$WORK_DIR/ref_bsq" "$WORK_DIR/ref_bsq.c" 2>/dev/null
}

# ─── Test helpers ─────────────────────────────────────────────────────────────

write_map() {
    local file="$1"
    shift
    printf '%s\n' "$@" > "$file"
}

# ─── Test cases ──────────────────────────────────────────────────────────────

run_tests() {
    local ex=$1
    cd "$WORK_DIR" || return 1

    gcc -Wall -Wextra -Werror -std=c99 -o user_bsq bsq.c 2>/tmp/bsq_compile_err.txt
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Compile failed:${NC}"
        cat /tmp/bsq_compile_err.txt
        return 1
    fi

    compile_ref

    local pass=0 fail=0

    check_file() {
        local name="$1" file="$2"
        local ref user
        ref=$(./ref_bsq "$file" 2>/dev/null)
        user=$(./user_bsq "$file" 2>/dev/null)
        printf "  ${CYAN}%-52s${NC}" "$name"
        if [ "$ref" = "$user" ]; then
            echo -e "${GREEN}✓${NC}"; pass=$((pass+1))
        else
            echo -e "${RED}✗${NC}"
            echo -e "    ${YELLOW}expected:${NC}"
            printf '%s\n' "$ref"  | head -6 | sed 's/^/      /'
            echo -e "    ${RED}got:${NC}"
            printf '%s\n' "$user" | head -6 | sed 's/^/      /'
            fail=$((fail+1))
        fi
    }

    check_stdin() {
        local name="$1" content="$2"
        local ref user
        ref=$(printf '%s' "$content"  | ./ref_bsq 2>/dev/null)
        user=$(printf '%s' "$content" | ./user_bsq 2>/dev/null)
        printf "  ${CYAN}%-52s${NC}" "$name"
        if [ "$ref" = "$user" ]; then
            echo -e "${GREEN}✓${NC}"; pass=$((pass+1))
        else
            echo -e "${RED}✗${NC}"
            echo -e "    ${YELLOW}expected:${NC}"
            printf '%s\n' "$ref"  | head -6 | sed 's/^/      /'
            echo -e "    ${RED}got:${NC}"
            printf '%s\n' "$user" | head -6 | sed 's/^/      /'
            fail=$((fail+1))
        fi
    }

    case $ex in
        "load_elements")
            echo -e "  ${YELLOW}--- Valid headers ---${NC}"
            write_map /tmp/t1.map "4.ox" "...." "...." "...." "...."
            check_file "valid '4.ox'"                         /tmp/t1.map

            write_map /tmp/t2.map "3abc" "aaa" "aba" "aaa"
            check_file "valid '3abc' (a=empty, b=obst, c=full)" /tmp/t2.map

            write_map /tmp/t3.map "2 .ox" ".." ".."
            check_file "valid '2 .ox' (space before dot)"    /tmp/t3.map

            echo -e "  ${YELLOW}--- Invalid headers ---${NC}"
            write_map /tmp/ti1.map "0.ox" "..."
            check_file "n_lines=0 → invalid (no output)"     /tmp/ti1.map

            write_map /tmp/ti2.map "-1.ox" "..."
            check_file "negative n_lines → invalid"          /tmp/ti2.map

            write_map /tmp/ti3.map "3..x" "..." "..." "..."
            check_file "empty == obstacle ('.' == '.') → invalid" /tmp/ti3.map

            write_map /tmp/ti4.map "3.xx" "..." "..." "..."
            check_file "obstacle == full ('x' == 'x') → invalid"  /tmp/ti4.map

            write_map /tmp/ti5.map "3.o." "..." "..." "..."
            check_file "empty == full ('.' == '.') → invalid"     /tmp/ti5.map
            ;;

        "load_map")
            echo -e "  ${YELLOW}--- Valid maps ---${NC}"
            write_map /tmp/r1.map "3.ox" "..." "..." "..."
            check_file "3x3 all empty"                        /tmp/r1.map

            write_map /tmp/r2.map "3.ox" "..o" ".o." "o.."
            check_file "3x3 with obstacles"                   /tmp/r2.map

            write_map /tmp/r3.map "1.ox" "."
            check_file "1x1 single empty cell"                /tmp/r3.map

            write_map /tmp/r4.map "2.ox" "....." "....."
            check_file "2 rows, 5 cols"                       /tmp/r4.map

            echo -e "  ${YELLOW}--- Invalid maps ---${NC}"
            write_map /tmp/ri1.map "3.ox" "....." "..." "....."
            check_file "unequal row lengths → invalid"        /tmp/ri1.map

            write_map /tmp/ri2.map "3.ox" "..." ".X." "..."
            check_file "invalid char 'X' → invalid"          /tmp/ri2.map

            write_map /tmp/ri3.map "3.ox" "..." "..."
            check_file "only 2 rows, header says 3 → invalid" /tmp/ri3.map

            echo -e "  ${YELLOW}--- Memory (NULL sentinel) ---${NC}"
            write_map /tmp/rm1.map "2.ox" ".o" ".."
            check_file "2-row map: grid[2] is NULL sentinel"  /tmp/rm1.map
            ;;

        "solve")
            echo -e "  ${YELLOW}--- Basic algorithm ---${NC}"
            write_map /tmp/s1.map "1.ox" "."
            check_file "1x1 all empty → fill it"              /tmp/s1.map

            write_map /tmp/s2.map "3.ox" "..." "..." "..."
            check_file "3x3 no obstacles → 3×3 square"        /tmp/s2.map

            write_map /tmp/s3.map "3.ox" "ooo" "ooo" "ooo"
            check_file "all obstacles → no fill"              /tmp/s3.map

            write_map /tmp/s4.map "3.ox" ".o." "..." "..."
            check_file "obstacle top-center → 2×2 square"    /tmp/s4.map

            write_map /tmp/s5.map "4.ox" "...." "...." "...." "...."
            check_file "4×4 no obstacles → 4×4 square"       /tmp/s5.map

            echo -e "  ${YELLOW}--- Top-left wins tiebreaker ---${NC}"
            write_map /tmp/s6.map "4.ox" "..o." "...." "...." "...."
            check_file "obstacle col 2 row 0 → left 2×2 wins" /tmp/s6.map

            echo -e "  ${YELLOW}--- Mixed ---${NC}"
            write_map /tmp/s7.map "5.ox" \
                "....." ".o..." "....." "....." "....."
            check_file "obstacle at (1,1) → 3×3 bottom-right" /tmp/s7.map

            write_map /tmp/subj.map "9.ox" \
                "..........................." \
                "....o......................"\
                "............o.............." \
                "..........................." \
                "....o......................"\
                "...............o..........." \
                "..........................." \
                "......o..............o....." \
                "..o.......o................"
            check_file "subject example (9 rows)"             /tmp/subj.map
            ;;

        "execute_bsq_main")
            echo -e "  ${YELLOW}--- File argument ---${NC}"
            write_map /tmp/m1.map "3.ox" "..." ".o." "..."
            check_file "file: valid 3×3 with obstacle"        /tmp/m1.map

            write_map /tmp/m2.map "4.ox" "...." "...." "...." "...."
            check_file "file: 4×4 no obstacles"               /tmp/m2.map

            echo -e "  ${YELLOW}--- stdin ---${NC}"
            check_stdin "stdin: valid 3×3"    "$(printf '3.ox\n...\n...\n...\n')"
            check_stdin "stdin: with obstacle" "$(printf '2.ox\n.o\n..\n')"
            check_stdin "stdin: invalid header (0 rows)" "$(printf '0.ox\n..\n')"
            check_stdin "stdin: duplicate chars"  "$(printf '2..x\n..\n..\n')"

            echo -e "  ${YELLOW}--- Error cases ---${NC}"
            printf "  ${CYAN}%-52s${NC}" "wrong argc (3 args) → exit non-zero"
            ./user_bsq a b 2>/dev/null; ec=$?
            if [ $ec -ne 0 ]; then
                echo -e "${GREEN}✓ (exit $ec)${NC}"; pass=$((pass+1))
            else
                echo -e "${RED}✗ (exit 0, expected non-zero)${NC}"; fail=$((fail+1))
            fi

            printf "  ${CYAN}%-52s${NC}" "file not found → exit non-zero"
            ./user_bsq /tmp/no_such_bsq_file_xyz 2>/dev/null; ec=$?
            if [ $ec -ne 0 ]; then
                echo -e "${GREEN}✓ (exit $ec)${NC}"; pass=$((pass+1))
            else
                echo -e "${RED}✗ (exit 0, expected non-zero)${NC}"; fail=$((fail+1))
            fi

            echo -e "  ${YELLOW}--- Valgrind ---${NC}"
            printf "  ${CYAN}%-52s${NC}" "[valgrind: no leaks on valid map]"
            if command -v valgrind &>/dev/null; then
                write_map /tmp/vg.map "3.ox" ".o." "..." ".o."
                vg=$(valgrind --leak-check=full --error-exitcode=42 -q \
                     ./user_bsq /tmp/vg.map 2>&1)
                if [ $? -ne 42 ]; then
                    echo -e "${GREEN}✓${NC}"; pass=$((pass+1))
                else
                    echo -e "${RED}✗${NC}"
                    echo "$vg" | grep -E "lost:|ERROR" | head -3 | sed 's/^/    /'
                    fail=$((fail+1))
                fi
            else
                echo -e "${YELLOW}skipped (valgrind not installed)${NC}"
            fi

            printf "  ${CYAN}%-52s${NC}" "[valgrind: no leaks on invalid map]"
            if command -v valgrind &>/dev/null; then
                write_map /tmp/vg2.map "3.ox" "....." "..." "....."
                vg=$(valgrind --leak-check=full --error-exitcode=42 -q \
                     ./user_bsq /tmp/vg2.map 2>&1)
                if [ $? -ne 42 ]; then
                    echo -e "${GREEN}✓${NC}"; pass=$((pass+1))
                else
                    echo -e "${RED}✗${NC}"
                    echo "$vg" | grep -E "lost:|ERROR" | head -3 | sed 's/^/    /'
                    fail=$((fail+1))
                fi
            else
                echo -e "${YELLOW}skipped (valgrind not installed)${NC}"
            fi
            ;;
    esac

    echo ""
    if [ $fail -eq 0 ]; then
        echo -e "${GREEN}All $pass tests passed ✓${NC}"
        return 0
    else
        echo -e "${RED}$fail/$((pass+fail)) tests failed${NC}"
        return 1
    fi
}

# ─── Show skeleton ───────────────────────────────────────────────────────────

show_skeleton() {
    local ex=$1
    echo -e "${YELLOW}What you need to write:${NC}"
    echo "────────────────────────────────────────────────────"
    eval "skel_${ex}"
    echo "────────────────────────────────────────────────────"
}

# ─── Show solution ───────────────────────────────────────────────────────────

show_solution() {
    local ex=$1
    echo ""
    echo -e "${YELLOW}Solution:${NC}"
    echo "────────────────────────────────────────────────────"
    eval "sol_${ex}"
    echo "────────────────────────────────────────────────────"
}

# ─── Run exercise ────────────────────────────────────────────────────────────

run_exercise() {
    local ex=$1
    local name
    name=$(get_name "$ex")

    setup_work_dir
    generate_bsq_c "$ex"

    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║  EXERCISE: ${CYAN}$name${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        show_skeleton "$ex"
        echo ""
        echo -e "  File: ${CYAN}$WORK_DIR/bsq.c${NC}"
        echo -e "  ${GREEN}(free_map, min3 and all other functions already implemented)${NC}"
        echo ""

        code "$WORK_DIR/bsq.c" 2>/dev/null &

        echo -e "${CYAN}Press ENTER when ready to test...${NC}"
        read -r

        echo ""
        run_tests "$ex"
        local result=$?
        echo ""

        if [ $result -eq 0 ]; then
            echo -e "${GREEN}✅ All tests pass!  [n] Next  [r] Retry  [b] Menu${NC}"
        else
            echo -e "${CYAN}[s] Solution  [h] Hint  [r] Retry  [n] Next  [b] Menu${NC}"
        fi

        echo -ne "${CYAN}Choice: ${NC}"
        read -r choice
        case $choice in
            s)
                show_solution "$ex"
                echo ""
                echo -e "${CYAN}[c] Copy solution to bsq.c  [r] Retry  [n] Next  [b] Menu${NC}"
                echo -ne "${CYAN}Choice: ${NC}"
                read -r c2
                if [ "$c2" = "c" ]; then
                    generate_bsq_c "none"
                    echo -e "${GREEN}Solution copied into bsq.c${NC}"
                    echo -e "${CYAN}ENTER...${NC}"; read -r
                fi
                [ "$c2" = "n" ] && return 1
                [ "$c2" = "b" ] && return 0
                ;;
            h)
                show_hint "$ex"
                echo -e "${CYAN}ENTER...${NC}"; read -r
                ;;
            n) return 1 ;;
            b) return 0 ;;
            q) exit 0 ;;
        esac
    done
}

# ─── Hints ───────────────────────────────────────────────────────────────────

show_hint() {
    local ex=$1
    echo ""
    echo -e "${YELLOW}Hint:${NC}"
    case $ex in
        "load_elements")
            echo -e "  ${GREEN}ret = fscanf(file, \"%d %c %c %c\",${NC}"
            echo -e "  ${GREEN}        &el->n_lines, &el->empty, &el->obstacle, &el->full);${NC}"
            echo -e "  Check ret == 4, then n_lines > 0, then all 3 chars distinct,"
            echo -e "  then all 3 chars >= 32.  Finally:"
            echo -e "  ${GREEN}if (getline(&line, &cap, file) == -1) { free(line); return (-1); }${NC}"
            echo -e "  ${GREEN}free(line); return (0);${NC}"
            ;;
        "load_map")
            echo -e "  ${GREEN}map->grid = malloc((map->height + 1) * sizeof(char *));${NC}"
            echo -e "  ${GREEN}map->grid[map->height] = NULL;   // sentinel${NC}"
            echo -e "  Inside loop:"
            echo -e "  ${GREEN}n = getline(&line, &cap, file);${NC}"
            echo -e "  ${GREEN}if (len > 0 && line[len-1] == '\\n') line[--len] = '\\0';${NC}"
            echo -e "  ${GREEN}map->grid[i] = line;   // store pointer, don't copy${NC}"
            echo -e "  On every error path: set map->height = i BEFORE calling free_map."
            ;;
        "solve")
            echo -e "  ${GREEN}dp = malloc(map->height * sizeof(int *));${NC}"
            echo -e "  ${GREEN}dp[i] = calloc(map->width, sizeof(int));${NC}"
            echo -e "  The formula:"
            echo -e "  ${GREEN}dp[i][j] = min3(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1;${NC}"
            echo -e "  Top-left of best square:"
            echo -e "  ${GREEN}sq.row = i - dp[i][j] + 1;  sq.col = j - dp[i][j] + 1;${NC}"
            echo -e "  Stamp: loop from sq.row/col to sq.row+sq.size / sq.col+sq.size"
            ;;
        "execute_bsq_main")
            echo -e "  ${GREEN}if (load_elements(file, &el) == -1) return (-1);${NC}"
            echo -e "  ${GREEN}if (load_map(file, &map, &el) == -1) return (-1);${NC}"
            echo -e "  ${GREEN}solve(&map, &el);${NC}"
            echo -e "  Print: ${GREEN}fprintf(stdout, \"%s\\n\", map.grid[i]);${NC}  (map is on stack — dot, not arrow)"
            echo -e "  In main: ${GREEN}FILE *f = fopen(av[1], \"r\");${NC}"
            echo -e "  Do NOT check execute_bsq's return in main — silent failure."
            ;;
    esac
    echo ""
}

# ─── Setup ───────────────────────────────────────────────────────────────────

setup_work_dir() {
    rm -rf "$WORK_DIR"
    mkdir -p "$WORK_DIR"
}

# ─── Theory sections ─────────────────────────────────────────────────────────

show_theory_format() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           BSQ — STRUCTS & HEADER FORMAT                      ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Three structs:${NC}"
    echo -e "  ${GREEN}t_elements${NC}  — what we read from the header line"
    echo -e "    int  n_lines;       // number of map rows"
    echo -e "    char empty;         // empty cell character"
    echo -e "    char obstacle;      // obstacle character"
    echo -e "    char full;          // fill character for the answer"
    echo ""
    echo -e "  ${GREEN}t_map${NC}       — the loaded grid"
    echo -e "    char **grid;        // array of strings (one per row)"
    echo -e "    int  width;         // columns (set from first row)"
    echo -e "    int  height;        // rows (= n_lines)"
    echo ""
    echo -e "  ${GREEN}t_square${NC}    — best square found by solve()"
    echo -e "    int size;           // side length"
    echo -e "    int row, col;       // top-left corner"
    echo ""
    echo -e "${YELLOW}Header format — read with fscanf:${NC}"
    echo -e "  ${GREEN}fscanf(file, \"%d %c %c %c\",${NC}"
    echo -e "  ${GREEN}       &el->n_lines, &el->empty, &el->obstacle, &el->full);${NC}"
    echo ""
    echo -e "  The ' ' between format specs matches zero or more whitespace."
    echo -e "  So both '9.ox' and '9 . o x' parse identically."
    echo -e "  n_lines=9, empty='.', obstacle='o', full='x'"
    echo ""
    echo -e "${YELLOW}After fscanf — consume the rest of the header line:${NC}"
    echo -e "  ${GREEN}getline(&line, &cap, file);   free(line);${NC}"
    echo -e "  fscanf stops after 'x' and leaves '\\n' in the buffer."
    echo -e "  Without this getline, load_map's first getline reads that '\\n'"
    echo -e "  as a blank first row → invalid map."
    echo ""
}

show_theory_validation() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           BSQ — VALIDATION RULES                             ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}load_elements checks (return -1 on failure):${NC}"
    echo -e "  ${RED}1.${NC} fscanf return value != 4  OR  n_lines <= 0"
    echo -e "  ${RED}2.${NC} Any two of the three chars are equal"
    echo -e "  ${RED}3.${NC} Any char has ASCII value < 32 (control character)"
    echo -e "  ${RED}4.${NC} getline fails to consume the rest of the header line"
    echo ""
    echo -e "${YELLOW}load_map checks (return -1, cleanup on failure):${NC}"
    echo -e "  ${RED}5.${NC} malloc for grid fails"
    echo -e "  ${RED}6.${NC} getline returns n <= 0 (EOF or error mid-map)"
    echo -e "  ${RED}7.${NC} Row is empty after stripping newline"
    echo -e "  ${RED}8.${NC} Row length differs from the first row's length"
    echo -e "  ${RED}9.${NC} Any character is neither empty nor obstacle"
    echo ""
    echo -e "${YELLOW}Cleanup pattern on load_map error:${NC}"
    echo -e "  ${GREEN}free(line);${NC}           // free the bad line"
    echo -e "  ${GREEN}map->height = i;${NC}      // tell free_map how many rows are valid"
    echo -e "  ${GREEN}free_map(map);${NC}        // free the valid rows + the grid array"
    echo -e "  ${GREEN}return (-1);${NC}"
    echo ""
    echo -e "${YELLOW}What happens on failure in execute_bsq:${NC}"
    echo -e "  execute_bsq returns -1 and prints NOTHING."
    echo -e "  main() does NOT check the return value — silent failure, exit 0."
    echo -e "  (File-not-found is the only case that returns exit 1.)"
    echo ""
    echo -e "${YELLOW}What the current bsq.c does NOT validate:${NC}"
    echo -e "  - Extra rows after the last expected row (ignored)"
    echo -e "  - Empty file beyond the map (ignored)"
    echo ""
}

show_theory_dp() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           BSQ — THE DP ALGORITHM                             ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Goal: find the largest all-empty square.${NC}"
    echo ""
    echo -e "${YELLOW}DP table — 2D array of int pointers:${NC}"
    echo -e "  ${GREEN}int **dp = malloc(height * sizeof(int *));${NC}"
    echo -e "  ${GREEN}dp[i]    = calloc(width, sizeof(int));${NC}"
    echo ""
    echo -e "  ${GREEN}dp[i][j]${NC} = side length of the largest all-empty square"
    echo -e "           whose BOTTOM-RIGHT corner is at (i, j)"
    echo ""
    echo -e "${YELLOW}Three rules:${NC}"
    echo -e "  ${RED}obstacle:${NC}            dp[i][j] = 0"
    echo -e "  ${GREEN}top/left edge:${NC}       dp[i][j] = 1"
    echo -e "  ${GREEN}interior:${NC}            dp[i][j] = min3("
    echo -e "                         dp[i-1][j],    ← above"
    echo -e "                         dp[i][j-1],    ← left"
    echo -e "                         dp[i-1][j-1]   ← diagonal"
    echo -e "                       ) + 1"
    echo ""
    echo -e "${YELLOW}Example (3×3, no obstacles):${NC}"
    echo -e "  dp:   1 1 1"
    echo -e "        1 2 2"
    echo -e "        1 2 ${GREEN}3${NC}   ← best at bottom-right (2,2), size 3"
    echo ""
    echo -e "${YELLOW}Tracking best — update ONLY when strictly greater:${NC}"
    echo -e "  ${GREEN}if (dp[i][j] > sq.size) {${NC}"
    echo -e "  ${GREEN}    sq.size = dp[i][j];${NC}"
    echo -e "  ${GREEN}    sq.row  = i - dp[i][j] + 1;   // top-left row${NC}"
    echo -e "  ${GREEN}    sq.col  = j - dp[i][j] + 1;   // top-left col${NC}"
    echo -e "  ${GREEN}}${NC}"
    echo ""
    echo -e "${YELLOW}Stamping the square:${NC}"
    echo -e "  Loop i from sq.row to sq.row + sq.size (exclusive)"
    echo -e "  Loop j from sq.col to sq.col + sq.size (exclusive)"
    echo -e "  ${GREEN}map->grid[i][j] = el->full;${NC}"
    echo ""
    echo -e "${YELLOW}Free dp afterwards:${NC}"
    echo -e "  Loop free(dp[i]) for each row, then free(dp)."
    echo ""
}

show_theory_tiebreaker() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           BSQ — TIEBREAKER (IMPLICIT)                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}bsq.c updates sq only when dp[i][j] is STRICTLY greater:${NC}"
    echo -e "  ${GREEN}if (dp[i][j] > sq.size)${NC}   ← not >=, just >"
    echo ""
    echo -e "  This means: among all squares of the same maximum size,"
    echo -e "  the FIRST one found in row-major scan wins."
    echo ""
    echo -e "${YELLOW}Row-major scan order:${NC}"
    echo -e "  i=0: j=0,1,2...   then i=1: j=0,1,2...   etc."
    echo -e "  → smaller i (top) comes first"
    echo -e "  → for same i, smaller j (left) comes first"
    echo ""
    echo -e "${YELLOW}The first bottom-right at (i,j) with size S implies:${NC}"
    echo -e "  top-left row = i - S + 1"
    echo -e "  top-left col = j - S + 1"
    echo -e "  Smaller (i,j) → smaller top-left → topmost, then leftmost."
    echo ""
    echo -e "${YELLOW}Result: bsq.c naturally prefers topmost-leftmost square.${NC}"
    echo -e "  No explicit tiebreaker code needed."
    echo ""
    echo -e "${RED}TRAP: if you use >= instead of >, you get bottom-rightmost.${NC}"
    echo -e "  Always use strictly greater-than."
    echo ""
}

show_theory_structure() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           BSQ — FULL STRUCTURE + EXAM TIMING                 ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}One file: bsq.c (plus optional bsq.h for the typedefs)${NC}"
    echo ""
    echo -e "  ${GREEN}① free_map()${NC}         free each grid row, then grid array, set NULL"
    echo -e "  ${GREEN}② min3()${NC}             helper — minimum of three ints"
    echo -e "  ${GREEN}③ load_elements()${NC}    fscanf header → fill t_elements"
    echo -e "  ${GREEN}④ load_map()${NC}         getline rows → fill t_map (store pointers)"
    echo -e "  ${GREEN}⑤ solve()${NC}            2D dp → find & stamp best square in t_map"
    echo -e "  ${GREEN}⑥ execute_bsq()${NC}      pipeline: load_elements → load_map → solve → print"
    echo -e "  ${GREEN}⑦ main()${NC}             stdin (ac==1) or file (ac==2)"
    echo ""
    echo -e "${YELLOW}execute_bsq() pipeline:${NC}"
    echo -e "  ${GREEN}t_elements el;  t_map map;${NC}   // on the stack"
    echo -e "  ${GREEN}load_elements(file, &el)${NC}      // header"
    echo -e "  ${GREEN}load_map(file, &map, &el)${NC}     // grid rows"
    echo -e "  ${GREEN}solve(&map, &el)${NC}              // DP"
    echo -e "  ${GREEN}fprintf(stdout, \"%s\\n\", map.grid[i])${NC}  // print (dot not arrow!)"
    echo -e "  ${GREEN}free_map(&map)${NC}                // cleanup"
    echo ""
    echo -e "${YELLOW}main() flow:${NC}"
    echo -e "  ${GREEN}if (ac == 1)   execute_bsq(stdin);${NC}"
    echo -e "  ${GREEN}if (ac == 2)   f = fopen(av[1], \"r\");  execute_bsq(f);  fclose(f);${NC}"
    echo -e "  ${GREEN}else           return (1);${NC}"
    echo ""
    echo -e "${YELLOW}Exam timing (~30 min total):${NC}"
    echo -e "  helpers + structs   3 min  |  solve (DP)       10 min"
    echo -e "  load_elements       5 min  |  execute_bsq+main  4 min"
    echo -e "  load_map            8 min  |  compile + test    3 min (no norm!)"
    echo ""
    echo -e "${YELLOW}Allowed functions:${NC}"
    echo -e "  malloc calloc free"
    echo -e "  fopen fclose getline fscanf"
    echo -e "  fprintf fputs stdout stdin"
    echo ""
}

# ─── Exercise chain ──────────────────────────────────────────────────────────

run_from_index() {
    local idx=$1
    while [ "$idx" -lt "${#exercises[@]}" ]; do
        run_exercise "${exercises[$idx]}"
        local r=$?
        [ $r -eq 1 ] && idx=$((idx + 1)) || break
    done
}

# ─── Main menu ───────────────────────────────────────────────────────────────

main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║       BSQ TRAINER — Biggest Square (42 Rank 05 / Lv.2)       ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}Theory (read first!):${NC}"
        echo -e "  ${GREEN}t1${NC}) Structs & header format  (t_elements, t_map, t_square, fscanf)"
        echo -e "  ${GREEN}t2${NC}) Validation rules         (what makes a map invalid + cleanup)"
        echo -e "  ${GREEN}t3${NC}) DP algorithm             (2D table, formula, stamp)"
        echo -e "  ${GREEN}t4${NC}) Tiebreaker               (implicit: strictly >, topmost-leftmost)"
        echo -e "  ${GREEN}t5${NC}) Full structure           (all functions + exam timing)"
        echo ""
        echo -e "${YELLOW}Exercises:${NC}"
        local i=1
        for ex in "${exercises[@]}"; do
            printf "  ${GREEN}%d${NC}) %s\n" $i "$(get_name "$ex")"
            ((i++))
        done
        echo ""
        echo -e "  ${GREEN}r${NC}) Random   ${GREEN}q${NC}) Quit"
        echo ""
        echo -ne "${CYAN}Choice: ${NC}"
        read -r choice

        case $choice in
            t1) show_theory_format;      echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t2) show_theory_validation;  echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t3) show_theory_dp;          echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t4) show_theory_tiebreaker;  echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t5) show_theory_structure;   echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            r)
                local rand=$((RANDOM % ${#exercises[@]}))
                run_from_index "$rand"
                ;;
            q) exit 0 ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#exercises[@]}" ]; then
                    run_from_index "$((choice - 1))"
                else
                    echo -e "${RED}Invalid choice${NC}"; sleep 1
                fi
                ;;
        esac
    done
}

main_menu
