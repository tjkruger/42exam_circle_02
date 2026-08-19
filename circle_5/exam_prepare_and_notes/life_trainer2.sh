#!/bin/bash

# life_trainer.sh - Interactive Game of Life Training
# Write code, compile, test! Same style as vect2_trainer.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/life_training"
REF_DIR="$SCRIPT_DIR/.resources/rank05/level2/life"

# Find compiler (gcc or cc)
CC=""
find_compiler() {
    if command -v gcc &>/dev/null; then
        CC="gcc"
    elif command -v cc &>/dev/null; then
        CC="cc"
    else
        echo -e "${RED}No C compiler found! Install gcc: sudo apt install gcc${NC}"
        exit 1
    fi
}

# Cleanup
cleanup() {
    rm -rf "$WORK_DIR"
}

# Setup
setup() {
    cleanup
    mkdir -p "$WORK_DIR"
    mkdir -p "$WORK_DIR/ref_build"

    # Build reference binary once
    cp "$REF_DIR/life.c" "$WORK_DIR/ref_build/life.c"
    cp "$REF_DIR/life.h" "$WORK_DIR/ref_build/life.h"
    # Strip Windows line endings
    sed -i 's/\r$//' "$WORK_DIR/ref_build/life.c" "$WORK_DIR/ref_build/life.h"
    (cd "$WORK_DIR/ref_build" && $CC -Wall -Wextra -Werror -std=c99 -o ref_life life.c 2>/dev/null)
}

# Test cases: "name|input|width|height|iterations"
TEST_CASES=(
    "Basic_Square|sdxddssaaww|5|5|0"
    "Complex|sdxssdswdxddddsxaadwxwdxwaa|10|6|0"
    "Vertical|dxss|3|3|0"
    "Evolution1|dxss|3|3|1"
    "Evolution2|dxss|3|3|2"
    "Empty||3|3|0"
)

# Run all tests, return pass count
run_tests() {
    local passed=0
    local total=${#TEST_CASES[@]}

    for tc in "${TEST_CASES[@]}"; do
        IFS='|' read -r name input w h iter <<< "$tc"
        local ref_out=$(echo "$input" | "$WORK_DIR/ref_build/ref_life" "$w" "$h" "$iter" 2>/dev/null)
        local user_out=$(echo "$input" | "$WORK_DIR/user_life" "$w" "$h" "$iter" 2>/dev/null)

        if [ "$ref_out" == "$user_out" ]; then
            echo -e "  ${GREEN}PASS${NC} $name"
            passed=$((passed + 1))
        else
            echo -e "  ${RED}FAIL${NC} $name"
            echo -e "    ${YELLOW}Expected:${NC}"
            echo "$ref_out" | sed 's/^/    |/' | cat -e
            echo -e "    ${YELLOW}Got:${NC}"
            echo "$user_out" | sed 's/^/    |/' | cat -e
        fi
    done

    echo ""
    echo -e "  Result: ${passed}/${total}"
    [ $passed -eq $total ] && return 0 || return 1
}

# ============================================================================
#  EXERCISES - Function by function (like vect2_trainer)
# ============================================================================

exercises=(
    "init_game"
    "fill_board"
    "count_neighbors"
    "play"
    "print_board"
    "free_board"
    "main_func"
)

get_exercise_name() {
    case $1 in
        "init_game")        echo "init_game() - Malloc Board + Init Vars" ;;
        "fill_board")       echo "fill_board() - Read stdin, wasd+x" ;;
        "count_neighbors")  echo "count_neighbors() - Count 8 Neighbors" ;;
        "play")             echo "play() - 1 Game of Life Iteration" ;;
        "print_board")      echo "print_board() - Output with putchar" ;;
        "free_board")       echo "free_board() - Cleanup malloc" ;;
        "main_func")        echo "main() - argc check + full flow" ;;
    esac
}

get_exercise_skeleton() {
    case $1 in
        "init_game")
            cat << 'SKEL'
