#!/bin/bash

# ============================================================================
# LIFE TRAINER - vect2 style
# Eine Funktion pro Übung - alles andere läuft schon
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/life_training"
REF_DIR="$SCRIPT_DIR/.resources/rank05/level2/life"

exercises=(
    "init_game"
    "fill_board"
    "count_neighbors"
    "play"
    "print_board"
    "free_board"
    "main_func"
)

# ─── Namen ───────────────────────────────────────────────────────────────────

get_name() {
    case $1 in
        "init_game")       echo "init_game()       — Board malloc'en, argv parsen" ;;
        "fill_board")      echo "fill_board()      — stdin lesen, Stift bewegen, zeichnen" ;;
        "count_neighbors") echo "count_neighbors() — 8 Nachbarn zählen" ;;
        "play")            echo "play()            — 1 Game-of-Life Iteration" ;;
        "print_board")     echo "print_board()     — Board ausgeben mit putchar" ;;
        "free_board")      echo "free_board()      — Memory freigeben" ;;
        "main_func")       echo "main()            — argc prüfen + Flow zusammenbauen" ;;
    esac
}

# ─── life.h ──────────────────────────────────────────────────────────────────

write_header() {
    cat > "$WORK_DIR/life.h" << 'EOF'
#ifndef LIFE_H
#define LIFE_H

#include <stdlib.h>
#include <unistd.h>

typedef struct s_game {
    int     width;
    int     height;
    int     iter;
    int     i;
    int     j;
    int     draw;
    char    **board;
} t_game;

int     init_game(t_game *g, char **av);
void    fill_board(t_game *g);
int     count_neighbors(t_game *g, int row, int col);
int     play(t_game *g);
void    print_board(t_game *g);
void    free_board(t_game *g);

#endif
EOF
}

# ─── Lösungen (jede Funktion einzeln) ───────────────────────────────────────

sol_init_game() {
cat << 'EOF'
int init_game(t_game *g, char **av)
{
    g->width  = atoi(av[1]);
    g->height = atoi(av[2]);
    g->iter   = atoi(av[3]);
    g->i = 0;
    g->j = 0;
    g->draw = 0;
    g->board = malloc(g->height * sizeof(char *));
    if (!g->board)
        return (-1);
    for (int i = 0; i < g->height; i++)
    {
        g->board[i] = malloc(g->width * sizeof(char));
        if (!g->board[i])
        {
            free_board(g);
            return (-1);
        }
        for (int j = 0; j < g->width; j++)
            g->board[i][j] = ' ';
    }
    return (0);
}
EOF
}

sol_fill_board() {
cat << 'EOF'
void fill_board(t_game *g)
{
    char    c;
    int     flag;

    flag = 0;
    while (read(0, &c, 1) == 1)
    {
        switch (c)
        {
            case 'w': if (g->i > 0)             g->i--;  break;
            case 's': if (g->i < g->height - 1) g->i++;  break;
            case 'a': if (g->j > 0)             g->j--;  break;
            case 'd': if (g->j < g->width - 1)  g->j++;  break;
            case 'x': g->draw = !g->draw;                 break;
            default:  flag = 1;                           break;
        }
        if (flag)
            continue;
        if (g->draw)
            g->board[g->i][g->j] = '0';
    }
}
EOF
}

sol_count_neighbors() {
cat << 'EOF'
int count_neighbors(t_game *g, int row, int col)
{
    int count;
    int ni;
    int nj;

    count = 0;
    for (int dy = -1; dy <= 1; dy++)
    {
        for (int dx = -1; dx <= 1; dx++)
        {
            if (dy == 0 && dx == 0)
                continue;
            ni = row + dy;
            nj = col + dx;
            if (ni >= 0 && ni < g->height && nj >= 0 && nj < g->width)
                if (g->board[ni][nj] == '0')
                    count++;
        }
    }
    return (count);
}
EOF
}

