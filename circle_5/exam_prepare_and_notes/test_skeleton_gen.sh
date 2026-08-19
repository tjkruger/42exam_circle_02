#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/test_vect2"
mkdir -p "$WORK_DIR"

# Base skeleton
base=$(cat << 'BASE'
#include "vect2.hpp"

vect2::vect2()
{
    this->x = 0;
    this->y = 0;
}

vect2::vect2(int num1, int num2)
{
    this->x = num1;
    this->y = num2;
}

vect2::vect2(const vect2& source)
{
    *this = source;
}

vect2::~vect2()
{
}

vect2& vect2::operator=(const vect2& source)
{
    if(this != &source)
    {
        this->x = source.x;
        this->y = source.y;
    }
    return(*this);
}

int vect2::operator[](int index) const
{
    if(index == 0)
        return(this->x);
    return(this->y);
}

int& vect2::operator[](int index)
{
    if(index == 0)
        return(this->x);
    return(this->y);
}
BASE
)

# Test operator_unary_minus
echo "$base" > "$WORK_DIR/vect2.cpp"
cat >> "$WORK_DIR/vect2.cpp" << 'EOF'

// ============================================================================
// TODO: SCHREIB operator-() HIER!
// ============================================================================

// vect2 vect2::operator-() const
// {
//     // Returniere neues vect2 mit -x und -y
// }
EOF

echo "==== Generated vect2.cpp for operator_unary_minus ===="
cat "$WORK_DIR/vect2.cpp"

echo ""
echo "==== Test compilation (should FAIL) ===="
cp $SCRIPT_DIR/.resources/rank05/level1/vect2/vect2.hpp "$WORK_DIR/"
cat > "$WORK_DIR/main.cpp" << 'MAIN'
#include "vect2.hpp"
#include <iostream>

int main()
{
    vect2 v(5, -3);
    vect2 neg = -v;
    std::cout << neg[0] << " " << neg[1] << std::endl;
    return 0;
}
MAIN

cd "$WORK_DIR"
c++ -Wall -Wextra -Werror -std=c++98 main.cpp vect2.cpp -o test 2>&1