int init_game(t_game* game, char* argv[])
{
    // 1. Parse argv: width=atoi(argv[1]), height=atoi(argv[2]), iter=atoi(argv[3])
    // 2. Init: alive='0', dead=' ', i=0, j=0, draw=0
    // 3. malloc board: height * sizeof(char*)
    //    if (!board) return -1;
    // 4. Loop: malloc each row: width * sizeof(char)
    //    if fail: free_board + return -1
    //    fill each cell with ' '
    // return 0;
}
SKEL
            ;;
        "fill_board")
            cat << 'SKEL'
void fill_board(t_game* game)
{
    // char buffer;
    // while (read(STDIN_FILENO, &buffer, 1) == 1)
    //   switch(buffer):
    //     'w': if i > 0 then i--
    //     's': if i < height-1 then i++
    //     'a': if j > 0 then j--
    //     'd': if j < width-1 then j++
    //     'x': draw = !draw
    //   if (draw && valid_char) board[i][j] = alive
}
SKEL
            ;;
        "count_neighbors")
            cat << 'SKEL'
int count_neighbors(t_game* game, int i, int j)
{
    // int count = 0;
    // double loop: di = -1 to 1, dj = -1 to 1
    //   if (di==0 && dj==0) continue;  // skip self!
    //   ni = i+di, nj = j+dj
    //   bounds: ni>=0 && ni<height && nj>=0 && nj<width
    //   if board[ni][nj] == alive: count++
    // return count;
    //
    //  Neighbors = all 8 surrounding cells:
    //     NW  N  NE
    //      W  X  E      X = cell we check
    //     SW  S  SE
}
SKEL
            ;;
        "play")
            cat << 'SKEL'
int play(t_game* game)
{
    // 1. malloc TEMP board (same size as original)
    //    WHY temp? Changes must not affect each other mid-iteration!
    // 2. For each cell (i,j):
    //    int n = count_neighbors(game, i, j);
    //    if alive: (n==2 || n==3) ? alive : dead
    //    if dead:  (n==3) ? alive : dead
    // 3. free_board(game)     // free OLD board
    // 4. game->board = temp   // swap in new
    // return 0; (or -1 on malloc fail)
}
SKEL
            ;;
        "print_board")
            cat << 'SKEL'
void print_board(t_game* game)
{
    // for each row i:
    //   for each col j:
    //     putchar(board[i][j]);    // NOT printf!
    //   putchar('\n');
}
SKEL
            ;;
        "free_board")
            cat << 'SKEL'
void free_board(t_game* game)
{
    // if (board):
    //   for each row: if (board[i]) free(board[i])
    //   free(board)
    // Order matters: rows FIRST, then the array pointer!
}
SKEL
            ;;
        "main_func")
            cat << 'SKEL'
int main(int argc, char* argv[])
{
    // if (argc != 4) return 1;
    // t_game game;
    // if (init_game(&game, argv) == -1) return 1;
    // fill_board(&game);
    // for (i = 0; i < game.iterations; i++)
    //     if (play(&game) == -1) { free_board(&game); return 1; }
    // print_board(&game);
    // free_board(&game);
    // return 0;
}
SKEL
            ;;
    esac
}

get_solution() {
    case $1 in
        "init_game")
            cat << 'SOL'
int init_game(t_game* game, char* argv[])
{
    game->width = atoi(argv[1]);
    game->height = atoi(argv[2]);
    game->iterations = atoi(argv[3]);
    game->alive = '0';
    game->dead = ' ';
    game->i = 0;
    game->j = 0;
    game->draw = 0;
    game->board = (char**)malloc((game->height) * sizeof(char *));
    if(!(game->board))
        return(-1);
    for(int i = 0; i < game->height; i++)
    {
        game->board[i] = (char *)malloc((game->width) * sizeof(char));
        if(!(game->board[i])) {
            free_board(game);
            return(-1);
        }
        for(int j = 0; j < game->width; j++)
        {
            game->board[i][j] = ' ';
        }
    }
    return(0);
}
SOL
            ;;
        "fill_board")
            cat << 'SOL'
