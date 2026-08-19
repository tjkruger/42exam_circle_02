#!/bin/bash

# ============================================================================
# LIFE TESTER - 42 School Rank05 Exam
# Conway's Game of Life - automated correctness tester
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_DIR="$SCRIPT_DIR/rendu/life"
REF_DIR="$SCRIPT_DIR/.resources/rank05/level2/life"

PASS=0
FAIL=0
declare -a FAILED_TESTS

# ─── Setup ────────────────────────────────────────────────────────────────────

if [ ! -d "$USER_DIR" ]; then
    echo -e "${RED}FAIL: Directory $USER_DIR not found${NC}"
    echo -e "${YELLOW}  Create it with: mkdir -p rendu/life${NC}"
    exit 1
fi

c_files=$(find "$USER_DIR" -name "*.c" -type f)
h_files=$(find "$USER_DIR" -name "*.h" -type f)
if [ -z "$c_files" ] || [ -z "$h_files" ]; then
    echo -e "${RED}FAIL: No .c or .h files found in $USER_DIR${NC}"
    exit 1
fi

TMP=$(mktemp -d)
mkdir "$TMP/ref" "$TMP/user"

# Reference (use separate dir to avoid filename conflicts)
cp "$REF_DIR/life.c" "$TMP/ref/"
cp "$REF_DIR/life.h" "$TMP/ref/"

# User files
find "$USER_DIR" -name "*.c" -o -name "*.h" | while read -r f; do cp "$f" "$TMP/user/"; done

# Compile reference
gcc -Wall -Wextra -Werror -std=c99 -o "$TMP/ref/life" "$TMP/ref/life.c" 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}FAIL: Reference compilation failed (bug in .resources/life.c)${NC}"
    rm -rf "$TMP"; exit 1
fi

# Compile user
gcc -Wall -Wextra -Werror -std=c99 -o "$TMP/user/life" "$TMP/user/"*.c 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}FAIL: Compilation failed!${NC}"
    echo -e "${YELLOW}  Compiler output:${NC}"
    gcc -Wall -Wextra -Werror -std=c99 -o "$TMP/user/life" "$TMP/user/"*.c 2>&1 | head -20 | sed 's/^/  /'
    rm -rf "$TMP"; exit 1
fi

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║       LIFE TESTER - Conway's Game of Life                ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ─── Test runner ──────────────────────────────────────────────────────────────

run_test() {
    local name="$1"
    local input="$2"
    local w="$3"
    local h="$4"
    local iter="$5"

    local ref_out user_out
    ref_out=$(printf '%s' "$input" | "$TMP/ref/life" "$w" "$h" "$iter" 2>/dev/null)
    user_out=$(printf '%s' "$input" | "$TMP/user/life" "$w" "$h" "$iter" 2>/dev/null)

    printf "  %-42s" "[$name]"

    if [ "$ref_out" = "$user_out" ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}✗ FAIL${NC}"
        FAIL=$((FAIL + 1))
        FAILED_TESTS+=("$name")
        if [ -n "$input" ]; then
            echo -e "    ${YELLOW}input   :${NC} $input  (./life $w $h $iter)"
        else
            echo -e "    ${YELLOW}input   :${NC} (empty)  (./life $w $h $iter)"
        fi
        echo -e "    ${YELLOW}expected:${NC}"
        echo "$ref_out"  | head -6 | sed 's/^/      |/'
        echo -e "    ${RED}got     :${NC}"
        echo "$user_out" | head -6 | sed 's/^/      |/'
        echo ""
    fi
}

# ─── Tests ────────────────────────────────────────────────────────────────────

echo -e "${BLUE}── Drawing / fill_board ────────────────────────────────────${NC}"

