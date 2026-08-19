#!/bin/bash
# Text-to-speech narration for the BSQ solution.
# Usage:
#   bash tts_bsq.sh                  – start from the beginning
#   bash tts_bsq.sh [section]        – jump to a section
#   bash tts_bsq.sh list             – list all section names
#
# Sections: header free_map load_elements load_map min3 solve execute_bsq main
#
# Controls while running:
#   Ctrl+C  – stop completely
#   Ctrl+Z  – pause  (then type 'fg' to resume)
#
# Requires espeak-ng:  sudo apt install espeak-ng

VOICE="en"
SPEED=145   # words per minute – raise or lower to taste

SECTIONS="header free_map load_elements load_map min3 solve execute_bsq convert_file_pointer main"

if [[ "$1" == "list" ]]; then
    echo "Available sections:"
    for s in $SECTIONS; do echo "  $s"; done
    exit 0
fi

# If a section argument is given, skip everything before it
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

pause() {
    sleep "${1:-1}"
}

# ─────────────────────────────────────────────────────────────
section header
say "Let's walk through the B S Q solution. We'll go file by file."
pause 1

# ══════════════════════════════════════════════════════════════
say "-- Header file: bsq dot h --"
pause 0.5

say "At the top we have the include guard. Hash ifndef B S Q underscore H says: if the macro B S Q H is not defined yet, then define it now. This prevents the header from being included twice."
pause 0.5

say "We set the POSIX C source version to 200809 L. This unlocks functions like getline that are not part of standard C but are available on POSIX systems."
pause 0.5

say "Then we include stdio dot h for file input and output, stdlib dot h for malloc and free, and string dot h for string utilities."
pause 0.5

say "Now we define three structs."
pause 0.3

say "First: s underscore elements, typedef'd to t underscore elements. It holds the characters that describe the map format. Four fields: an int called n underscore lines, which is the number of rows expected in the map, and three chars: empty for the empty cell character, obstacle for the blocked cell character, and full for the character we stamp onto the biggest square."
pause 0.5

say "Second: s underscore map, typedef'd to t underscore map. This represents the grid we load from the file. It has a double pointer to char called grid – think of it as an array of strings, one per row – an int called width, and an int called height."
pause 0.5

say "Third: s underscore square, typedef'd to t underscore square. This records the best square the algorithm found. Three ints: size for the side length, row for the top-left row index, and col for the top-left column index."
pause 0.5

say "Finally two function declarations: execute underscore bsq takes a FILE pointer and returns int, and convert underscore file underscore pointer takes a char pointer filename and returns int."
pause 1

# ══════════════════════════════════════════════════════════════
say "-- Source file: bsq dot c --"
pause 0.5

section free_map
say "-- Function: free underscore map --"
pause 0.3

say "free underscore map is static – only visible inside this file – returns void, and takes a pointer to t underscore map called map."
pause 0.3

say "We declare int i and set it to zero."
pause 0.3

say "Then we enter a while loop: while i is less than map arrow height. On each iteration we call free on map arrow grid bracket i bracket – this frees the string for that row. Then we increment i."
pause 0.3

say "After the loop we call free on map arrow grid – that frees the array of pointers itself. Then we set map arrow grid to NULL to avoid a dangling pointer."
pause 1

# ──────────────────────────────────────────────────────────────
section load_elements
say "-- Function: load underscore elements --"
pause 0.3

say "load underscore elements is static, returns int, and takes a FILE pointer called file and a pointer to t underscore elements called el."
pause 0.3

say "We declare: a char pointer called line, a size underscore t called cap, and an int called ret. We set line to NULL and cap to zero."
pause 0.3

say "The key line is the fscanf call. We call fscanf on file with the format string: percent d, space, percent c, space, percent c, space, percent c. This tells fscanf to read one integer followed by three separate characters. We pass the addresses of el arrow n underscore lines, el arrow empty, el arrow obstacle, and el arrow full. The return value – the number of items successfully read – goes into ret."
pause 0.5

say "Now we validate the header. If ret does not equal 4, meaning fscanf did not read all four values, OR if el arrow n underscore lines is less than or equal to zero, we return minus one to signal an error."
pause 0.3

say "Next we check that the three characters are all distinct from each other: if empty equals obstacle, OR empty equals full, OR obstacle equals full, we return minus one."
pause 0.3