sol_play() {
cat << 'EOF'
int play(t_game *g)
{
    char    **tmp;
    int     n;

    tmp = malloc(g->height * sizeof(char *));
    if (!tmp)
        return (-1);
    for (int i = 0; i < g->height; i++)
    {
        tmp[i] = malloc(g->width * sizeof(char));
        if (!tmp[i])
        {
            for (int k = 0; k < i; k++)
                free(tmp[k]);
            free(tmp);
            return (-1);
        }
    }
    for (int i = 0; i < g->height; i++)
    {
        for (int j = 0; j < g->width; j++)
        {
            n = count_neighbors(g, i, j);
            if (g->board[i][j] == '0')
                tmp[i][j] = (n == 2 || n == 3) ? '0' : ' ';
            else
                tmp[i][j] = (n == 3) ? '0' : ' ';
        }
    }
    free_board(g);
    g->board = tmp;
    return (0);
}
EOF
}

sol_print_board() {
cat << 'EOF'
void print_board(t_game *g)
{
    for (int i = 0; i < g->height; i++)
    {
        for (int j = 0; j < g->width; j++)
            putchar(g->board[i][j]);
        putchar('\n');
    }
}
EOF
}

sol_free_board() {
cat << 'EOF'
void free_board(t_game *g)
{
    if (!g->board)
        return ;
    for (int i = 0; i < g->height; i++)
        if (g->board[i])
            free(g->board[i]);
    free(g->board);
    g->board = NULL;
}
EOF
}

sol_main_func() {
cat << 'EOF'
int main(int argc, char **argv)
{
    t_game  g;

    if (argc != 4)
        return (1);
    if (init_game(&g, argv) == -1)
        return (1);
    fill_board(&g);
    for (int i = 0; i < g.iter; i++)
    {
        if (play(&g) == -1)
        {
            free_board(&g);
            return (1);
        }
    }
    print_board(&g);
    free_board(&g);
    return (0);
}
EOF
}

# ─── Skeletons ────────────────────────────────────────────────────────────────

skel_init_game() {
cat << 'EOF'
int init_game(t_game *g, char **av)
{
    /*
     * TODO:
     * - g->width  = atoi(av[1])
     * - g->height = atoi(av[2])
     * - g->iter   = atoi(av[3])
     * - g->i = g->j = g->draw = 0
     * - g->board = malloc(height * sizeof(char *))
     * - g->board[i] = malloc(width * sizeof(char))
     * - board[i][j] = ' '  (ALLE Zellen!)
     * - return 0 (OK) oder -1 (malloc fail)
     * KEIN dead/alive im struct - direkt ' ' und '0' verwenden!
     */
    (void)g;
    (void)av;
    return (0);
}
EOF
}

skel_fill_board() {
cat << 'EOF'
void fill_board(t_game *g)
{
    /*
     * TODO:
     * - char c; int flag = 0;
     * - while (read(0, &c, 1) == 1)
     * - switch: w=i-- a=j-- s=i++ d=j++  (mit bounds!)
     * - case 'x': draw = !draw; break;
     * - default: flag = 1; break;
     * - if (flag) continue;  ← flag NIEMALS zurücksetzen!
     * - if (draw) board[i][j] = '0';
     * FALLE: kein else-branch! Nur zeichnen, NIE löschen!
     */
    (void)g;
}
EOF
}

skel_count_neighbors() {
cat << 'EOF'
int count_neighbors(t_game *g, int row, int col)
{
    /*
     * TODO:
     * - for dy = -1..1, for dx = -1..1
     * - if (dy == 0 && dx == 0) continue;
     * - ni = row + dy, nj = col + dx
     * - bounds: ni >= 0 && ni < height && nj >= 0 && nj < width
     * - if board[ni][nj] == '0' → count++
     * - return count
     */
    (void)g;
    (void)row;
    (void)col;
    return (0);
}
EOF
}

skel_play() {
cat << 'EOF'
int play(t_game *g)
{
    /*
     * TODO:
     * - tmp Board malloc'en (gleiche Größe!)
     * - for jede Zelle: n = count_neighbors(g, i, j)
     *   lebendig ('0'): n==2||n==3 → '0', sonst ' '
     *   tot (' '):      n==3       → '0', sonst ' '
     * - Ergebnis nach tmp, NICHT nach board (!)
     * - free_board(g)
     * - g->board = tmp
     * - return 0 (OK) oder -1 (malloc fail)
     */
    (void)g;
    return (0);
}
EOF
}

