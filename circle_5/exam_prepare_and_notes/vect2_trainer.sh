#!/bin/bash

# vect2_trainer.sh - Interactive vect2 Training
# Write code, compile, test!

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/vect2_training"
TEMPLATE_DIR="$SCRIPT_DIR/.resources/rank05/level1/vect2"

# Cleanup
cleanup() {
    rm -rf "$WORK_DIR"
}

# Setup
setup() {
    cleanup
    mkdir -p "$WORK_DIR"
    
    # Copy original files
    cp "$TEMPLATE_DIR/vect2.hpp" "$WORK_DIR/"
    
    # Copy main test file
    cat > "$WORK_DIR/main.cpp" << 'EOF'
#include "vect2.hpp"
#include <iostream>

int main()
{
    // Test will be inserted dynamically
    return 0;
}
EOF
}

# Function exercises (only the relevant ones!)
exercises=(
    "default_constructor"
    "param_constructor"
    "copy_constructor"
    "assignment_operator"
    "operator_bracket_const"
    "operator_bracket_nonconst"
    "operator_unary_minus"
    "operator_multiply_scalar"
    "operator_multiply_assign_scalar"
    "operator_plus_assign"
    "operator_plus"
    "operator_prefix_increment"
    "operator_postfix_increment"
    "operator_equal"
    "operator_notequal"
    "operator_multiply_left"
    "operator_output"
)

# Exercise details
get_exercise_name() {
    case $1 in
        "default_constructor") echo "Default Constructor: vect2()" ;;
        "param_constructor") echo "Constructor: vect2(int, int)" ;;
        "copy_constructor") echo "Copy Constructor" ;;
        "assignment_operator") echo "operator=" ;;
        "operator_bracket_const") echo "operator[] const" ;;
        "operator_bracket_nonconst") echo "operator[] non-const" ;;
        "operator_unary_minus") echo "operator-() unary" ;;
        "operator_multiply_scalar") echo "operator*(int) scalar" ;;
        "operator_multiply_assign_scalar") echo "operator*=(int)" ;;
        "operator_plus_assign") echo "operator+=(vect2)" ;;
        "operator_plus") echo "operator+(vect2)" ;;
        "operator_prefix_increment") echo "operator++() prefix" ;;
        "operator_postfix_increment") echo "operator++(int) postfix" ;;
        "operator_equal") echo "operator==(vect2)" ;;
        "operator_notequal") echo "operator!=(vect2)" ;;
        "operator_multiply_left") echo "operator*(int, vect2) NON-MEMBER" ;;
        "operator_output") echo "operator<< NON-MEMBER" ;;
    esac
}

get_exercise_skeleton() {
    case $1 in
        "default_constructor")
            cat << 'SKEL'
vect2::vect2()
{
    // Initialize x and y with 0
}
SKEL
            ;;
        "param_constructor")
            cat << 'SKEL'
vect2::vect2(int num1, int num2)
{
    // Set x = num1, y = num2
}
SKEL
            ;;
        "copy_constructor")
            cat << 'SKEL'
vect2::vect2(const vect2& source)
{
    // Copy source to *this
}
SKEL
            ;;
        "assignment_operator")
            cat << 'SKEL'
vect2& vect2::operator=(const vect2& source)
{
    // Self-assignment check
    // Copy source.x and source.y
    // return *this
}
SKEL
            ;;
        "operator_bracket_const")
            cat << 'SKEL'
int vect2::operator[](int index) const
{
    // if index == 0 return x, else return y
}
SKEL
            ;;
        "operator_bracket_nonconst")
            cat << 'SKEL'
int& vect2::operator[](int index)
{
    // if index == 0 return x, else return y
    // ATTENTION: Return-Type is int& (Reference!)
}
SKEL
            ;;
        "operator_unary_minus")
            cat << 'SKEL'
vect2 vect2::operator-() const
{
    // Return new vect2 with -x and -y
}
SKEL
            ;;
        "operator_multiply_scalar")
            cat << 'SKEL'
vect2 vect2::operator*(int num) const
{
    // Multiply x and y with num, return new vect2
}
SKEL
            ;;
        "operator_multiply_assign_scalar")
            cat << 'SKEL'
