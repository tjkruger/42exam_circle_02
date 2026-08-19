#!/bin/bash

# bigint_trainer.sh - Interactive bigint Training
# Focus: String manipulation, char-to-int, operator+, shifts

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="/tmp/bigint_training"
TEMPLATE_DIR="$SCRIPT_DIR/.resources/rank05/level1/bigint"

# Cleanup
cleanup() {
    rm -rf "$WORK_DIR"
}

# Setup
setup() {
    cleanup
    mkdir -p "$WORK_DIR"
    cp "$TEMPLATE_DIR/bigint.hpp" "$WORK_DIR/"
}

# Exercises - only the most important ones!
exercises=(
    "default_constructor"
    "uint_constructor"
    "operator_plus"
    "operator_shift_left"
    "operator_shift_right"
    "operator_less_than"
)

get_exercise_name() {
    case $1 in
        "default_constructor") echo "Default Constructor (str = \"0\")" ;;
        "uint_constructor") echo "Constructor(unsigned int) - atoi-like" ;;
        "operator_plus") echo "operator+ - String Addition with Carry" ;;
        "operator_shift_left") echo "operator<< - Append zeros" ;;
        "operator_shift_right") echo "operator>> - Remove digits" ;;
        "operator_less_than") echo "operator< - String Comparison" ;;
    esac
}

get_exercise_skeleton() {
    case $1 in
        "default_constructor")
            cat << 'SKEL'
bigint::bigint()
{
    // Set this->str = "0"
}
SKEL
            ;;
        "uint_constructor")
            cat << 'SKEL'
bigint::bigint(unsigned int num)
{
    // Convert num to string with stringstream
    // std::stringstream ss;
    // ss << num;
    // this->str = ss.str();
}
SKEL
            ;;
        "operator_plus")
            cat << 'SKEL'
🔥 ATTENTION: Most complex function!

Option A: C++98 - custom reverse() function (17 extra lines!)
Option B: C++11+ - use std::reverse() (shorter!)

Helper: std::string addition(const bigint& obj1, const bigint& obj2)
{
    // 1. Reverse both strings (units digit = index 0)
    //    C++98: custom reverse() function
    //    C++11+: std::reverse(s1.begin(), s1.end());
    //
    // 2. Pad with zeros to the same length
    //
    // 3. Loop through all digits:
    //    - digit1 = str1[i] - '0'  (char to int!)
    //    - digit2 = str2[i] - '0'
    //    - res = digit1 + digit2 + carry
    //    - if res > 9: carry = res / 10, digit = res % 10
    //
    // 4. At the end: carry left? → append it
    //
    // 5. Reverse result back
    //
    // return result;
}

bigint bigint::operator+(const bigint& other) const
{
    // Call addition(*this, other)
    // Create new bigint with result string
}
SKEL
            ;;
        "operator_shift_left")
            cat << 'SKEL'
bigint bigint::operator<<(unsigned int n) const
{
    // Append n zeros to the end of str
    // temp.str.insert(temp.str.end(), n, '0');
}
SKEL
            ;;
        "operator_shift_right")
            cat << 'SKEL'
bigint bigint::operator>>(unsigned int n) const
{
    // Remove n digits from the end
    // If n >= str.length() → "0"
    // Else: str.erase(str.length() - n, n);
}
SKEL
            ;;
        "operator_less_than")
            cat << 'SKEL'
bool bigint::operator<(const bigint& other) const
{
    // Compare string lengths:
    // - Shorter string = smaller number
    // If same length: lexicographical compare (str1 < str2)
}
SKEL
            ;;
    esac
}

generate_skeleton_for_exercise() {
    local ex=$1
    cp "$TEMPLATE_DIR/bigint.cpp" "$WORK_DIR/bigint.cpp"
    
    case $ex in
        "default_constructor")
            sed -i '/^bigint::bigint()$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            ;;
        "uint_constructor")
            sed -i '/^bigint::bigint(unsigned int num)$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            ;;
        "operator_plus")
            # Delete helper function AND operator+
            sed -i '/^std::string addition(const bigint& obj1, const bigint& obj2)$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            sed -i '/^bigint bigint::operator+(const bigint& other)const$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            ;;
        "operator_shift_left")
            sed -i '/^bigint bigint::operator<<(unsigned int n)const$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            ;;
        "operator_shift_right")
            sed -i '/^bigint bigint::operator>>(unsigned int n)const$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            ;;
        "operator_less_than")
            sed -i '/^bool bigint::operator<(const bigint& other) const$/,/^}$/d' "$WORK_DIR/bigint.cpp"
            ;;
    esac
}