void fill_board(t_game* game)
{
    char buffer;
    int flag = 0;

    while(read(STDIN_FILENO, &buffer, 1) == 1)
    {
        switch (buffer)
        {
        case 'w':
            if(game->i > 0)
            game->i--;
            break;
        case 's':
            if(game->i < (game->height - 1))
            game->i++;
            break;
        case 'a':
            if(game->j > 0)
            game->j--;
            break;
        case 'd':
            if(game->j < (game->width - 1))
            game->j++;
            break;
        case 'x':
            game->draw = !(game->draw);
            break;
        default:
            flag = 1;
            break;
        }

        if(game->draw && (flag == 0))
        {
            if((game->i >= 0 )&& (game->i < game->height) && (game->j >= 0) && (game->j < game->width))
                game->board[game->i][game->j] = game->alive;
        }
    }
}
SOL
            ;;
        "count_neighbors")
            cat << 'SOL'
int count_neighbors(t_game* game, int i, int j)
{
    int count = 0;
    for(int di = -1; di < 2; di++)
    {
        for(int dj = -1; dj < 2; dj++)
        {
            if((di == 0) && (dj == 0))
                continue;

            int ni = i + di;
            int nj = j + dj;
            if((ni >= 0) && (nj >=0) && (ni < game->height) && (nj < game->width)) {
                if(game->board[ni][nj] == game->alive)
                    count++;
            }
        }
    }
    return(count);
}
SOL
            ;;
        "play")
            cat << 'SOL'
int play(t_game* game)
{
    char** temp = (char**)malloc((game->height) * sizeof(char *));
    if(!temp)
        return(-1);
    for(int i = 0; i < game->height; i++)
    {
        temp[i] = (char *)malloc((game->width) * sizeof(char));
        if(!(temp[i]))
            return(-1);
    }

    for(int i = 0; i < game->height; i++)
    {
        for(int j = 0; j < game->width; j++)
        {
            int neighbors = count_neighbors(game, i, j);
            if(game->board[i][j] == game->alive) {
                if(neighbors == 2 || neighbors == 3) {
                    temp[i][j] = game->alive;
                }
                else
                    temp[i][j] = game->dead;
            }
            else {
                if(neighbors == 3) {
                    temp[i][j] = game->alive;
                }
                else
                    temp[i][j] = game->dead;
            }
        }
    }

    free_board(game);
    game->board = temp;
    return(0);
}
SOL
            ;;
        "print_board")
            cat << 'SOL'
void print_board(t_game* game)
{
    for(int i = 0; i < game->height; i++)
    {
        for(int j = 0; j < game->width; j++)
        {
            putchar(game->board[i][j]);
        }
        putchar('\n');
    }
}
SOL
            ;;
        "free_board")
            cat << 'SOL'
void free_board(t_game* game)
{
    if(game->board)
    {
        for(int i = 0; i < game->height; i++)
        {
            if(game->board[i])
                free(game->board[i]);
        }
        free(game->board);
    }
}
SOL
            ;;
        "main_func")
            cat << 'SOL'
int main(int argc, char* argv[])
{
    if(argc != 4)
        return (1);

    t_game game;

    if(init_game(&game, argv) == -1)
        return(1);

    fill_board(&game);

    for(int i = 0; i < game.iterations; i++) {
        if(play(&game) == -1) {
            free_board(&game);
            return(1);
        }
    }
    print_board(&game);
    free_board(&game);

    return (0);
}
SOL
            ;;
    esac
}