skel_print_board() {
cat << 'EOF'
void print_board(t_game *g)
{
    /*
     * TODO:
     * - for i in 0..height:
     *     for j in 0..width:
     *         putchar(board[i][j])
     *     putchar('\n')
     */
    (void)g;
}
EOF
}

skel_free_board() {
cat << 'EOF'
void free_board(t_game *g)
{
    /*
     * TODO:
     * - if (!g->board) return;
     * - for i in 0..height: if (board[i]) free(board[i])
     * - free(g->board)
     * - g->board = NULL  ← wichtig für init_game cleanup!
     */
    (void)g;
}
EOF
}

skel_main_func() {
cat << 'EOF'
int main(int argc, char **argv)
{
    /*
     * TODO:
     * - if (argc != 4) return 1
     * - t_game g;
     * - init_game(&g, argv)
     * - fill_board(&g)
     * - for i < g.iter: play(&g)
     * - print_board(&g)
     * - free_board(&g)
     * - return 0
     */
    (void)argc;
    (void)argv;
    return (0);
}
EOF
}

# ─── life.c generieren (eine Funktion = Skeleton, Rest = Lösung) ─────────────

generate_life_c() {
    local skip=$1

    {
        echo '#include "life.h"'
        echo '#include <stdio.h>'
        echo ''

        for fn in init_game fill_board count_neighbors play print_board free_board main_func; do
            if [ "$fn" = "$skip" ]; then
                eval "skel_${fn}"
            else
                eval "sol_${fn}"
            fi
            echo ''
        done
    } > "$WORK_DIR/life.c"
}

# ─── Test cases ──────────────────────────────────────────────────────────────