say "We also check that all three are printable: if any of them has an ASCII value less than 32, which is the code for the space character, we return minus one."
pause 0.3

say "Then we consume the rest of the header line using getline. This reads and discards whatever is left on the first line after the four values. If getline returns minus one – meaning it failed – we free line and return minus one. Otherwise we free line and return zero for success."
pause 1

# ──────────────────────────────────────────────────────────────
section load_map
say "-- Function: load underscore map --"
pause 0.3

say "load underscore map is static, returns int, and takes a FILE pointer, a pointer to t underscore map, and a pointer to t underscore elements."
pause 0.3

say "We declare: a char pointer line, a size underscore t cap, an ssize underscore t n for the byte count returned by getline, and ints len, i, and j."
pause 0.3

say "We set map arrow height to el arrow n underscore lines – the expected number of rows from the header."
pause 0.2

say "We set map arrow width to minus one – we don't know the width yet, we'll figure it out from the first row."
pause 0.3

say "We allocate map arrow grid: malloc of map arrow height PLUS one, times the size of a char pointer. The plus one reserves space for a NULL sentinel at the end of the pointer array. If malloc fails, we return minus one. We also immediately set map arrow grid bracket map arrow height bracket to NULL – that's the sentinel."
pause 0.5

say "Now the main loop: i goes from zero while i is less than map arrow height."
pause 0.3

say "Inside the loop: we reset line to NULL and cap to zero, then call getline. getline allocates or resizes the line buffer to fit the next line from file and stores the total byte count in n."
pause 0.3

say "If n is less than or equal to zero – end of file or a read error – we free line, set map arrow height to i so that free underscore map knows how many rows have been allocated so far, call free underscore map, and return minus one."
pause 0.3

say "We cast n to int and store it in len."
pause 0.2

say "If the last character of the line is a newline – line bracket len minus one bracket equals backslash n – we replace it with a null terminator and decrement len. This strips the newline."
pause 0.3

say "If len is zero after stripping – meaning the line was blank – we clean up and return minus one."
pause 0.3

say "If map arrow width is still minus one, this is the first row, so we set map arrow width to len. Otherwise, if len does not equal map arrow width, the rows have inconsistent widths – we clean up and return minus one."
pause 0.3

say "Then we validate every character in the line: j loops from zero to len. If line bracket j is neither el arrow empty nor el arrow obstacle, it is an invalid character, so we clean up and return minus one."
pause 0.3

say "After passing validation, we assign line directly to map arrow grid bracket i bracket. We do NOT free line here – getline allocated it on the heap and we keep it alive as our grid row. We increment i and continue."
pause 0.3

say "After the loop we return zero."
pause 1

# ──────────────────────────────────────────────────────────────
section min3
say "-- Function: min 3 --"
pause 0.3

say "min 3 is a static helper that returns int and takes three ints: a, b, and c."
pause 0.3

say "We declare int m and assign a to it. If b is less than m we assign b to m. If c is less than m we assign c to m. We return m. Simple minimum of three values."
pause 1

# ──────────────────────────────────────────────────────────────
section solve
say "-- Function: solve – the core algorithm --"
pause 0.3

say "solve is static, returns void, and takes a pointer to t underscore map and a pointer to t underscore elements."
pause 0.3

say "We declare: a double pointer to int called dp – this is our dynamic programming table – a t underscore square called sq, and ints i and j."
pause 0.3

say "We allocate dp: malloc of map arrow height times the size of an int pointer. If it fails, we return early."
pause 0.3

say "Then we loop i from zero to map arrow height and for each row call calloc of map arrow width times the size of int. calloc initialises everything to zero. This gives us a 2-D table of ints with the same dimensions as the map."
pause 0.3

say "We initialise sq dot size, sq dot row, and sq dot col all to zero."
pause 0.3

say "Now the main double loop: i from zero to height, j from zero to width."
pause 0.3

say "The D P rule at each cell. Case one: if map arrow grid bracket i bracket bracket j bracket equals el arrow obstacle, we set dp bracket i bracket bracket j bracket to zero. An obstacle cannot be part of any square."
pause 0.3

say "Case two: if i equals zero OR j equals zero – we are on the top or left edge – we set dp bracket i bracket bracket j bracket to one. A single edge cell can only form a 1-by-1 square."
pause 0.3