# Generate life.c with ONE function removed (like vect2_trainer)
generate_skeleton_for_exercise() {
    local ex=$1

    # Start with COMPLETE working life.c + life.h
    cp "$REF_DIR/life.c" "$WORK_DIR/life.c"
    cp "$REF_DIR/life.h" "$WORK_DIR/life.h"
    # Strip Windows line endings so sed patterns work
    sed -i 's/\r$//' "$WORK_DIR/life.c" "$WORK_DIR/life.h"

    # Delete the specific function the user should practice
    case $ex in
        "init_game")
            sed -i '/^int init_game/,/^}$/d' "$WORK_DIR/life.c"
            sed -i '2a\\n/* TODO: Write init_game() here */\n' "$WORK_DIR/life.c"
            ;;
        "fill_board")
            sed -i '/^void fill_board/,/^}$/d' "$WORK_DIR/life.c"
            sed -i '/init_game/a\\n/* TODO: Write fill_board() here */\n' "$WORK_DIR/life.c"
            ;;
        "count_neighbors")
            sed -i '/^int count_neighbors/,/^}$/d' "$WORK_DIR/life.c"
            sed -i '/fill_board/a\\n/* TODO: Write count_neighbors() here */\n' "$WORK_DIR/life.c"
            ;;
        "play")
            sed -i '/^int play/,/^}$/d' "$WORK_DIR/life.c"
            sed -i '/count_neighbors/a\\n/* TODO: Write play() here */\n' "$WORK_DIR/life.c"
            ;;
        "print_board")
            sed -i '/^void print_board/,/^}$/d' "$WORK_DIR/life.c"
            sed -i '/play/a\\n/* TODO: Write print_board() here */\n' "$WORK_DIR/life.c"
            ;;
        "free_board")
            sed -i '/^void free_board/,/^}$/d' "$WORK_DIR/life.c"
            sed -i '/print_board/a\\n/* TODO: Write free_board() here */\n' "$WORK_DIR/life.c"
            ;;
        "main_func")
            sed -i '/^int main/,/^}$/d' "$WORK_DIR/life.c"
            echo "" >> "$WORK_DIR/life.c"
            echo "/* TODO: Write main() here */" >> "$WORK_DIR/life.c"
            echo "" >> "$WORK_DIR/life.c"
            ;;
    esac
}

