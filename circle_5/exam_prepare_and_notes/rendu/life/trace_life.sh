#!/bin/bash
# Trace-style walkthrough of Game of Life – follows execution from main() downward.
# Every step shows the code line visually, then says what it does.
#
# Usage:  bash trace_life.sh
# Requires espeak-ng:  sudo apt install espeak-ng

VOICE="en"
SPEED=140

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
echo "  Game of Life – execution trace starting from main()"
echo "════════════════════════════════════════════════════════"
pause 1

# ── main ──────────────────────────────────────────────────
show "main" "int main(int ac, char **av)"
say "Entry point. We expect exactly four arguments total: the program name plus width, height, and iterations."
pause

show "main" "if (ac != 4) return (1);"
say "ac counts the program name as argument zero, so ac equals four means three user arguments. If we got anything else, return one immediately – no partial setup."
pause

show "main" "t_life life;"
say "We declare the life struct on the stack. All fields are uninitialised at this point – we fill them in init underscore game."
pause

show "main" "if (init_game(&life, av) == -1) return (1);"
say "We call init underscore game to parse the arguments and allocate the grid. If anything goes wrong it returns minus one and we exit."
pause 1

# ── init_game ─────────────────────────────────────────────
echo ""
echo "  ── entering init_game(&life, av) ────────────────────"
pause 0.5

show "init_game" "life->width  = atoi(av[1]);"
show "init_game" "life->height = atoi(av[2]);"
show "init_game" "life->iterations = atoi(av[3]);"
say "atoi converts the string arguments to integers. No error checking here – if the user passes a non-number, atoi returns zero, and the board will be zero-sized."
pause

show "init_game" "life->dead  = ' ';   life->alive = '0';"
say "We set the two cell characters. A dead cell is a space character. A living cell is the digit zero, which has ASCII code 48. Note this is the character zero, not the integer zero."
pause

show "init_game" "life->i = 0;  life->j = 0;  life->on_the_board = 0;"
say "The cursor starts at row zero, column zero – top-left. on underscore the underscore board is zero, meaning we start in move-only mode. The cursor moves but does not draw."
pause

show "init_game" "life->grid = malloc(life->height * sizeof(char *));"
say "We allocate the outer array of row pointers."
pause

show "init_game" "if (!life->grid) return (-1);"
say "If malloc fails, we return minus one immediately. Nothing to free yet – the grid pointer itself failed."
pause

show "init_game" "for i: grid[i] = malloc(life->width * sizeof(char));"
say "For each row we allocate a flat array of chars. Note: plain malloc, no null terminator at the end. These are bare character arrays, NOT strings."
pause

show "init_game" "    if (!grid[i]) { free previous rows; free grid; return -1; }"
say "If a row allocation fails, we must free every row we already allocated before this one, then free the outer array. Forgetting either of these is a memory leak."
pause

show "init_game" "    for j: grid[i][j] = life->dead;"
say "We fill every cell in the new row with the dead character – a space. The board starts completely empty."
pause

show "init_game" "return (0);"
say "All allocations succeeded, board is initialised. Return zero."
pause 1

# ── fill_board ────────────────────────────────────────────
echo ""
echo "  ── entering fill_board(&life) ───────────────────────"
pause 0.5

show "fill_board" "char buffer;  int flag = 0;"
say "buffer holds one byte at a time. flag signals when we read an unrecognised character – more on why in a moment."
pause

show "fill_board" "while (read(STDIN_FILENO, &buffer, 1) == 1)"
say "read is a low-level POSIX system call. We ask the kernel to copy exactly one byte from standard input into buffer. It returns the number of bytes actually read. The loop continues as long as read returns exactly one."
pause

show "fill_board" "── WHY read() can fail or stop ──"
say "read returns zero when the input stream closes – end of file. This happens when you press Control-D in a terminal, or when a pipe writing to us finishes. read returns minus one on a real error, such as a signal interrupting it, or the file descriptor being closed underneath us. Both zero and minus one break the while condition, ending the loop cleanly."
pause

show "fill_board" "switch (buffer)"
say "We inspect the byte we just read."
pause

show "fill_board" "  case 'w': if (i > 0) i--;   // move cursor up"
say "w moves the cursor one row up. We check that i is already greater than zero so we do not go out of bounds."
pause

show "fill_board" "  case 's': if (i < height-1) i++;   // move cursor down"
say "s moves the cursor down. We check against height minus one so we cannot go past the last row."
pause

show "fill_board" "  case 'a': if (j > 0) j--;   // move cursor left"
say "a moves the cursor left, guarded by j greater than zero."
pause

show "fill_board" "  case 'd': if (j < width-1) j++;   // move cursor right"
say "d moves the cursor right, guarded by width minus one."
pause

show "fill_board" "  case 'x': on_the_board = !on_the_board;   // toggle draw"
say "x flips the drawing mode on or off. When on underscore the underscore board is one, every movement character also paints the cell the cursor lands on as alive."
pause

show "fill_board" "  default:  flag = 1;"
say "Any other character – a letter we do not recognise, a control character, anything – sets flag to one."
pause

show "fill_board" "if (flag) continue;"
say "If flag is one we skip the drawing step and go back to read the next byte. Importantly, we do not reset flag here – actually wait, flag starts at zero each iteration? No, flag is declared once before the loop and set to one in default. Let me be precise: flag is set once on the first unrecognised character and stays one forever after. But because we continue on flag, we always skip drawing after the first unknown character. The real purpose of flag is to avoid drawing when the read character was not a movement or toggle command. Any non w s a d x character should not trigger a draw."
pause

