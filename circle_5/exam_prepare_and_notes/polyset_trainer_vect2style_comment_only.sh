#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/polyset_training"
TEMPLATE_DIR="$SCRIPT_DIR/.resources/rank05/level1/polyset"

CXX="c++"
CXXFLAGS="-std=c++11 -Wall -Wextra -Werror"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m"

die() { echo -e "${RED}ERROR:${NC} $*" >&2; exit 1; }
cleanup() { rm -rf "$WORK_DIR"; }

setup_base() {
  cleanup
  mkdir -p "$WORK_DIR"
  [[ -d "$TEMPLATE_DIR" ]] || die "Template dir not found: $TEMPLATE_DIR"

  # Copy full working template into /tmp (robust)
  if ! cp -a "$TEMPLATE_DIR"/. "$WORK_DIR/"; then
    die "Failed to copy template files from: $TEMPLATE_DIR"
  fi

  # Ensure subject base headers/sources are available at root for includes/compile
  if [[ -d "$WORK_DIR/subject" ]]; then
    cp "$WORK_DIR/subject"/*.hpp "$WORK_DIR/" 2>/dev/null || true
    cp "$WORK_DIR/subject"/*.cpp "$WORK_DIR/" 2>/dev/null || true
  fi
}

# Write COMMENT-ONLY skeleton for exactly ONE target file
write_skeleton_for() {
  local file="$1"

  case "$file" in
    searchable_array_bag.hpp)
      cat > "$WORK_DIR/$file" <<'EOF'
#pragma once
#include "array_bag.hpp"
#include "searchable_bag.hpp"

/*
TASK:
 - Define class searchable_array_bag
 - Inherit from:
     public array_bag
     public searchable_bag
 - Implement canonical form
 - Implement: bool has(int) const

HINT:
 - Iterate over array_bag internal storage
*/

// WRITE EVERYTHING YOURSELF BELOW
EOF
      ;;

    searchable_array_bag.cpp)
      cat > "$WORK_DIR/$file" <<'EOF'
#include "searchable_array_bag.hpp"

/*
TASK:
 - Implement searchable_array_bag methods
HINT:
 - has(x): linear search
*/
EOF
      ;;

    searchable_tree_bag.hpp)
      cat > "$WORK_DIR/$file" <<'EOF'
#pragma once
#include "tree_bag.hpp"
#include "searchable_bag.hpp"

/*
TASK:
 - Define class searchable_tree_bag
 - Inherit from:
     public tree_bag
     public searchable_bag
 - Implement canonical form
 - Implement: bool has(int) const

HINT:
 - Traverse tree_bag internal tree
*/

// WRITE EVERYTHING YOURSELF BELOW
EOF
      ;;

    searchable_tree_bag.cpp)
      cat > "$WORK_DIR/$file" <<'EOF'
#include "searchable_tree_bag.hpp"

/*
TASK:
 - Implement searchable_tree_bag methods
HINT:
 - tree traversal
*/
EOF
      ;;

    set.hpp)
      cat > "$WORK_DIR/$file" <<'EOF'
#pragma once
#include "searchable_bag.hpp"

/*
TASK:
 - Define class set
 - Wrap searchable_bag&
 - Enforce SET behavior (no duplicates)

HINT:
 - insert(x): if (!bag.has(x)) bag.insert(x);
*/

// WRITE EVERYTHING YOURSELF BELOW
EOF
      ;;

    set.cpp)
      cat > "$WORK_DIR/$file" <<'EOF'
#include "set.hpp"

/*
TASK:
 - Implement set methods
*/
EOF
      ;;

    *) die "Unknown exercise file: $file" ;;
  esac
}

write_harness_main() {
  # IMPORTANT: harness uses the full project types.
  # This only works if *other* files remain from template (solution-ready).
  cat > "$WORK_DIR/main.cpp" <<'EOF'
#include "bag.hpp"
#include "array_bag.hpp"
#include "tree_bag.hpp"
#include "searchable_array_bag.hpp"
#include "searchable_tree_bag.hpp"
#include "set.hpp"

int main() {
    searchable_array_bag sab;
    searchable_tree_bag  stb;

    set s1(sab);
    set s2(stb);

    s1.insert(42);
    s1.insert(42);
    s2.insert(7);

    s1.print();
    s2.clear();
    return 0;
}
EOF
}

compile_all() {
  # Collect all cpp EXCEPT main.cpp (because we pass it explicitly once)
  mapfile -t cpp < <(find "$WORK_DIR" -maxdepth 1 -name "*.cpp" ! -name "main.cpp" -print)

  set +e
  output="$($CXX $CXXFLAGS "$WORK_DIR/main.cpp" "${cpp[@]}" -o "$WORK_DIR/.bin" 2>&1)"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]]; then
    echo -e "${RED}✗ COMPILATION FAILED${NC}"
    echo "$output"
  else
    echo -e "${GREEN}✓ COMPILATION OK${NC}"
  fi
}

exercise() {
  local file="$1"

  setup_base
  write_skeleton_for "$file"   # <-- ONLY THIS FILE becomes skeleton
  write_harness_main

  clear
  echo -e "${CYAN}Editing:${NC} $WORK_DIR/$file"
  echo ""
  echo "Controls:"
  echo "  ENTER  -> compile"
  echo "  r      -> reset this exercise"
  echo "  b      -> back to menu"
  echo ""
  echo "Open file with:"
  echo "  nano $WORK_DIR/$file"
  echo ""

  while true; do
    echo -ne "${CYAN}> ${NC}"
    read -r key || true
    case "${key:-}" in
      "") compile_all ;;
      r|R)
        setup_base
        write_skeleton_for "$file"
        write_harness_main
        echo -e "${YELLOW}Reset done.${NC}"
        ;;
      b|B) break ;;
    esac
  done
}

while true; do
  clear
  echo "=========== POLYSET TRAINER ==========="
  echo "Workdir: $WORK_DIR"
  echo ""
  echo "[1] searchable_array_bag.hpp"
  echo "[2] searchable_array_bag.cpp"
  echo "[3] searchable_tree_bag.hpp"
  echo "[4] searchable_tree_bag.cpp"
  echo "[5] set.hpp"
  echo "[6] set.cpp"
  echo "[q] quit"
  echo ""
  echo -ne "Choice: "
  read -r c

  case "$c" in
    1) exercise searchable_array_bag.hpp ;;
    2) exercise searchable_array_bag.cpp ;;
    3) exercise searchable_tree_bag.hpp ;;
    4) exercise searchable_tree_bag.cpp ;;
    5) exercise set.hpp ;;
    6) exercise set.cpp ;;
    q|Q) exit 0 ;;
  esac
done