# Run exercise (same flow as vect2_trainer!)
run_exercise() {
    local ex=$1
    local name=$(get_exercise_name "$ex")

    while true; do
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║  EXERCISE: ${CYAN}$name${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""

        # Show skeleton
        echo -e "${YELLOW}What you should write:${NC}"
        echo "────────────────────────────────────────────────────────"
        get_exercise_skeleton "$ex"
        echo "────────────────────────────────────────────────────────"
        echo ""

        # Show test info
        echo -e "${YELLOW}Tests that will run:${NC}"
        echo "  echo 'sdxddssaaww' | ./life 5 5 0"
        echo "  echo 'dxss' | ./life 3 3 0"
        echo "  echo 'dxss' | ./life 3 3 1"
        echo "  echo 'dxss' | ./life 3 3 2"
        echo "  + more..."
        echo ""

        echo -e "${GREEN}Write your solution in: ${CYAN}$WORK_DIR/life.c${NC}"
        echo ""

        # Create skeleton file - complete code with ONE function removed
        generate_skeleton_for_exercise "$ex"

        echo -e "${CYAN}Press ENTER when you are ready to test...${NC}"
        read

        # Check if user actually wrote something
        if ! grep -q '[a-zA-Z]' "$WORK_DIR/life.c" 2>/dev/null || ! grep -q 'TODO\|main\|init_game\|fill_board\|count_neighbors\|play\|print_board\|free_board' "$WORK_DIR/life.c" 2>/dev/null; then
            echo -e "${RED}File is empty! Write your code in: $WORK_DIR/life.c${NC}"
            echo ""
            echo -e "${CYAN}[s] Show solution  [r] Retry  [n] Next  [q] Quit${NC}"
            read retry
            if [ "$retry" == "s" ]; then
                echo ""
                echo -e "${YELLOW}Solution:${NC}"
                echo "────────────────────────────────────────────────────────"
                get_solution "$ex"
                echo "────────────────────────────────────────────────────────"
                echo ""
                echo -e "${CYAN}[r] Retry  [n] Next  [q] Quit${NC}"
                read retry
            fi
            if [ "$retry" == "n" ] || [ "$retry" == "q" ]; then
                return 1
            fi
            continue
        fi

        # Compile
        echo -e "${YELLOW}Compiling...${NC}"
        cd "$WORK_DIR"
        sed -i 's/\r$//' life.c life.h 2>/dev/null
        if $CC -Wall -Wextra -Werror -std=c99 -o user_life life.c 2>/tmp/life_compile_error.txt; then
            echo -e "${GREEN}Compiled!${NC}"
            echo ""

            # Run tests
            echo -e "${YELLOW}Running tests...${NC}"
            if run_tests; then
                echo -e "${GREEN}ALL TESTS PASSED!${NC}"
                echo ""

                # Valgrind if available
                if command -v valgrind &>/dev/null; then
                    echo -e "${YELLOW}Checking memory...${NC}"
                    local vg_out=$(echo 'sdxddssaaww' | valgrind --leak-check=full --show-leak-kinds=all -s ./user_life 5 5 0 2>&1)
                    if echo "$vg_out" | grep -qE "definitely lost: [^0]|ERROR SUMMARY: [^0]"; then
                        echo -e "${RED}Memory issues detected!${NC}"
                        echo "$vg_out" | grep -E "lost:|ERROR SUMMARY"
                    else
                        echo -e "${GREEN}No memory leaks!${NC}"
                    fi
                fi
                echo ""
                return 0
            else
                echo ""
                echo -e "${RED}Some tests failed!${NC}"
                echo ""
                echo -e "${CYAN}[s] Show solution  [r] Retry  [n] Next  [q] Quit${NC}"
                read retry
                if [ "$retry" == "s" ]; then
                    echo ""
                    echo -e "${YELLOW}Solution:${NC}"
                    echo "────────────────────────────────────────────────────────"
                    get_solution "$ex"
                    echo "────────────────────────────────────────────────────────"
                    echo ""
                    echo -e "${CYAN}[r] Retry  [n] Next  [q] Quit${NC}"
                    read retry
                fi
                if [ "$retry" == "n" ] || [ "$retry" == "q" ]; then
                    return 1
                fi
            fi
        else
            echo -e "${RED}Compile Error:${NC}"
            cat /tmp/life_compile_error.txt
            echo ""
            echo -e "${CYAN}[s] Show solution  [r] Retry  [n] Next  [q] Quit${NC}"
            read retry
            if [ "$retry" == "s" ]; then
                echo ""
                echo -e "${YELLOW}Solution:${NC}"
                echo "────────────────────────────────────────────────────────"
                get_solution "$ex"
                echo "────────────────────────────────────────────────────────"
                echo ""
                echo -e "${CYAN}[r] Retry  [n] Next  [q] Quit${NC}"
                read retry
            fi
            if [ "$retry" == "n" ] || [ "$retry" == "q" ]; then
                return 1
            fi
        fi
    done
}

# ============================================================================
#  THEORY - Game of Life rules explained
# ============================================================================

show_theory() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          GAME OF LIFE - THEORY                             ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}GAME OF LIFE RULES:${NC}"
    echo "  1. Living cell + <2 neighbors  -> dies  (underpopulation)"
    echo "  2. Living cell + 2-3 neighbors -> lives (survival)"
    echo "  3. Living cell + >3 neighbors  -> dies  (overpopulation)"
    echo "  4. Dead cell + exactly 3       -> born  (reproduction)"
    echo ""
    echo -e "${YELLOW}IN CODE (2 lines):${NC}"
    echo "  if (board[i][j] == alive) tmp[i][j] = (n==2||n==3) ? alive : dead;"
    echo "  else                      tmp[i][j] = (n==3)       ? alive : dead;"
    echo ""
    echo -e "${YELLOW}NEIGHBORS (all 8 surrounding cells):${NC}"
    echo "     NW  N  NE"
    echo "      W  X  E      X = cell we check"
    echo "     SW  S  SE"
    echo ""
    echo "  Count loop: di=-1..1, dj=-1..1, skip (0,0)"
    echo "  Outside board = dead (don't count)"
    echo ""
    echo -e "${YELLOW}DRAWING MECHANIC:${NC}"
    echo "  Pen starts at (0,0), draw=OFF"
    echo "  w/a/s/d = move pen (with bounds check!)"
    echo "  x       = toggle draw on/off"
    echo "  After EVERY move: if draw is ON -> board[i][j] = alive"
    echo ""
    echo -e "${YELLOW}STRUCT:${NC}"
    echo "  typedef struct s_game {"
    echo "      int width, height, iterations;"
    echo "      char alive, dead;    // '0' and ' '"
    echo "      int i, j;           // pen position"
    echo "      int draw;           // 0=off, 1=on"
    echo "      char** board;       // board[y][x]"
    echo "  } t_game;"
    echo ""
    echo -e "${YELLOW}MAIN FLOW:${NC}"
    echo "  1. argc != 4 -> return 1"
    echo "  2. init_game()  -> malloc board, init vars"
    echo "  3. fill_board()  -> read stdin commands"
    echo "  4. loop play()  -> N iterations of game of life"
    echo "  5. print_board() -> putchar output"
    echo "  6. free_board()  -> cleanup"
    echo ""
    echo -e "${YELLOW}KEY TRAPS:${NC}"
    echo -e "  ${RED}!${NC} TEMP board in play() - changes must not affect each other"
    echo -e "  ${RED}!${NC} putchar not printf"
    echo -e "  ${RED}!${NC} Draw happens after EVERY wasd move, not just on 'x'"
    echo -e "  ${RED}!${NC} Skip (0,0) in neighbor count"
    echo -e "  ${RED}!${NC} Bounds check on movement AND neighbor counting"
    echo -e "  ${RED}!${NC} Free rows first, THEN the board pointer"
    echo ""
    echo -e "${YELLOW}ALLOWED FUNCTIONS:${NC}"
    echo "  atoi, read, putchar, malloc, calloc, realloc, free"
    echo ""
    echo -e "${YELLOW}EXAMPLE:${NC}"
    echo "  echo 'dxss' | ./life 3 3 0    echo 'dxss' | ./life 3 3 1"
    echo "   0 (space)                       (space)(space)(space)"
    echo "   0 (space)          -->          000"
    echo "   0 (space)                       (space)(space)(space)"
    echo ""
    echo -e "${CYAN}Press ENTER to go back...${NC}"
    read
}