run_tests() {
    local ex=$1

    cd "$WORK_DIR" || return 1

    gcc -Wall -Wextra -Werror -std=c99 -o user_life life.c 2>/tmp/life_compile_err.txt
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Compilierung fehlgeschlagen:${NC}"
        cat /tmp/life_compile_err.txt
        return 1
    fi

    gcc -std=c99 -o ref_life "$REF_DIR/life.c" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}Referenz-Compile-Fehler${NC}"; return 1
    fi

    local pass=0 fail=0

    check() {
        local name="$1" input="$2" w="$3" h="$4" iter="$5"
        local ref user cmd_disp
        ref=$(printf '%s' "$input"  | ./ref_life "$w" "$h" "$iter" 2>/dev/null)
        user=$(printf '%s' "$input" | ./user_life "$w" "$h" "$iter" 2>/dev/null)
        [ -n "$input" ] && cmd_disp="echo '$input' | ./life $w $h $iter" \
                        || cmd_disp="echo ''        | ./life $w $h $iter"
        printf "  ${CYAN}%-46s${NC}" "$cmd_disp"
        if [ "$ref" = "$user" ]; then
            echo -e "${GREEN}✓${NC}"; pass=$((pass+1))
        else
            echo -e "${RED}✗${NC}"
            echo -e "    ${YELLOW}erwartet:${NC} $(printf '%s' "$ref"  | cat -A | head -4 | sed 's/^/      /')"
            echo -e "    ${RED}bekommen:${NC} $(printf '%s' "$user" | cat -A | head -4 | sed 's/^/      /')"
            fail=$((fail+1))
        fi
    }

    case $ex in
        "init_game")
            check "leeres Board 3x3"   ""  3 3 0
            check "leeres Board 5x5"   ""  5 5 0
            check "leeres Board 1x1"   ""  1 1 0
            ;;
        "fill_board")
            check "dxss (Blinker)"     "dxss"        3 3 0
            check "sdxddssaaww"        "sdxddssaaww" 5 5 0
            check "x markiert (0,0)"   "x"            3 3 0
            check "toggle xsxsx"       "xsxsx"        3 3 0
            check "ungültige Zeichen"  "sXdYxZs"      3 3 0
            check "bounds top-left"    "wwwaaa"        3 3 0
            ;;
        "count_neighbors")
            check "Blinker 1 iter"     "dxss"        3 3 1
            check "Blinker 2 iter"     "dxss"        3 3 2
            check "subject 1 iter"     "sdxddssaaww" 5 5 1
            ;;
        "play")
            check "Blinker → horiz"    "dxss"        3 3 1
            check "Blinker → zurück"   "dxss"        3 3 2
            check "Blinker 10 iter"    "dxss"        5 5 10
            check "2x2 still (1 iter)" "xdsa"        4 4 1
            check "subject 1 iter"     "sdxddssaaww" 5 5 1
            check "subject 5 iter"     "sdxddssaaww" 5 5 5
            ;;
        "print_board")
            check "x → einzel '0'"     "x"            3 3 0
            check "leeres Board"       ""             3 3 0
            check "nach Blinker"       "dxss"         3 3 0
            check "subject 0 iter"     "sdxddssaaww"  5 5 0
            ;;
        "free_board")
            check "Blinker 1 iter"     "dxss"         3 3 1
            check "subject 3 iter"     "sdxddssaaww"  5 5 3
            # valgrind
            printf "  %-38s" "[valgrind no leaks]"
            if command -v valgrind &>/dev/null; then
                vg=$(printf '%s' 'sdxddssaaww' | valgrind \
                    --leak-check=full --error-exitcode=42 -q \
                    ./user_life 5 5 1 2>&1)
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✓${NC}"; pass=$((pass+1))
                else
                    echo -e "${RED}✗${NC}"
                    echo "$vg" | grep -E "lost:|ERROR" | head -3 | sed 's/^/    /'
                    fail=$((fail+1))
                fi
            else
                echo -e "${YELLOW}skipped (kein valgrind)${NC}"
            fi
            ;;
        "main_func")
            # argc check
            printf "  %-38s" "[falsche argc → return 1]"
            ./user_life 2>/dev/null; ec=$?
            [ $ec -ne 0 ] && { echo -e "${GREEN}✓${NC}"; pass=$((pass+1)); } \
                           || { echo -e "${RED}✗ (exit $ec, erwartet != 0)${NC}"; fail=$((fail+1)); }

            check "volles Programm 0 iter"  ""            3 3 0
            check "volles Programm 1 iter"  "dxss"        3 3 1
            check "subject 1 iter"          "sdxddssaaww" 5 5 1
            ;;
    esac

    echo ""
    if [ $fail -eq 0 ]; then
        echo -e "${GREEN}Alle $pass Tests bestanden ✓${NC}"
        return 0
    else
        echo -e "${RED}$fail/$((pass+fail)) Tests fehlgeschlagen${NC}"
        return 1
    fi
}

# ─── Skeleton zeigen ─────────────────────────────────────────────────────────

show_skeleton() {
    local ex=$1
    echo -e "${YELLOW}Was du schreiben sollst:${NC}"
    echo "────────────────────────────────────────────────────"
    eval "skel_${ex}"
    echo "────────────────────────────────────────────────────"
}

# ─── Lösung zeigen ───────────────────────────────────────────────────────────

show_solution() {
    local ex=$1
    echo ""
    echo -e "${YELLOW}💡 Lösung:${NC}"
    echo "────────────────────────────────────────────────────"
    eval "sol_${ex}"
    echo "────────────────────────────────────────────────────"
}

# ─── Übung ausführen ─────────────────────────────────────────────────────────