vect2& vect2::operator*=(int num)
{
    // Multiply this->x and this->y with num
    // return *this
}
SKEL
            ;;
        "operator_plus_assign")
            cat << 'SKEL'
vect2& vect2::operator+=(const vect2& obj)
{
    // Add obj.x to this->x, obj.y to this->y
    // return *this
}
SKEL
            ;;
        "operator_plus")
            cat << 'SKEL'
vect2 vect2::operator+(const vect2& obj) const
{
    // Create temp = *this
    // temp += obj (operator+= is already there!)
    // return temp
}
SKEL
            ;;
        "operator_prefix_increment")
            cat << 'SKEL'
vect2& vect2::operator++()
{
    // ++x und ++y
    // return *this
}
SKEL
            ;;
        "operator_postfix_increment")
            cat << 'SKEL'
vect2 vect2::operator++(int)
{
    // Save old value in temp
    // Call ++(*this) (prefix is already there!)
    // Return temp
}
SKEL
            ;;
        "operator_equal")
            cat << 'SKEL'
bool vect2::operator==(const vect2& obj) const
{
    // Return true if x == obj.x AND y == obj.y
}
SKEL
            ;;
        "operator_notequal")
            cat << 'SKEL'
bool vect2::operator!=(const vect2& obj) const
{
    // Return !(*this == obj)
    // operator== is already there!
}
SKEL
            ;;
        "operator_multiply_left")
            cat << 'SKEL'
⚠️  NON-MEMBER Function (outside the class!)
    At the END of vect2.cpp!

vect2 operator*(int num, const vect2& obj)
{
    // Return obj * num
    // member operator* is already there!
}
SKEL
            ;;
        "operator_output")
            cat << 'SKEL'
⚠️  NON-MEMBER Function (outside the class!)
    At the END of vect2.cpp!

std::ostream& operator<<(std::ostream& os, const vect2& obj)
{
    // os << "{ " << obj[0] << ", " << obj[1] << " }";
    // return os;
}
SKEL
            ;;
    esac
}

# Generate skeleton specific to exercise - only the target function is missing
generate_skeleton_for_exercise() {
    local ex=$1
    
    # Start with COMPLETE working vect2.cpp from resources
    cp "$TEMPLATE_DIR/vect2.cpp" "$WORK_DIR/vect2.cpp"
    
    # Now DELETE the specific function that should be practiced
    case $ex in
        "default_constructor")
            # Delete default constructor (lines ~3-7)
            sed -i '/^vect2::vect2()$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            # Make sure BOTH operator[] versions are present (needed for tests)
            ;;
        "param_constructor")
            # Delete parameterized constructor (lines ~9-13)
            sed -i '/^vect2::vect2(int num1, int num2)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            # Make sure BOTH operator[] versions are present
            ;;
        "copy_constructor")
            # Delete copy constructor (lines ~15-18)
            sed -i '/^vect2::vect2(const vect2& source)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            # Make sure BOTH operator[] versions are present
            ;;
        "assignment_operator")
            # Delete operator= (lines ~20-27)
            sed -i '/^vect2& vect2::operator=(const vect2& source)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            # Make sure BOTH operator[] versions are present
            ;;
        "operator_bracket_const")
            # Delete const operator[] (lines ~29-34)
            sed -i '/^int vect2::operator\[\](int index) const$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_bracket_nonconst")
            # Delete non-const operator[] (lines ~36-41)
            sed -i '/^int& vect2::operator\[\](int index)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_unary_minus")
            # Delete operator-() const function (lines ~43-49)
            sed -i '/^vect2 vect2::operator-() const$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_multiply_scalar")
            # Delete operator*(int) const function (lines ~52-59)
            sed -i '/^vect2 vect2::operator\*(int num) const$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_multiply_assign_scalar")
            # Delete operator*=(int) function (lines ~61-66)
            sed -i '/^vect2& vect2::operator\*=(int num)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_plus_assign")
            # Delete operator+=(vect2) function (lines ~68-73)
            sed -i '/^vect2& vect2::operator+=(const vect2& obj)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_plus")
            # Delete operator+(vect2) const function (lines ~90-96)
            sed -i '/^vect2 vect2::operator+(const vect2& obj) const$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_prefix_increment")
            # Delete operator++() function (lines ~115-120)
            sed -i '/^vect2& vect2::operator++()$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_postfix_increment")
            # Delete operator++(int) function (lines ~122-128)
            sed -i '/^vect2 vect2::operator++(int)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_equal")
            # Delete operator==(vect2) const function (lines ~145-150)
            sed -i '/^bool vect2::operator==(const vect2& obj) const$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_notequal")
            # Delete operator!=(vect2) const function (lines ~152-155)
            sed -i '/^bool vect2::operator!=(const vect2& obj) const$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_multiply_left")
            # Delete non-member operator*(int, vect2) function (lines ~169-175)
            sed -i '/^vect2 operator\*(int num, const vect2& obj)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
        "operator_output")
            # Delete non-member operator<<(ostream, vect2) function (lines ~160-165)
            sed -i '/^std::ostream& operator<<(std::ostream& os,const vect2& obj)$/,/^}$/d' "$WORK_DIR/vect2.cpp"
            ;;
    esac
}