# ============================================================================
#  FULL WRITE MODE - Write everything from scratch, timed
# ============================================================================

full_write_mode() {
    setup
    local start_time=$(date +%s)

    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       LIFE - FULL WRITE MODE (timed!)                      ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Write Conway's Game of Life from scratch!${NC}"
    echo -e "${CYAN}  ./life width height iterations${NC}"
    echo -e "${CYAN}  stdin: w/a/s/d = move pen, x = toggle draw${NC}"
    echo -e "${CYAN}  alive = '0' (zero)  dead = ' '${NC}"
    echo ""
    echo -e "${YELLOW}Allowed: atoi, read, putchar, malloc, calloc, realloc, free${NC}"
    echo ""
    echo -e "${GREEN}Files: ${CYAN}$WORK_DIR/life.c  $WORK_DIR/life.h${NC}"
    echo ""

    # Create empty skeleton files
    cat > "$WORK_DIR/life.h" << 'EOF'
#ifndef LIFE_H
#define LIFE_H

/* TODO: includes + struct + prototypes */

#endif
EOF

    cat > "$WORK_DIR/life.c" << 'EOF'
#include "life.h"

/* TODO: implement all functions + main */
EOF

    echo -e "${GREEN}Files created. Edit them and come back to test!${NC}"
    echo ""

    while true; do
        echo -e "${CYAN}[t] Test  [s] Show subject  [h] Hints  [r] Reference  [q] Quit${NC}"
        read -p "> " cmd

        case "$cmd" in
            t)
                local now=$(date +%s)
                local elapsed=$(( now - start_time ))
                local mins=$(( elapsed / 60 ))
                local secs=$(( elapsed % 60 ))
                echo ""
                echo -e "${BLUE}Time: ${mins}m ${secs}s${NC}"

                # Check if user wrote something
                if ! grep -q 'main' "$WORK_DIR/life.c" 2>/dev/null; then
                    echo -e "${RED}No main() found! Write your code first in:${NC}"
                    echo -e "${CYAN}  $WORK_DIR/life.c${NC}"
                    echo -e "${CYAN}  $WORK_DIR/life.h${NC}"
                    echo ""
                    continue
                fi

                echo -e "${YELLOW}Compiling...${NC}"
                cd "$WORK_DIR"
                sed -i 's/\r$//' life.c life.h 2>/dev/null
                if $CC -Wall -Wextra -Werror -std=c99 -o user_life life.c 2>/tmp/life_compile_error.txt; then
                    echo -e "${GREEN}Compiled!${NC}"
                    if run_tests; then
                        echo -e "${GREEN}ALL TESTS PASSED! Time: ${mins}m ${secs}s${NC}"
                        if command -v valgrind &>/dev/null; then
                            echo -e "${YELLOW}Checking memory...${NC}"
                            local vg_out=$(echo 'sdxddssaaww' | valgrind --leak-check=full --show-leak-kinds=all -s ./user_life 5 5 0 2>&1)
                            if echo "$vg_out" | grep -qE "definitely lost: [^0]|ERROR SUMMARY: [^0]"; then
                                echo -e "${RED}Memory issues!${NC}"
                                echo "$vg_out" | grep -E "lost:|ERROR SUMMARY"
                            else
                                echo -e "${GREEN}No memory leaks!${NC}"
                            fi
                        fi
                    fi
                else
                    echo -e "${RED}Compile Error:${NC}"
                    cat /tmp/life_compile_error.txt
                fi
                echo ""
                ;;
            s)
                echo ""
                echo -e "${YELLOW}=== SUBJECT ===${NC}"
                head -48 "$REF_DIR/sub.txt"
                echo -e "${YELLOW}===============${NC}"
                echo ""
                ;;
            h)
                echo ""
                echo -e "${YELLOW}=== HINTS ===${NC}"
                echo "struct: width, height, iterations, alive('0'), dead(' '), i, j, draw, board(char**)"
                echo "init: malloc h*sizeof(char*), each row malloc w*sizeof(char), fill ' '"
                echo "fill: while(read(0,&c,1)==1) switch wasd+x, draw after move if draw&&valid"
                echo "count: di/dj -1..1, skip 0,0, bounds check, count alive"
                echo "play: TEMP board, alive+(2||3)=lives, dead+3=born, free old, swap"
                echo "print: putchar each cell + putchar('\\n')"
                echo "free: free each row, then free board ptr"
                echo "main: ac!=4->1, init, fill, loop play, print, free"
                echo -e "${YELLOW}=============${NC}"
                echo ""
                ;;
            r)
                echo ""
                echo -e "${YELLOW}=== REFERENCE (life.h) ===${NC}"
                cat "$REF_DIR/life.h"
                echo -e "${YELLOW}=== REFERENCE (life.c) ===${NC}"
                cat "$REF_DIR/life.c"
                echo -e "${YELLOW}==========================${NC}"
                echo ""
                ;;
            q)
                local now=$(date +%s)
                local elapsed=$(( now - start_time ))
                local mins=$(( elapsed / 60 ))
                local secs=$(( elapsed % 60 ))
                echo -e "${BLUE}Total time: ${mins}m ${secs}s${NC}"
                return
                ;;
        esac
    done
}