run_exercise() {
    local ex=$1
    local name
    name=$(get_name "$ex")

    setup_work_dir
    generate_life_c "$ex"

    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║  ÜBUNG: ${CYAN}$name${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        show_skeleton "$ex"
        echo ""
        echo -e "  Datei: ${CYAN}$WORK_DIR/life.c${NC}"
        echo -e "  ${GREEN}(alle anderen Funktionen laufen bereits!)${NC}"
        echo ""

        code "$WORK_DIR/life.c" 2>/dev/null &

        echo -e "${CYAN}ENTER wenn bereit zum Testen...${NC}"
        read -r

        echo ""
        run_tests "$ex"
        local result=$?
        echo ""

        if [ $result -eq 0 ]; then
            echo -e "${GREEN}✅ Richtig!  [n] Nächste  [r] Nochmal  [b] Menü${NC}"
        else
            echo -e "${CYAN}[s] Lösung  [r] Nochmal  [n] Nächste  [b] Menü${NC}"
        fi

        echo -ne "${CYAN}Wahl: ${NC}"
        read -r choice
        case $choice in
            s)
                show_solution "$ex"
                echo ""
                echo -e "${CYAN}[c] In life.c kopieren  [r] Nochmal  [n] Nächste  [b] Menü${NC}"
                echo -ne "${CYAN}Wahl: ${NC}"
                read -r c2
                if [ "$c2" = "c" ]; then
                    generate_life_c "none"
                    echo -e "${GREEN}Lösung in life.c kopiert${NC}"
                    echo -e "${CYAN}ENTER...${NC}"; read -r
                fi
                [ "$c2" = "n" ] && return 1   # 1 = weiter zur nächsten Übung
                [ "$c2" = "b" ] && return 0
                ;;
            n) return 1 ;;   # 1 = weiter zur nächsten Übung
            b) return 0 ;;
            q) exit 0 ;;
        esac
    done
}

# ─── Setup ───────────────────────────────────────────────────────────────────

setup_work_dir() {
    rm -rf "$WORK_DIR"
    mkdir -p "$WORK_DIR"
    write_header
}

# ─── Theorie ─────────────────────────────────────────────────────────────────

show_theory_board() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           BOARD & KOORDINATEN                                ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}./life WIDTH HEIGHT ITERATIONS${NC}"
    echo -e "  argv[1] = ${GREEN}width${NC}   (Spalten, j-Achse)"
    echo -e "  argv[2] = ${GREEN}height${NC}  (Zeilen,  i-Achse)"
    echo -e "  argv[3] = ${GREEN}iter${NC}    (Iterationen)"
    echo ""
    echo -e "  ${BLUE}board[i][j]  =  board[Zeile][Spalte]  =  board[y][x]${NC}"
    echo ""
    echo -e "  board[0][0]  board[0][1]  board[0][2]"
    echo -e "  board[1][0]  board[1][1]  board[1][2]"
    echo -e "  board[2][0]  board[2][1]  board[2][2]"
    echo ""
    echo -e "${YELLOW}Struct (kein dead/alive Member — direkt ' ' und '0' verwenden!):${NC}"
    echo -e "  ${GREEN}typedef struct s_game {${NC}"
    echo -e "  ${GREEN}    int width, height, iter;${NC}"
    echo -e "  ${GREEN}    int i, j, draw;   // Stift-Position + draw-Flag${NC}"
    echo -e "  ${GREEN}    char **board;     // board[y][x]${NC}"
    echo -e "  ${GREEN}} t_game;${NC}"
    echo ""
    echo -e "${YELLOW}Malloc 2D Array:${NC}"
    echo -e "  ${GREEN}board = malloc(height * sizeof(char*));  // äußer = height!${NC}"
    echo -e "  ${GREEN}for i: board[i] = malloc(width * sizeof(char));${NC}"
    echo -e "  ${GREEN}for i,j: board[i][j] = ' ';  // mit Leerzeichen initialisieren${NC}"
    echo ""
}