get_test_code() {
    case $1 in
        "default_constructor")
            echo '    vect2 v;'
            echo '    std::cout << v[0] << " " << v[1] << std::endl;'
            ;;
        "param_constructor")
            echo '    vect2 v(5, 10);'
            echo '    std::cout << v[0] << " " << v[1] << std::endl;'
            ;;
        "copy_constructor")
            echo '    vect2 v1(3, 7);'
            echo '    vect2 v2(v1);'
            echo '    std::cout << v2[0] << " " << v2[1] << std::endl;'
            ;;
        "assignment_operator")
            echo '    vect2 v1(4, 8);'
            echo '    vect2 v2;'
            echo '    v2 = v1;'
            echo '    std::cout << v2[0] << " " << v2[1] << std::endl;'
            ;;
        "operator_bracket_const")
            echo '    const vect2 v(2, 6);'
            echo '    std::cout << v[0] << " " << v[1] << std::endl;'
            ;;
        "operator_bracket_nonconst")
            echo '    vect2 v(1, 2);'
            echo '    v[0] = 10;'
            echo '    v[1] = 20;'
            echo '    std::cout << v[0] << " " << v[1] << std::endl;'
            ;;
        "operator_unary_minus")
            echo '    vect2 v(5, -3);'
            echo '    vect2 neg = -v;'
            echo '    std::cout << neg[0] << " " << neg[1] << std::endl;'
            ;;
        "operator_multiply_scalar")
            echo '    vect2 v(2, 3);'
            echo '    vect2 result = v * 4;'
            echo '    std::cout << result[0] << " " << result[1] << std::endl;'
            ;;
        "operator_multiply_assign_scalar")
            echo '    vect2 v(3, 5);'
            echo '    v *= 2;'
            echo '    std::cout << v[0] << " " << v[1] << std::endl;'
            ;;
        "operator_plus_assign")
            echo '    vect2 v1(2, 3);'
            echo '    vect2 v2(4, 5);'
            echo '    v1 += v2;'
            echo '    std::cout << v1[0] << " " << v1[1] << std::endl;'
            ;;
        "operator_plus")
            echo '    vect2 v1(1, 2);'
            echo '    vect2 v2(3, 4);'
            echo '    vect2 result = v1 + v2;'
            echo '    std::cout << result[0] << " " << result[1] << std::endl;'
            ;;
        "operator_prefix_increment")
            echo '    vect2 v(5, 10);'
            echo '    ++v;'
            echo '    std::cout << v[0] << " " << v[1] << std::endl;'
            ;;
        "operator_postfix_increment")
            echo '    vect2 v(3, 7);'
            echo '    vect2 old = v++;'
            echo '    std::cout << old[0] << " " << old[1] << " " << v[0] << " " << v[1] << std::endl;'
            ;;
        "operator_equal")
            echo '    vect2 v1(2, 3);'
            echo '    vect2 v2(2, 3);'
            echo '    vect2 v3(1, 1);'
            echo '    std::cout << (v1 == v2) << " " << (v1 == v3) << std::endl;'
            ;;
        "operator_notequal")
            echo '    vect2 v1(2, 3);'
            echo '    vect2 v2(2, 3);'
            echo '    vect2 v3(1, 1);'
            echo '    std::cout << (v1 != v2) << " " << (v1 != v3) << std::endl;'
            ;;
        "operator_multiply_left")
            echo '    vect2 v(2, 3);'
            echo '    vect2 result = 5 * v;'
            echo '    std::cout << result[0] << " " << result[1] << std::endl;'
            ;;
        "operator_output")
            echo '    vect2 v(7, 13);'
            echo '    std::cout << v << std::endl;'
            ;;
    esac
}

