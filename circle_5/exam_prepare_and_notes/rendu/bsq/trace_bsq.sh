#!/bin/bash
# Trace-style walkthrough of BSQ – follows execution from main() downward.
# Every step shows the code line visually, then says what it does.
#
# Usage:  bash trace_bsq.sh
# Requires espeak-ng:  sudo apt install espeak-ng

VOICE="en"
SPEED=120

show() {
    local func="$1"
    local code="$2"
    printf "\n\033[36m[%-22s]\033[0m  %s\n" "$func" "$code"
}

say() {
    echo "    → $*"
    espeak-ng -v "$VOICE" -s "$SPEED" "$*" 2>/dev/null
}

pause() { sleep "${1:-0.8}"; }

# ════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════"
echo "  BSQ – execution trace starting from main()"
echo "════════════════════════════════════════════════════════"
pause 1

# ── main ──────────────────────────────────────────────────
show "main" "int main(int ac, char **av)"
say "Entry point. ac is the argument count, av is the argument vector."
pause

show "main" "if (ac == 1)"
say "If no arguments were given, the map comes from standard input – the keyboard or a pipe. We call execute underscore bsq directly with stdin."
pause

show "main" "    execute_bsq(stdin);"
say "stdin is a FILE pointer that is always open. No fopen needed. execute underscore bsq works identically regardless of whether the file is a real file or stdin."
pause

show "main" "else if (ac == 2)"
say "If exactly one argument was given, it is a filename."
pause

show "main" "    FILE *f = fopen(av[1], \"r\");"
say "We try to open the file av bracket one bracket in read mode. fopen returns NULL if the file does not exist, has no read permission, or any other OS-level error."
pause

show "main" "    if (!f) return (1);"
say "If f is NULL – meaning fopen failed – we return one immediately. We do not call execute underscore bsq with a NULL pointer. That would be undefined behaviour."
pause

show "main" "    execute_bsq(f);  fclose(f);"
say "If the file opened successfully, we call execute underscore bsq with the file pointer, then close the file with fclose to release the OS file descriptor."
pause

show "main" "else return (1);"
say "If ac is anything other than one or two – wrong number of arguments – we return one. The program does not support multiple files."
pause 1.2

# ── execute_bsq ───────────────────────────────────────────
echo ""
echo "  ── entering execute_bsq(file) ──────────────────────"
pause 0.5

show "execute_bsq" "t_elements el;  t_map map;"
say "We declare two structs on the stack. el will hold the four values from the header line. map will hold the grid."
pause

show "execute_bsq" "if (load_elements(file, &el) == -1)"
say "First call: load underscore elements reads and validates the header line from the file."
pause

# ── load_elements ─────────────────────────────────────────
echo ""
echo "  ── entering load_elements(file, el) ────────────────"
pause 0.5

show "load_elements" "ret = fscanf(file, \"%d %c %c %c\", ...);"
say "fscanf reads one integer and three characters from the file in a single call. The format string percent d space percent c space percent c space percent c matches: a number, then three printable characters separated by spaces. The return value is the count of items successfully assigned."
pause

show "load_elements" "── CHECK 1 ──  ret != 4 || el->n_lines <= 0"
say "Check one. If fscanf did not assign all four values, or if n underscore lines is zero or negative, the header is malformed. Return minus one."
pause

show "load_elements" "── CHECK 2 ──  empty==obstacle || empty==full || obstacle==full"
say "Check two. All three characters must be distinct from each other. If any two are the same we cannot tell cells apart. Return minus one."
pause

show "load_elements" "── CHECK 3 ──  empty < 32 || obstacle < 32 || full < 32"
say "Check three. ASCII values below 32 are control characters – unprintable things like newline or tab. We require all three characters to have a code of 32 or higher, meaning they are visible printable characters."
pause

show "load_elements" "── CHECK 4 ──  getline(&line, &cap, file)"
say "Check four. fscanf stopped after the four values but left the rest of the header line in the file buffer. We call getline to read and discard whatever is left – typically any trailing whitespace or a newline – so the next read call starts cleanly at the first map row. If getline returns minus one it means the file ended unexpectedly, so we free line and return minus one."
pause

show "load_elements" "free(line);  return (0);"
say "All four checks passed. We free the line buffer getline allocated – we do not need it – and return zero for success."
pause 1

# ── load_map ──────────────────────────────────────────────
echo ""
echo "  ── entering load_map(file, map, el) ────────────────"
pause 0.5

show "load_map" "map->height = el->n_lines;  map->width = -1;"
say "We set height from the value parsed in the header. Width starts at minus one because we do not know it yet – we will learn it from the first row."
pause

show "load_map" "map->grid = malloc((map->height + 1) * sizeof(char *));"
say "We allocate an array of char pointers. We allocate height PLUS one slots. The extra slot holds a NULL sentinel – a safety marker at the end that lets any code walking the array know where it ends without needing a separate count."
pause

show "load_map" "map->grid[map->height] = NULL;"
say "We immediately write NULL into the last slot. This is the sentinel."
pause