show_theory_commands() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           STDIN COMMANDS — Stift-Steuerung                   ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}w${NC} → i--  (hoch)    Bound: i > 0"
    echo -e "  ${GREEN}s${NC} → i++  (runter)  Bound: i < height-1"
    echo -e "  ${GREEN}a${NC} → j--  (links)   Bound: j > 0"
    echo -e "  ${GREEN}d${NC} → j++  (rechts)  Bound: j < width-1"
    echo -e "  ${GREEN}x${NC} → draw = !draw   (toggle)"
    echo ""
    echo -e "${YELLOW}Nach jedem Command: wenn draw==1 → board[i][j] = '0'${NC}"
    echo ""
    echo -e "  ${GREEN}default: flag = 1; break;${NC}"
    echo -e "  ${GREEN}if (flag) continue;   ← NIEMALS flag zurücksetzen!${NC}"
    echo -e "  ${GREEN}if (draw) board[i][j] = '0';${NC}"
    echo ""
    echo -e "${RED}FALLE 1: else-branch löscht Zellen → KEIN else! Nur zeichnen, nie löschen.${NC}"
    echo -e "${RED}FALLE 2: flag=0 nach default → flag BLEIBT 1 für immer nach ungültigem Char.${NC}"
    echo ""
    echo -e "${YELLOW}Beispiel: echo 'dxss' | ./life 3 3 0${NC}"
    echo -e "  d → (0,1) draw=0: nichts"
    echo -e "  x → draw=1, markiert (0,1)='0'  ← x markiert auch!"
    echo -e "  s → (1,1) draw=1, markiert (1,1)='0'"
    echo -e "  s → (2,1) draw=1, markiert (2,1)='0'"
    echo -e "  Output: ${GREEN} 0  / 0  / 0  ${NC}  (Spalte 1)"
    echo ""
}

show_theory_rules() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           GAME OF LIFE — Die 4 Regeln                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Für jede Zelle: n = Anzahl lebender Nachbarn (alle 8, inkl. Diagonal)${NC}"
    echo ""
    echo -e "  ${GREEN}if (board[i][j] == '0')   // lebendig${NC}"
    echo -e "  ${GREEN}    n==2 || n==3 → bleibt '0'${NC}"
    echo -e "  ${GREEN}    sonst        → wird ' '${NC}"
    echo -e "  ${GREEN}else                      // tot${NC}"
    echo -e "  ${GREEN}    n==3         → wird '0'${NC}"
    echo -e "  ${GREEN}    sonst        → bleibt ' '${NC}"
    echo ""
    echo -e "${YELLOW}Nachbarn: dy/dx jeweils -1..+1, (0,0) skippen, bounds prüfen${NC}"
    echo -e "  ${BLUE}(i-1,j-1) (i-1,j) (i-1,j+1)${NC}"
    echo -e "  ${BLUE}(i,  j-1) [i,j]  (i,  j+1)${NC}"
    echo -e "  ${BLUE}(i+1,j-1) (i+1,j) (i+1,j+1)${NC}"
    echo ""
    echo -e "${YELLOW}Blinker (klassisch):${NC}"
    echo -e "  Iter 0 (vertikal):   Iter 1 (horizontal):   Iter 2 (zurück):"
    echo -e "  ${GREEN} 0               000               0  ${NC}"
    echo -e "  ${GREEN} 0                                  0  ${NC}"
    echo -e "  ${GREEN} 0                                  0  ${NC}"
    echo ""
    echo -e "${RED}Alle Regeln auf ALTEM Board anwenden → Temp-Board nötig!${NC}"
    echo ""
}

show_theory_temp() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           WARUM TEMP-BOARD?                                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}Problem ohne temp:${NC} Wenn board[0][1] geändert wird, beeinflusst"
    echo -e "das die Nachbarn-Zählung von board[1][1] → falsches Ergebnis!"
    echo ""
    echo -e "${GREEN}Lösung:${NC}"
    echo -e "  1. tmp = malloc (gleiche Größe)"
    echo -e "  2. Regeln auf ALTEM board berechnen → Ergebnis in tmp"
    echo -e "  3. free_board(g)        // altes Board löschen"
    echo -e "  4. g->board = tmp       // neues Board übernehmen"
    echo ""
    echo -e "${YELLOW}Code:${NC}"
    echo -e "  ${GREEN}char **tmp = malloc(g->height * sizeof(char *));${NC}"
    echo -e "  ${GREEN}for i: tmp[i] = malloc(g->width * sizeof(char));${NC}"
    echo -e "  ${GREEN}for i,j:${NC}"
    echo -e "  ${GREEN}    n = count_neighbors(g, i, j);   // liest g->board!${NC}"
    echo -e "  ${GREEN}    if (g->board[i][j] == '0')${NC}"
    echo -e "  ${GREEN}        tmp[i][j] = (n==2||n==3) ? '0' : ' ';${NC}"
    echo -e "  ${GREEN}    else${NC}"
    echo -e "  ${GREEN}        tmp[i][j] = (n==3) ? '0' : ' ';${NC}"
    echo -e "  ${GREEN}free_board(g); g->board = tmp;${NC}"
    echo ""
}