get_test_code() {
    case $1 in
        "default_constructor")
            echo '    bigint b;'
            echo '    std::cout << b << std::endl;'
            ;;
        "uint_constructor")
            echo '    bigint b(12345);'
            echo '    std::cout << b << std::endl;'
            ;;
        "operator_plus")
            echo '    bigint a(1234);'
            echo '    bigint b(567);'
            echo '    bigint c = a + b;'
            echo '    std::cout << c << std::endl;'
            ;;
        "operator_shift_left")
            echo '    bigint a(123);'
            echo '    bigint b = a << 2;'
            echo '    std::cout << b << std::endl;'
            ;;
        "operator_shift_right")
            echo '    bigint a(12345);'
            echo '    bigint b = a >> 2;'
            echo '    std::cout << b << std::endl;'
            ;;
        "operator_less_than")
            echo '    bigint a(123);'
            echo '    bigint b(456);'
            echo '    std::cout << (a < b) << " " << (b < a) << std::endl;'
            ;;
    esac
}

get_expected_output() {
    case $1 in
        "default_constructor") echo "0" ;;
        "uint_constructor") echo "12345" ;;
        "operator_plus") echo "1801" ;;
        "operator_shift_left") echo "12300" ;;
        "operator_shift_right") echo "123" ;;
        "operator_less_than") echo "1 0" ;;
    esac
}

get_solution() {
    case $1 in
        "default_constructor")
            cat << 'SOL'
bigint::bigint()
{
    this->str = "0";
}
SOL
            ;;
        "uint_constructor")
            cat << 'SOL'
bigint::bigint(unsigned int num)
{
    std::stringstream ss;
    ss << num;
    this->str = ss.str();
}
SOL
            ;;
        "operator_plus")
            cat << 'SOL'
=== VARIANT A: C++98 (custom reverse) ===

std::string reverse(const std::string& str)
{
    std::string revStr;
    for(size_t i = str.length(); i > 0; i--)
        revStr.push_back(str[i - 1]);
    return(revStr);
}

std::string addition(const bigint& obj1, const bigint& obj2)
{
    std::string str1 = reverse(obj1.getStr());
    std::string str2 = reverse(obj2.getStr());
    std::string result;
    size_t len1 = str1.length();
    size_t len2 = str2.length();

    // Pad shorter string with zeros
    if(len1 > len2)
    {
        int diff = len1 - len2;
        while(diff > 0)
        {
            str2.push_back('0');
            diff--;
        }
    }
    else if(len2 > len1)
    {
        int diff = len2 - len1;
        while(diff > 0)
        {
            str1.push_back('0');
            diff--;
        }
    }

    int carry = 0;
    size_t len = str1.length();
    for(size_t i = 0; i < len; i++)
    {
        int digit1 = str1[i] - '0';
        int digit2 = str2[i] - '0';
        int res = digit1 + digit2 + carry;
        
        if(res > 9)
        {
            carry = res / 10;
            result.push_back((res % 10) + '0');
        }
        else
        {
            carry = 0;
            result.push_back(res + '0');
        }
    }
    if(carry != 0)
        result.push_back(carry + '0');
    
    return(reverse(result));
}

bigint bigint::operator+(const bigint& other)const
{
    bigint temp(other);
    temp.str.clear();
    std::string result = addition(*this, other);
    temp.str = result;
    return(temp);
}

=== VARIANT B: C++11+ (std::reverse) ===

#include <algorithm>  // IMPORTANT: for std::reverse!

std::string addition(const bigint& obj1, const bigint& obj2)
{
    std::string str1 = obj1.getStr();
    std::string str2 = obj2.getStr();
    
    // Reverse with std::reverse (shorter!)
    std::reverse(str1.begin(), str1.end());
    std::reverse(str2.begin(), str2.end());
    
    std::string result;
    size_t len1 = str1.length();
    size_t len2 = str2.length();

    // Pad shorter string with zeros
    if(len1 > len2)
    {
        int diff = len1 - len2;
        while(diff > 0)
        {
            str2.push_back('0');
            diff--;
        }
    }
    else if(len2 > len1)
    {
        int diff = len2 - len1;
        while(diff > 0)
        {
            str1.push_back('0');
            diff--;
        }
    }

    int carry = 0;
    size_t len = str1.length();
    for(size_t i = 0; i < len; i++)
    {
        int digit1 = str1[i] - '0';
        int digit2 = str2[i] - '0';
        int res = digit1 + digit2 + carry;
        
        if(res > 9)
        {
            carry = res / 10;
            result.push_back((res % 10) + '0');
        }
        else
        {
            carry = 0;
            result.push_back(res + '0');
        }
    }
    if(carry != 0)
        result.push_back(carry + '0');
    
    // Reverse back
    std::reverse(result.begin(), result.end());
    return(result);
}