# ============================================================================
#  EXAM SIMULATION - Subject only, no hints
# ============================================================================

exam_sim_mode() {
    setup
    local start_time=$(date +%s)

    clear
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║            EXAM SIMULATION - NO HINTS!                     ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Subject:${NC}"
    echo "────────────────────────────────────────────────────────"
    head -48 "$REF_DIR/sub.txt"
    echo "────────────────────────────────────────────────────────"
    echo ""
    echo -e "${CYAN}Files: $WORK_DIR/life.c  $WORK_DIR/life.h${NC}"
    echo -e "${CYAN}Allowed: atoi, read, putchar, malloc, calloc, realloc, free${NC}"
    echo ""

    # Empty files
    echo "" > "$WORK_DIR/life.h"
    echo "" > "$WORK_DIR/life.c"

    echo -e "${GREEN}GO! Timer started.${NC}"
    echo ""

    while true; do
        echo -e "${CYAN}[t] Test  [q] Quit${NC}"
        read -p "> " cmd

        case "$cmd" in
            t)
                local now=$(date +%s)
                local elapsed=$(( now - start_time ))
                local mins=$(( elapsed / 60 ))
                local secs=$(( elapsed % 60 ))
                echo ""
                echo -e "${BLUE}Time: ${mins}m ${secs}s${NC}"

                # Check if user wrote something
                if ! grep -q 'main' "$WORK_DIR/life.c" 2>/dev/null; then
                    echo -e "${RED}No main() found! Write your code first in:${NC}"
                    echo -e "${CYAN}  $WORK_DIR/life.c${NC}"
                    echo -e "${CYAN}  $WORK_DIR/life.h${NC}"
                    echo ""
                    continue
                fi

                echo -e "${YELLOW}Compiling...${NC}"
                cd "$WORK_DIR"
                sed -i 's/\r$//' life.c life.h 2>/dev/null
                if $CC -Wall -Wextra -Werror -std=c99 -o user_life life.c 2>/tmp/life_compile_error.txt; then
                    echo -e "${GREEN}Compiled!${NC}"
                    if run_tests; then
                        echo -e "${GREEN}ALL TESTS PASSED! Time: ${mins}m ${secs}s${NC}"
                        if command -v valgrind &>/dev/null; then
                            local vg_out=$(echo 'sdxddssaaww' | valgrind --leak-check=full --show-leak-kinds=all -s ./user_life 5 5 0 2>&1)
                            if echo "$vg_out" | grep -qE "definitely lost: [^0]|ERROR SUMMARY: [^0]"; then
                                echo -e "${RED}Memory issues!${NC}"
                                echo "$vg_out" | grep -E "lost:|ERROR SUMMARY"
                            else
                                echo -e "${GREEN}No memory leaks!${NC}"
                            fi
                        fi
                    fi
                else
                    echo -e "${RED}Compile Error:${NC}"
                    cat /tmp/life_compile_error.txt
                fi
                echo ""
                ;;
            q)
                local now=$(date +%s)
                local elapsed=$(( now - start_time ))
                local mins=$(( elapsed / 60 ))
                local secs=$(( elapsed % 60 ))
                echo -e "${BLUE}Total time: ${mins}m ${secs}s${NC}"
                return
                ;;
        esac
    done
}

