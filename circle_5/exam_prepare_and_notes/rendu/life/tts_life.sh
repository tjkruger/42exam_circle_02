#!/bin/bash
# Text-to-speech narration for the Life solution.
# Usage:
#   bash tts_life.sh                  – start from the beginning
#   bash tts_life.sh [section]        – jump to a section
#   bash tts_life.sh list             – list all section names
#
# Sections: header init fill_board count_neighbors play print_board main
#
# Controls while running:
#   Ctrl+C  – stop completely
#   Ctrl+Z  – pause  (then type 'fg' to resume)
#
# Requires espeak-ng:  sudo apt install espeak-ng

VOICE="en"
SPEED=145   # words per minute – raise or lower to taste

SECTIONS="header init fill_board count_neighbors play print_board main"

if [[ "$1" == "list" ]]; then
    echo "Available sections:"
    for s in $SECTIONS; do echo "  $s"; done
    exit 0
fi

START="${1:-header}"
ACTIVE=false
[[ "$START" == "header" || -z "$1" ]] && ACTIVE=true

section() {
    local name="$1"
    if [[ "$ACTIVE" == false && "$name" == "$START" ]]; then
        ACTIVE=true
    fi
}

say() {
    [[ "$ACTIVE" == false ]] && return
    echo "$1"
    espeak-ng -v "$VOICE" -s "$SPEED" "$1" 2>/dev/null
}

pause() {
    [[ "$ACTIVE" == false ]] && return
    sleep "${1:-1}"
}

# ─────────────────────────────────────────────────────────────
section header
say "Let's walk through the Game of Life solution. We'll go file by file."
pause 1

# ══════════════════════════════════════════════════════════════
say "-- Header file: life dot h --"
pause 0.5

say "We include stdlib dot h for malloc and free, unistd dot h for read and STDIN underscore FILENO, stdio dot h for putchar and printf, and fcntl dot h for file control constants."
pause 0.5

say "Then we define the struct s underscore life, typedef'd to t underscore life. This single struct holds everything the program needs."
pause 0.3

say "The fields are: int width for the number of columns, int height for the number of rows, int iterations for how many generations to simulate, int i and int j for the current cursor position on the board, char dead for the character that represents a dead cell – which will be a space – char alive for the character that represents a living cell – which will be the character zero – int on underscore the underscore board which is used as a boolean flag to decide whether the cursor is currently drawing cells, and finally char double pointer grid which is the 2-D array of characters representing the board."
pause 1

# ══════════════════════════════════════════════════════════════
say "-- Source file: life dot c --"
pause 0.5

section init
say "-- Function: init underscore game --"
pause 0.3

say "This function is called from main and takes a pointer to t underscore life and the argv array. It returns int."
pause 0.3

say "First we parse the three command-line arguments. argv bracket one bracket goes into life arrow width via atoi. argv bracket two bracket goes into life arrow height. argv bracket three bracket goes into life arrow iterations."
pause 0.5

say "Then we set the character values. life arrow dead is set to a space character. life arrow alive is set to the character zero, which has ASCII value 48. life arrow i and life arrow j both start at zero – that is the top-left corner. life arrow on underscore the underscore board is set to zero, meaning we start in move-only mode, not drawing mode."
pause 0.5

say "Now we allocate the grid. We call malloc with life arrow height times the size of a char pointer. If malloc returns NULL, we return minus one."
pause 0.3

say "Then we loop i from zero to life arrow height. Inside the loop we call malloc with life arrow width times the size of char for each row. If any row allocation fails, we loop back from zero to i and free every row allocated so far, then free the outer pointer array, and return minus one."
pause 0.3

say "If allocation succeeds, we fill every cell in that row with life arrow dead using a j loop from zero to life arrow width. After all rows are allocated and filled, we return zero."
pause 1