show "fill_board" "if (on_the_board == 1) grid[i][j] = alive;"
say "If we are in drawing mode, we stamp the current cursor position as alive. This happens after any recognised movement key – so pressing w while drawing will move up AND mark the cell alive."
pause 1

# ── play loop ─────────────────────────────────────────────
echo ""
echo "  ── back in main – simulation loop ──────────────────"
pause 0.5

show "main" "for (int i = 0; i < life.iterations; i++)"
say "We call play once per generation. If iterations is zero, we skip the loop entirely and print the initial board unchanged."
pause

show "main" "    if (play(&life) == -1) { free; return -1; }"
say "If play fails – which only happens if a malloc inside it fails – we clean up the grid and exit."
pause 1

# ── play ──────────────────────────────────────────────────
echo ""
echo "  ── entering play(&life) ─────────────────────────────"
pause 0.5

show "play" "char **temp = malloc(height * sizeof(char *));"
say "We allocate a separate temporary grid. We cannot apply the rules in place because each cell's new state depends on the current state of its neighbours. If we overwrote cells as we go, later cells would see the new state of earlier cells instead of the old state – wrong results."
pause

show "play" "for i: temp[i] = malloc(width * sizeof(char));"
say "Allocate each row of temp. Same size as the main grid."
pause

show "play" "── GAME LOGIC LOOP ──  for i, for j:"
say "We iterate over every cell in the grid. For each cell we first call count underscore neighbors."
pause

# ── count_neighbors ───────────────────────────────────────
echo ""
echo "  ── entering count_neighbors(&life, row, col) ────────"
pause 0.5

show "count_neighbors" "int count = 0;"
say "We start with zero neighbours."
pause

show "count_neighbors" "for di = -1 to 1:  for dj = -1 to 1:"
say "We use two nested loops with offsets di and dj ranging from minus one to one. This generates nine pairs: all eight surrounding cells plus the cell itself."
pause

show "count_neighbors" "    if (di == 0 && dj == 0) continue;"
say "When both offsets are zero, we are looking at the cell itself. We skip it with continue."
pause

show "count_neighbors" "    ni = row + di;   nj = col + dj;"
say "We compute the neighbour coordinates."
pause

show "count_neighbors" "    if (ni >= 0 && ni < height && nj >= 0 && nj < width)"
say "Bounds check. The board does not wrap around – cells outside the grid simply do not count. This check filters out all eight cases where a corner or edge cell would look outside the array."
pause

show "count_neighbors" "        if (grid[ni][nj] == alive) count++;"
say "If the neighbour is within bounds and is alive, we increment count."
pause

show "count_neighbors" "return count;"
say "We return the total number of live neighbours. The maximum possible is eight."
pause 1

# ── back in play: apply Conway rules ──────────────────────
echo ""
echo "  ── back in play – applying Conway's rules ───────────"
pause 0.5

show "play" "── IF alive:  neighbors == 2 || neighbors == 3"
say "Conway rule for a live cell. If it has exactly two or three live neighbours, it survives to the next generation. Any fewer means isolation – it dies. Any more means overcrowding – it also dies."
pause

show "play" "    → temp[i][j] = alive   (survives)"
say "Survival case: we write alive into the temp grid."
pause

show "play" "── IF alive:  neighbors < 2 or neighbors > 3"
say "Death case for a live cell. Fewer than two neighbours: loneliness. More than three: overcrowding. Either way the cell dies."
pause

show "play" "    → temp[i][j] = dead    (dies)"
say "We write dead into temp."
pause

show "play" "── IF dead:   neighbors == 3"
say "Conway rule for a dead cell. Exactly three live neighbours causes a new cell to be born. This is the only birth condition."
pause

show "play" "    → temp[i][j] = alive   (born)"
say "Birth case: we write alive into temp."
pause

show "play" "── IF dead:   neighbors != 3"
say "Any other neighbour count for a dead cell: the cell stays dead."
pause

show "play" "    → temp[i][j] = dead    (stays dead)"
say "No change."
pause 1

show "play" "for i: free(grid[i]);   free(grid);"
say "We free every row of the old grid and then the outer pointer array."
pause

show "play" "life->grid = temp;"
say "We point the struct's grid field at the new temp grid. temp now IS the current grid. We return zero."
pause 1

# ── print_board ───────────────────────────────────────────
echo ""
echo "  ── entering print_board(&life) ──────────────────────"
pause 0.5

show "print_board" "for i: for j: putchar(grid[i][j]);"
say "We print one character at a time using putchar."
pause

show "print_board" "putchar('\\n')  after each row"
say "After each row we manually add a newline."
pause

show "print_board" "── WHY putchar and NOT printf(\"%s\") ──"
say "This is the critical difference from B S Q. In B S Q, every grid row is a string that getline allocated and null-terminated – it has a backslash zero at the end, so percent s knows where to stop. In Life, the rows come from plain malloc calls that we then filled with space or zero characters. There is no null terminator. If we passed such a row to percent s, it would print past the end of our array, reading whatever bytes happen to follow in memory – garbage output, or a crash. putchar sidesteps this completely: we control exactly how many characters we print by using the width counter."
pause 1

# ── back in main: cleanup ─────────────────────────────────
echo ""
echo "  ── back in main – cleanup ───────────────────────────"
pause 0.5

show "main" "for i: free(grid[i]);   free(grid);"
say "We free every row and then the outer array. Same pattern as everywhere else in the program."
pause

show "main" "return (0);"
say "Clean exit."
pause 1

echo ""
echo "════════════════════════════════════════════════════════"
echo "  End of Game of Life trace."
echo "════════════════════════════════════════════════════════"
say "End of the Game of Life execution trace. Good luck on the exam."