# ============================================================================
#  MAIN MENU (same style as vect2_trainer)
# ============================================================================

main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║          LIFE TRAINER - Write the Code!                    ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "Choose an exercise:"
        echo ""

        local i=1
        for ex in "${exercises[@]}"; do
            printf " %2d) %s\n" $i "$(get_exercise_name "$ex")"
            ((i++))
        done

        echo ""
        echo "  r) Random"
        echo "  a) All in order"
        echo "  t) Theory (rules + traps explained)"
        echo "  f) Full Write (from scratch, timed)"
        echo "  e) Exam Sim (subject only, no hints)"
        echo "  q) Quit"
        echo ""
        read -p "Choice: " choice

        if [ "$choice" == "q" ]; then
            cleanup
            exit 0
        elif [ "$choice" == "r" ]; then
            local rand=$((RANDOM % ${#exercises[@]}))
            setup
            run_exercise "${exercises[$rand]}"
            echo ""
            read -p "Press ENTER for next..."
        elif [ "$choice" == "a" ]; then
            setup
            for ex in "${exercises[@]}"; do
                run_exercise "$ex"
                echo ""
                read -p "Press ENTER for next function..."
            done
        elif [ "$choice" == "t" ]; then
            show_theory
        elif [ "$choice" == "f" ]; then
            full_write_mode
        elif [ "$choice" == "e" ]; then
            exam_sim_mode
        elif [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -le ${#exercises[@]} ]; then
            setup
            run_exercise "${exercises[$((choice-1))]}"
            echo ""
            read -p "Press ENTER for next..."
        fi
    done
}

# Init
find_compiler
main_menu