show_theory_structure() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           STRUKTUR — 6 Funktionen + main                     ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}① init_game()${NC}       → argv→struct, board malloc'en mit ' '"
    echo -e "  ${GREEN}② fill_board()${NC}      → stdin lesen, Stift, draw-Flag"
    echo -e "  ${GREEN}③ count_neighbors()${NC} → 8 Nachbarn, bounds, return count"
    echo -e "  ${GREEN}④ play()${NC}            → temp Board, Regeln, free+swap"
    echo -e "  ${GREEN}⑤ print_board()${NC}     → putchar jede Zelle + '\\n'"
    echo -e "  ${GREEN}⑥ free_board()${NC}      → free jede Zeile, dann Array, dann NULL"
    echo ""
    echo -e "${YELLOW}main() Flow:${NC}"
    echo -e "  ${GREEN}if (argc != 4) return 1;${NC}"
    echo -e "  ${GREEN}t_game g; init_game(&g, argv);${NC}"
    echo -e "  ${GREEN}fill_board(&g);${NC}"
    echo -e "  ${GREEN}for (i < g.iter) play(&g);${NC}"
    echo -e "  ${GREEN}print_board(&g);${NC}"
    echo -e "  ${GREEN}free_board(&g);${NC}"
    echo ""
    echo -e "${YELLOW}Zeitplan Exam (~30 Min):${NC}"
    echo -e "  life.h + struct  5 min  |  count_neighbors  4 min"
    echo -e "  init_game        5 min  |  play              8 min"
    echo -e "  fill_board       8 min  |  print/free/main   5 min → testen"
    echo ""
}

# ─── Übung-Kette: [n] springt direkt zur nächsten ────────────────────────────

run_from_index() {
    local idx=$1
    while [ "$idx" -lt "${#exercises[@]}" ]; do
        run_exercise "${exercises[$idx]}"
        local r=$?
        [ $r -eq 1 ] && idx=$((idx + 1)) || break
    done
}

# ─── Hauptmenü ───────────────────────────────────────────────────────────────

main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║           LIFE TRAINER - Conway's Game of Life (C)           ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}Theorie (erst lesen!):${NC}"
        echo -e "  ${GREEN}t1${NC}) Board & Koordinaten (struct, kein dead/alive!)"
        echo -e "  ${GREEN}t2${NC}) Stdin-Commands (w/a/s/d/x, draw-Flag, Fallen!)"
        echo -e "  ${GREEN}t3${NC}) Game of Life Regeln (4 Regeln + Blinker)"
        echo -e "  ${GREEN}t4${NC}) Warum Temp-Board? (häufigster Bug)"
        echo -e "  ${GREEN}t5${NC}) Struktur (6 Funktionen + main Flow + Zeitplan)"
        echo ""
        echo -e "${YELLOW}Übungen:${NC}"
        local i=1
        for ex in "${exercises[@]}"; do
            printf "  ${GREEN}%d${NC}) %s\n" $i "$(get_name "$ex")"
            ((i++))
        done
        echo ""
        echo -e "  ${GREEN}r${NC}) Zufällig   ${GREEN}q${NC}) Beenden"
        echo ""
        echo -ne "${CYAN}Wahl: ${NC}"
        read -r choice

        case $choice in
            t1) show_theory_board;     echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t2) show_theory_commands;  echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t3) show_theory_rules;     echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t4) show_theory_temp;      echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            t5) show_theory_structure; echo ""; echo -e "${CYAN}Enter...${NC}"; read -r ;;
            r)
                local rand=$((RANDOM % ${#exercises[@]}))
                run_from_index "$rand"
                ;;
            q) exit 0 ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#exercises[@]}" ]; then
                    run_from_index "$((choice - 1))"
                else
                    echo -e "${RED}Ungültig${NC}"; sleep 1
                fi
                ;;
        esac
    done
}

main_menu