show "load_map" "while (i < map->height)  →  getline(&line, &cap, file)"
say "We loop once per expected row. getline reads the next full line from the file, allocates a buffer on the heap to hold it, and stores the byte count in n."
pause

show "load_map" "    if (n <= 0) { free(line); map->height = i; free_map; return -1; }"
say "If n is zero or negative, the file ended before we got all the rows. We set map arrow height to i – the number of rows successfully stored – so that free underscore map knows how many pointers in the array are valid and need freeing. Then we call free underscore map and return minus one."
pause

show "load_map" "    if (line[len-1] == '\\n')  line[--len] = '\\0';"
say "getline includes the trailing newline in the buffer. We strip it by replacing it with a null terminator and decrementing len. This makes the row a proper C string."
pause

show "load_map" "    if (len == 0) { cleanup; return -1; }"
say "After stripping the newline, if len is zero the line was blank. A blank row in the map is invalid."
pause

show "load_map" "    if (map->width < 0)  map->width = len;"
say "First row: we learn the width from how many characters it has."
pause

show "load_map" "    else if (len != map->width) { cleanup; return -1; }"
say "Subsequent rows: if the length differs from the first row, the map is not rectangular. Return minus one."
pause

show "load_map" "    while (j < len) check line[j] != empty && != obstacle"
say "We validate every character. If any character is not the empty symbol and not the obstacle symbol, it is an illegal character. Return minus one."
pause

show "load_map" "    map->grid[i] = line;  i++;"
say "All checks passed. We store the pointer directly – we do NOT free line here. getline allocated it on the heap and it now becomes one row of our grid. We own it and will free it later in free underscore map."
pause 1

# ── solve ─────────────────────────────────────────────────
echo ""
echo "  ── entering solve(map, el) ──────────────────────────"
pause 0.5

show "solve" "int **dp = malloc(map->height * sizeof(int *));"
say "We allocate a 2-D table of integers – same dimensions as the map. dp bracket i bracket bracket j bracket will hold the side length of the largest all-empty square whose bottom-right corner is at cell i comma j."
pause

show "solve" "dp[i] = calloc(map->width, sizeof(int));"
say "calloc initialises every int to zero. We use calloc instead of malloc so we do not need a separate memset."
pause

show "solve" "── DP RULE 1 ──  grid[i][j] == obstacle  →  dp[i][j] = 0"
say "Rule one: obstacle cells cannot be part of any square, so their dp value is zero."
pause

show "solve" "── DP RULE 2 ──  i == 0 || j == 0  →  dp[i][j] = 1"
say "Rule two: cells on the top edge or left edge can only anchor a 1-by-1 square. They have no cells above or to the left to extend from."
pause

show "solve" "── DP RULE 3 ──  dp[i][j] = min3(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1"
say "Rule three, the key formula. We look at three neighbours: the cell directly above, the cell directly to the left, and the cell diagonally above-left. The minimum of those three dp values tells us the largest square all three corners can support. We add one for the current cell itself. Think of it this way: if any of the three neighbours can only support a square of size two, then the current cell can only extend that to size three – we are limited by the weakest link."
pause 1

show "solve" "if (dp[i][j] > sq.size)  →  update sq"
say "Whenever we compute a dp value larger than the current best, we update the best square record. The top-left corner is at row i minus dp bracket i bracket bracket j bracket plus one, and column j minus dp bracket i bracket bracket j bracket plus one. We derive it from the bottom-right corner."
pause

show "solve" "map->grid[i][j] = el->full;  (stamp loop)"
say "After finding the best square, we loop over every cell inside it and overwrite the character with the full symbol. This mutates the grid in place."
pause 1

# ── back in execute_bsq: print ─────────────────────────────
echo ""
echo "  ── back in execute_bsq – printing the result ────────"
pause 0.5

show "execute_bsq" "fprintf(stdout, \"%s\\n\", map.grid[i]);"
say "This is the print loop. We call fprintf with the format string percent s backslash n."
pause

show "execute_bsq" "WHY %s works here:"
say "Each map dot grid bracket i bracket is a string that getline allocated and null-terminated. When we stripped the newline in load underscore map we wrote a backslash zero at the end. The percent s format specifier tells fprintf to print characters one by one until it hits a backslash zero. Then our backslash n in the format string adds the line break. This is why percent s is safe here."
pause

show "execute_bsq" "CONTRAST with Life's print_board:"
say "In the Game of Life, the grid rows come from plain malloc calls that we fill with space or zero characters. There is no null terminator at the end. Using percent s on those rows would read past the end of the allocated memory into unknown territory – undefined behaviour. That is why Life uses putchar one character at a time and adds its own newline. The rule of thumb: if a string came from getline or strdup or any function that guarantees null termination, percent s is fine. If it came from raw malloc and you filled it yourself, use putchar or fwrite."
pause 1

show "execute_bsq" "free_map(&map);  return (0);"
say "We call free underscore map to release every row and then the grid pointer array. Then return zero."
pause 1

echo ""
echo "════════════════════════════════════════════════════════"
echo "  End of BSQ trace."
echo "════════════════════════════════════════════════════════"
say "End of the B S Q execution trace. Good luck on the exam."