# ──────────────────────────────────────────────────────────────
section fill_board
say "-- Function: fill underscore board --"
echo ""
echo "  int fill_board(t_life *life)"
echo "  {"
echo "      char buffer;  int flag = 0;"
echo "      while (read(STDIN_FILENO, &buffer, 1) == 1)"
echo "      {"
echo "          switch (buffer) {"
echo "          case 'w': if (i > 0) i--;          // up"
echo "          case 's': if (i < height-1) i++;   // down"
echo "          case 'a': if (j > 0) j--;          // left"
echo "          case 'd': if (j < width-1) j++;    // right"
echo "          case 'x': on_the_board = !on_the_board;"
echo "          default:  flag = 1;"
echo "          }"
echo "          if (flag) continue;"
echo "          if (on_the_board == 1)"
echo "              grid[i][j] = alive;"
echo "      }"
echo "  }"
echo ""
pause 0.3

say "fill underscore board paints the initial state of the board."
pause 0.3

say "The outer loop: read with STDIN underscore FILENO, buffer address, byte count one. read is a raw POSIX system call to the kernel. It returns the number of bytes actually transferred. We loop as long as it returns exactly one."
pause 0.4

say "Three things stop the loop. read returns zero at end of file – when the exam tester closes the pipe or you press Control-D. read returns minus one on any kernel error – broken pipe, interrupted signal. Any other non-one return also exits. All three break the while condition cleanly without needing special error handling code."
pause 0.5

say "The switch handles five keys. w decrements i upward, bounded by zero. s increments i downward, bounded by height minus one. a decrements j leftward, bounded by zero. d increments j rightward, bounded by width minus one. x flips on underscore the underscore board with logical NOT. The default case sets flag to one."
pause 0.5

say "After the switch, if flag is one, continue skips to the next read call. No drawing happens for unrecognised bytes."
pause 0.3

say "If flag is zero AND on underscore the underscore board is one, we stamp the current cell as alive. The cursor position does not change here – the movement already happened in the switch."
pause 1

# ──────────────────────────────────────────────────────────────
section count_neighbors
say "-- Function: count underscore neighbors --"
echo ""
echo "  int count_neighbors(t_life *life, int row, int col)"
echo "  {"
echo "      int count = 0;"
echo "      for (di = -1; di <= 1; di++)"
echo "          for (dj = -1; dj <= 1; dj++)"
echo "          {"
echo "              if (di == 0 && dj == 0) continue;  // skip self"
echo "              ni = row + di;  nj = col + dj;"
echo "              if (ni >= 0 && ni < height          // bounds"
echo "               && nj >= 0 && nj < width)"
echo "                  if (grid[ni][nj] == alive) count++;"
echo "          }"
echo "      return count;"
echo "  }"
echo ""
pause 0.3

say "count underscore neighbors counts how many of the eight surrounding cells are alive."
pause 0.3

say "count starts at zero. The double loop with di and dj each ranging from minus one to one produces nine offset pairs. Visualise a 3-by-3 grid centred on the current cell: we visit every cell in that 3-by-3, which gives us the eight neighbours plus the centre."
pause 0.5

say "When both di and dj are zero, we are at the centre – the cell itself. We skip it with continue so we do not count a cell as its own neighbour."
pause 0.3

say "For every other offset pair, we compute ni as row plus di and nj as col plus dj. These are the neighbour's coordinates. The board does not wrap around at edges – a cell at row zero has no neighbours above it. The bounds check filters all out-of-range coordinates: ni must be zero or greater and strictly less than height, nj must be zero or greater and strictly less than width. If either fails, we skip without counting."
pause 0.5

say "If the neighbour is in bounds and its value equals life arrow alive, we increment count. After both loops we return count. The maximum possible return value is eight, for a cell completely surrounded by live cells."
pause 1

# ──────────────────────────────────────────────────────────────
section play
say "-- Function: play – one generation step --"
pause 0.3