bigint bigint::operator+(const bigint& other)const
{
    bigint temp(other);
    temp.str.clear();
    std::string result = addition(*this, other);
    temp.str = result;
    return(temp);
}
SOL
            ;;
        "operator_shift_left")
            cat << 'SOL'
bigint bigint::operator<<(unsigned int n)const
{
    bigint temp = *this;
    temp.str.insert(temp.str.end(), n, '0');
    return(temp);
}
SOL
            ;;
        "operator_shift_right")
            cat << 'SOL'
bigint bigint::operator>>(unsigned int n)const
{
    bigint temp = *this;
    size_t len = temp.str.length();
    if(n >= len)
        temp.str = "0";
    else
        temp.str.erase(temp.str.length() - n, n);
    return(temp);
}
SOL
            ;;
        "operator_less_than")
            cat << 'SOL'
bool bigint::operator<(const bigint& other) const
{
    std::string str1 = this->str;
    std::string str2 = other.getStr();
    size_t len1 = str1.length();
    size_t len2 = str2.length();

    if(len1 != len2)
        return(len1 < len2);
    return(str1 < str2);
}
SOL
            ;;
    esac
}

get_lines_of_code() {
    case $1 in
        "default_constructor") echo "3" ;;
        "uint_constructor") echo "5" ;;
        "operator_plus") echo "45-50" ;;
        "operator_shift_left") echo "4" ;;
        "operator_shift_right") echo "7" ;;
        "operator_less_than") echo "9" ;;
    esac
}

run_exercise() {
    local ex=$1
    local name=$(get_exercise_name "$ex")
    
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║  BIGINT EXERCISE: ${CYAN}$name${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${YELLOW}📝 What you should write (~$(get_lines_of_code "$ex") lines):${NC}"
        echo "────────────────────────────────────────────────────────"
        get_exercise_skeleton "$ex"
        echo "────────────────────────────────────────────────────────"
        echo ""
        
        echo -e "${YELLOW}🧪 Test Code:${NC}"
        get_test_code "$ex"
        echo ""
        
        echo -e "${YELLOW}✅ Expected Output:${NC}"
        echo "$(get_expected_output "$ex")"
        echo ""
        
        echo -e "${GREEN}📂 Write in: ${CYAN}$WORK_DIR/bigint.cpp${NC}"
        echo ""
        
        generate_skeleton_for_exercise "$ex"
        
        # Auto-open in VS Code
        code "$WORK_DIR/bigint.cpp" 2>/dev/null &
        
        cat > "$WORK_DIR/main.cpp" << EOF
#include "bigint.hpp"
#include <iostream>

int main()
{
$(get_test_code "$ex")
    return 0;
}
EOF
        
        echo -e "${CYAN}Press ENTER to test...${NC}"
        read
        
        cd "$WORK_DIR"
        echo -e "${YELLOW}Compiling...${NC}"
        if c++ -Wall -Wextra -Werror -std=c++98 main.cpp bigint.cpp -o test 2>/tmp/compile_error.txt; then
            echo -e "${GREEN}✓ Compiled!${NC}"
            echo ""
            
            echo -e "${YELLOW}Output:${NC}"
            ./test > /tmp/output.txt 2>&1
            cat /tmp/output.txt
            echo ""
            
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
                    echo -e "${YELLOW}💡 Solution (~$(get_lines_of_code "$ex") lines):${NC}"
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
            echo -e "${RED}✗ Compile Error:${NC}"
            cat /tmp/compile_error.txt
            echo ""
            echo -e "${CYAN}[s] Show solution  [r] Retry  [n] Next  [q] Quit${NC}"
            read retry
            if [ "$retry" == "s" ]; then
                echo ""
                echo -e "${YELLOW}💡 Solution (~$(get_lines_of_code "$ex") lines):${NC}"
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

main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║       BIGINT TRAINER - String Manipulation!              ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}💡 Focus: String ops, char-to-int ('0' trick), carry logic${NC}"
        echo ""
        echo "Choose an exercise:"
        echo ""
        
        local i=1
        for ex in "${exercises[@]}"; do
            printf "%2d) %s (~%s lines)\n" $i "$(get_exercise_name "$ex")" "$(get_lines_of_code "$ex")"
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

main_menu