run_test "empty board"               ""              3  3  0
run_test "x marks 0,0"               "x"             3  3  0
run_test "subject: sdxddssaaww"      "sdxddssaaww"   5  5  0
run_test "blinker vertical"          "dxss"          3  3  0
run_test "2x2 block"                 "xdsa"          4  4  0
run_test "L-shape"                   "xsssdwww"      5  5  0
run_test "toggle off→on→off"         "xsxsx"         3  3  0
run_test "many x toggles"            "xsxsxsxs"      3  3  0
run_test "ignore invalid chars"      "sXdYxZs"       3  3  0
run_test "bounds: past top-left"     "wwwaaa"         3  3  0
run_test "bounds: past bottom-right" "sssssdddddx"   3  3  0

echo ""
echo -e "${BLUE}── Game of Life rules (iterations) ─────────────────────────${NC}"

run_test "blinker → horizontal"       "dxss"          3  3  1
run_test "blinker → back vertical"    "dxss"          3  3  2
run_test "blinker period 10"          "dxss"          5  5  10
run_test "2x2 still life (1 iter)"    "xdsa"          4  4  1
run_test "2x2 still life (5 iter)"    "xdsa"          4  4  5
run_test "subject example (1 iter)"   "sdxddssaaww"   5  5  1
run_test "subject example (3 iter)"   "sdxddssaaww"   5  5  3
run_test "subject example (10 iter)"  "sdxddssaaww"   5  5  10
run_test "complex 0 iter"             "sdxssdswdxddddsxaadwxwdxwaa"  10 6  0
run_test "complex 5 iter"             "sdxssdswdxddddsxaadwxwdxwaa"  10 6  5
run_test "large board 20 iter"        "sdxddssaaww"   10 10 20

echo ""
echo -e "${BLUE}── Edge cases ──────────────────────────────────────────────${NC}"

run_test "1x1 board empty"            ""              1  1  0
run_test "1x1 board alive"            "x"             1  1  0
run_test "1x1 alive 5 iter (dies)"    "x"             1  1  5
run_test "1-column board"             "xssss"         1  6  0
run_test "1-column 1 iter"            "xssss"         1  6  1
run_test "1-row board"                "xdddd"         6  1  0
run_test "1-row 1 iter"               "xdddd"         6  1  1
run_test "0 iter large board"         "sdxddssaaww"   20 20 0

# ─── Memory ───────────────────────────────────────────────────────────────────

echo ""
echo -e "${BLUE}── Memory (valgrind) ───────────────────────────────────────${NC}"

printf "  %-42s" "[no leaks]"
if command -v valgrind &>/dev/null; then
    vg_out=$(printf '%s' 'sdxddssaaww' | valgrind \
        --leak-check=full --show-leak-kinds=all \
        --error-exitcode=42 -q \
        "$TMP/user/life" 5 5 1 2>&1)
    vg_exit=$?
    if [ $vg_exit -eq 0 ] && ! echo "$vg_out" | grep -qE "definitely lost: [^0]|ERROR SUMMARY: [^0]"; then
        echo -e "${GREEN}✓ PASS${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}✗ FAIL (memory leaks/errors)${NC}"
        FAIL=$((FAIL + 1))
        FAILED_TESTS+=("valgrind")
        echo "$vg_out" | grep -E "lost:|ERROR SUMMARY" | head -5 | sed 's/^/    /'
    fi
else
    echo -e "${YELLOW}⚠ skipped (valgrind not found)${NC}"
fi

# ─── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
TOTAL=$((PASS + FAIL))
if [ $FAIL -eq 0 ]; then
    echo -e "${CYAN}║${NC}  ${GREEN}ALL $TOTAL TESTS PASSED${NC} 🎉"
else
    echo -e "${CYAN}║${NC}  ${RED}$FAIL / $TOTAL TESTS FAILED${NC}"
    echo -e "${CYAN}║${NC}  ${YELLOW}→ ${FAILED_TESTS[*]}${NC}"
fi
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

rm -rf "$TMP"
[ $FAIL -eq 0 ] && exit 0 || exit 1