get_expected_output() {
    case $1 in
        "default_constructor") echo "0 0" ;;
        "param_constructor") echo "5 10" ;;
        "copy_constructor") echo "3 7" ;;
        "assignment_operator") echo "4 8" ;;
        "operator_bracket_const") echo "2 6" ;;
        "operator_bracket_nonconst") echo "10 20" ;;
        "operator_unary_minus") echo "-5 3" ;;
        "operator_multiply_scalar") echo "8 12" ;;
        "operator_multiply_assign_scalar") echo "6 10" ;;
        "operator_plus_assign") echo "6 8" ;;
        "operator_plus") echo "4 6" ;;
        "operator_prefix_increment") echo "6 11" ;;
        "operator_postfix_increment") echo "3 7 4 8" ;;
        "operator_equal") echo "1 0" ;;
        "operator_notequal") echo "0 1" ;;
        "operator_multiply_left") echo "10 15" ;;
        "operator_output") echo "{ 7, 13 }" ;;
    esac
}

get_solution() {
    case $1 in
        "default_constructor")
            cat << 'SOL'
vect2::vect2()
{
    this->x = 0;
    this->y = 0;
}
SOL
            ;;
        "param_constructor")
            cat << 'SOL'
vect2::vect2(int num1, int num2)
{
    this->x = num1;
    this->y = num2;
}
SOL
            ;;
        "copy_constructor")
            cat << 'SOL'
vect2::vect2(const vect2& source)
{
    *this = source;
}
SOL
            ;;
        "assignment_operator")
            cat << 'SOL'
vect2& vect2::operator=(const vect2& source)
{
    if(this != &source)
    {
        this->x = source.x;
        this->y = source.y;
    }
    return(*this);
}
SOL
            ;;
        "operator_bracket_const")
            cat << 'SOL'
int vect2::operator[](int index) const
{
    if(index == 0)
        return(this->x);
    return(this->y);
}
SOL
            ;;
        "operator_bracket_nonconst")
            cat << 'SOL'
int& vect2::operator[](int index)
{
    if(index == 0)
        return(this->x);
    return(this->y);
}
SOL
            ;;
        "operator_unary_minus")
            cat << 'SOL'
vect2 vect2::operator-() const
{
    vect2 temp = *this;
    temp[0] = -temp[0];
    temp[1] = -temp[1];
    return(temp);
}
SOL
            ;;
        "operator_multiply_scalar")
            cat << 'SOL'
vect2 vect2::operator*(int num) const
{
    vect2 temp;
    temp.x = this->x * num;
    temp.y = this->y * num;
    return(temp);
}
SOL
            ;;
        "operator_multiply_assign_scalar")
            cat << 'SOL'
vect2& vect2::operator*=(int num)
{
    this->x *= num;
    this->y *= num;
    return(*this);
}
SOL
            ;;
        "operator_plus_assign")
            cat << 'SOL'
vect2& vect2::operator+=(const vect2& obj)
{
    this->x += obj.x;
    this->y += obj.y;
    return(*this);
}
SOL
            ;;
        "operator_plus")
            cat << 'SOL'
vect2 vect2::operator+(const vect2& obj) const
{
    vect2 temp = *this;
    temp.x += obj.x;
    temp.y += obj.y;
    return(temp);
}
SOL
            ;;
        "operator_prefix_increment")
            cat << 'SOL'
vect2& vect2::operator++()
{
    this->x += 1;
    this->y += 1;
    return(*this);
}
SOL
            ;;
        "operator_postfix_increment")
            cat << 'SOL'