say "play takes a pointer to t underscore life and returns int. It computes one full generation."
echo ""
echo "  int play(t_life *life)"
echo "  {"
echo "      char **temp = malloc(height * sizeof(char *));"
echo "      for i: temp[i] = malloc(width * sizeof(char));"
echo ""
echo "      for (i = 0; i < height; i++)"
echo "          for (j = 0; j < width; j++)"
echo "          {"
echo "              neighbors = count_neighbors(life, i, j);"
echo "              if (grid[i][j] == alive)"
echo "              {"
echo "                  if (neighbors == 2 || neighbors == 3)"
echo "                      temp[i][j] = alive;  // survives"
echo "                  else"
echo "                      temp[i][j] = dead;   // dies"
echo "              }"
echo "              else  // cell is dead"
echo "              {"
echo "                  if (neighbors == 3)"
echo "                      temp[i][j] = alive;  // born"
echo "                  else"
echo "                      temp[i][j] = dead;   // stays dead"
echo "              }"
echo "          }"
echo "      for i: free(grid[i]);  free(grid);"
echo "      life->grid = temp;"
echo "      return (0);"
echo "  }"
echo ""
pause 0.3

say "We allocate a separate temp grid first. We cannot modify the grid in place because every cell's new state depends on the current state of its neighbours. If we overwrote cell i comma j before computing cell i comma j plus one, that next cell would see the already-updated value and apply the wrong rule."
pause 0.5

say "The double loop visits every cell. For each cell we call count underscore neighbors to get the live neighbour count."
pause 0.3

say "Then we apply the four Conway rules. Rule one: a live cell with exactly two or three live neighbours survives. Fewer than two is isolation – the cell is too alone. More than three is overcrowding. Only two or three keeps it alive."
pause 0.4

say "Rule two: a live cell with fewer than two or more than three neighbours dies. We write dead into temp."
pause 0.3

say "Rule three: a dead cell with exactly three live neighbours is born. Three is the only birth count."
pause 0.3

say "Rule four: a dead cell with any other neighbour count stays dead."
pause 0.4

say "After filling temp, we free every row of the old grid, then free the outer grid pointer array. Then we set life arrow grid to temp. temp now is the grid for the next iteration. Return zero."
pause 1

# ──────────────────────────────────────────────────────────────
section print_board
say "-- Function: print underscore board --"
echo ""
echo "  void print_board(t_life *life)"
echo "  {"
echo "      for (i = 0; i < height; i++)"
echo "      {"
echo "          for (j = 0; j < width; j++)"
echo "              putchar(grid[i][j]);  // one char at a time"
echo "          putchar('\\n');            // manual newline"
echo "      }"
echo "  }"
echo ""
pause 0.3

say "print underscore board outputs the final grid row by row."
pause 0.3

say "We use putchar, not printf percent s. This is the critical difference from B S Q. In B S Q the grid rows came from getline, which allocates a buffer and writes a null terminator at the end of each row. The percent s format specifier walks forward from the pointer until it hits that backslash zero – it knows exactly where the string ends."
pause 0.5

say "In Life, the rows came from plain malloc calls that we filled ourselves with space or zero characters. There is no null terminator anywhere. If we called printf percent s on a Life row, the percent s formatter would keep reading bytes past the end of our array into whatever memory happens to follow – we could print garbage characters, corrupt output, or trigger a segfault."
pause 0.5

say "putchar bypasses the string abstraction entirely. We tell it exactly how many characters to print by counting from zero to width. Each putchar call outputs one character and moves on. After the inner loop ends at exactly width characters, we call putchar with a newline to finish the row. No null terminator needed, no risk of reading past the array."
pause 1

# ──────────────────────────────────────────────────────────────
section main
say "-- Function: main --"
pause 0.3

say "main takes int ac for argument count and char double pointer av for the argument values."
pause 0.3

say "If ac does not equal four – meaning we did not get exactly three arguments: width, height, and iterations – we return one immediately."
pause 0.3

say "We declare t underscore life life on the stack. We call init underscore game with the address of life and av. If it returns minus one, we return one."
pause 0.3

say "We call fill underscore board with the address of life. If it returns minus one, we return one."
pause 0.3

say "Now the simulation loop: i runs from zero to life dot iterations. On each iteration we call play with the address of life. If play returns minus one, we free each row, free the grid, and return minus one."
pause 0.3

say "After all generations are simulated, we call print underscore board to output the final state."
pause 0.3

say "Then we clean up: we loop i from zero to life dot height and free each row, then free life dot grid. We return zero."
pause 1

say "That's the full Game of Life solution. Good luck on the exam!"