say "Case three, the general case: dp bracket i bracket bracket j bracket equals min 3 of dp bracket i minus one bracket bracket j bracket, dp bracket i bracket bracket j minus one bracket, dp bracket i minus one bracket bracket j minus one bracket, plus one. We look at the cell directly above, the cell directly to the left, and the cell diagonally above-left. The minimum of those three tells us the largest square we can extend here, and we add one for the current cell."
pause 0.5

say "After computing the dp value, if it is greater than sq dot size, we have a new best square. We update sq dot size to dp bracket i bracket bracket j bracket. The top-left corner is at row i minus dp bracket i bracket bracket j bracket plus one, and column j minus dp bracket i bracket bracket j bracket plus one. We store those in sq dot row and sq dot col."
pause 0.5

say "After the main loop, we mark the best square on the grid. We loop i from sq dot row to sq dot row plus sq dot size, and j from sq dot col to sq dot col plus sq dot size, and we set map arrow grid bracket i bracket bracket j bracket to el arrow full."
pause 0.3

say "Finally, we free each row of dp inside a loop, then free dp itself."
pause 1

# ──────────────────────────────────────────────────────────────
section execute_bsq
say "-- Function: execute underscore bsq --"
pause 0.3

say "execute underscore bsq returns int and takes a FILE pointer."
pause 0.3

say "We declare t underscore elements el, t underscore map map, and int i."
pause 0.3

say "We call load underscore elements, passing file and the address of el. If it returns minus one, we propagate the error by returning minus one."
pause 0.3

say "We call load underscore map, passing file, the address of map, and the address of el. If it returns minus one, we return minus one."
pause 0.3

say "We call solve, passing the address of map and the address of el."
pause 0.3

echo ""
echo "      // ── print loop ──────────────────────────────────"
echo "      while (i < map.height)"
echo "      {"
echo "          fprintf(stdout, \"%s\\n\", map.grid[i]);"
echo "          i++;"
echo "      }"
echo ""
say "The print loop calls fprintf with the format string percent s backslash n for each row."
pause 0.3

say "Why percent s works here: every row in map dot grid is a string that getline allocated on the heap. In load underscore map we stripped the trailing newline by writing a null terminator in its place. So each row ends with backslash zero. The percent s format specifier advances through the string byte by byte until it finds that null terminator – it knows exactly where the row ends. The backslash n in the format string then adds the line break before we move to the next row."
pause 0.5

say "Contrast this with Game of Life where we must use putchar per cell. In Life the rows come from plain malloc calls that we filled with space or zero characters – no null terminator anywhere. Using percent s on a Life row would read past the end of the array into unknown memory – garbage output or a crash. In B S Q, because getline guarantees null termination, percent s is both correct and convenient."
pause 0.5

say "We call free underscore map to release all grid memory, and return zero."
pause 1

# ──────────────────────────────────────────────────────────────
section main
say "-- Function: convert underscore file underscore pointer and main --"
echo ""
echo "  int main(int ac, char **av)"
echo "  {"
echo "      if (ac == 1)"
echo "          execute_bsq(stdin);            // read from pipe or keyboard"
echo "      else if (ac == 2)"
echo "      {"
echo "          FILE *f = fopen(av[1], \"r\");"
echo "          if (!f) return (1);            // file not found / no permission"
echo "          execute_bsq(f);"
echo "          fclose(f);"
echo "      }"
echo "      else"
echo "          return (1);                    // wrong argument count"
echo "      return (0);"
echo "  }"
echo ""
pause 0.3

say "main decides where the input comes from."
pause 0.3

say "If ac equals one – no filename argument – we call execute underscore bsq with the special FILE pointer called stdin. stdin is always open. The OS gives it to every program automatically. It reads from whatever is connected to the program's standard input – a terminal, a pipe from another program, or a redirected file. execute underscore bsq does not need to know which one; it just calls getline and fscanf on the FILE pointer."
pause 0.5

say "If ac equals two – exactly one argument – we have a filename in av bracket one bracket. We call fopen with mode r for reading only. fopen returns NULL if the file does not exist, if we have no read permission, or if any other OS-level error occurs. We check for NULL immediately and return one. If fopen succeeded, we call execute underscore bsq with the file pointer, then close the file with fclose to release the OS file descriptor. Both paths through execute underscore bsq do the identical work – parse header, load map, solve, print, free."
pause 0.5

say "If ac is anything other than one or two, the argument count is wrong. We return one without calling anything."
pause 1

say "That's the full B S Q solution. Good luck on the exam!"