vect2 vect2::operator++(int)
{
    vect2 temp = *this;
    ++(*this);
    return(temp);
}
SOL
            ;;
        "operator_equal")
            cat << 'SOL'
bool vect2::operator==(const vect2& obj) const
{
    if((this->x == obj.x) && (this->y == obj.y))
        return(true);
    return(false);
}
SOL
            ;;
        "operator_notequal")
            cat << 'SOL'
bool vect2::operator!=(const vect2& obj) const
{
    return(!(obj == *this));
}
SOL
            ;;
        "operator_multiply_left")
            cat << 'SOL'
vect2 operator*(int num, const vect2& obj)
{
    vect2 temp(obj);
    temp *= num;
    return(temp);
}
SOL
            ;;
        "operator_output")
            cat << 'SOL'
std::ostream& operator<<(std::ostream& os,const vect2& obj)
{
    std::cout << "{" << obj[0] << ", " << obj[1] << "}";
    return(os);
}
SOL
            ;;
    esac
}

# Run exercise
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
        
        # Show test
        echo -e "${YELLOW}Test Code:${NC}"
        get_test_code "$ex"
        echo ""
        
        echo -e "${YELLOW}Expected Output:${NC}"
        echo "$(get_expected_output "$ex")"
        echo ""
        
        echo -e "${GREEN}Write your solution in: ${CYAN}$WORK_DIR/vect2.cpp${NC}"
        echo ""
        
        # Create skeleton file - specific to each exercise
        generate_skeleton_for_exercise "$ex"
        
        # Auto-open in VS Code
        code "$WORK_DIR/vect2.cpp" 2>/dev/null &
        
        # Update main
        cat > "$WORK_DIR/main.cpp" << EOF
#include "vect2.hpp"
#include <iostream>

int main()
{
$(get_test_code "$ex")
    return 0;
}
EOF
        
        echo -e "${CYAN}Press ENTER when you are ready to test...${NC}"
        read
        
        # Compile
        echo -e "${YELLOW}Compiling...${NC}"
        cd "$WORK_DIR"
        if c++ -Wall -Wextra -Werror -std=c++98 main.cpp vect2.cpp -o test 2>/tmp/compile_error.txt; then
            echo -e "${GREEN}✓ Compiled!${NC}"
            echo ""
            
            # Run
            echo -e "${YELLOW}Output:${NC}"
            ./test > /tmp/output.txt 2>&1
            cat /tmp/output.txt
            echo ""
            
            # Check
            local expected=$(get_expected_output "$ex")
            local actual=$(cat /tmp/output.txt)
            
            if [ "$actual" == "$expected" ]; then
                echo -e "${GREEN}✅ CORRECT! Test passed!${NC}"
                echo ""
                return 0
            else
                echo -e "${RED}❌ WRONG!${NC}"
                echo -e "${RED}Expected: $expected${NC}"
                echo -e "${RED}Got:      $actual${NC}"
                echo ""
                echo -e "${CYAN}[s] Show solution  [r] Retry  [n] Next  [q] Quit${NC}"
                read retry
                if [ "$retry" == "s" ]; then
                    echo ""
                    echo -e "${YELLOW}💡 Solution:${NC}"
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
                # Loop continues for retry
            fi
        else
            echo -e "${RED}✗ Compile Error:${NC}"
            cat /tmp/compile_error.txt
            echo ""
            echo -e "${CYAN}[s] Show solution  [r] Retry  [n] Next  [q] Quit${NC}"
            read retry
            if [ "$retry" == "s" ]; then
                echo ""
                echo -e "${YELLOW}💡 Solution:${NC}"
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
            # Loop continues for retry
        fi
    done
}

# Main menu
main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║          VECT2 TRAINER - Write the Code!                   ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "Choose an exercise:"
        echo ""
        
        local i=1
        for ex in "${exercises[@]}"; do
            printf "%2d) %s\n" $i "$(get_exercise_name "$ex")"
            ((i++))
        done
        
        echo ""
        echo " r) Random"
        echo " q) Quit"
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
        elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#exercises[@]} ]; then
            setup
            run_exercise "${exercises[$((choice-1))]}"
            echo ""
            read -p "Press ENTER for next..."
        fi
    done
}

# Start
main_menu
