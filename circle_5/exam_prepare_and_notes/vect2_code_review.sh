#!/bin/bash

# vect2_code_review.sh - Is this code correct?
# Train your eye for errors!

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

score=0
total=0

show_snippet() {
    local title=$1
    local code=$2
    local is_correct=$3
    local explanation=$4
    
    ((total++))
    
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  CODE REVIEW [$total]${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}$title${NC}"
    echo ""
    echo -e "${YELLOW}Code:${NC}"
    echo "────────────────────────────────────────────────────────"
    echo "$code"
    echo "────────────────────────────────────────────────────────"
    echo ""
    read -p "Is this code CORRECT? (y/n): " answer
    
    if [[ "$answer" == "y" && "$is_correct" == "yes" ]] || \
       [[ "$answer" == "n" && "$is_correct" == "no" ]]; then
        echo -e "${GREEN}✓ CORRECT!${NC}"
        ((score++))
    else
        echo -e "${RED}✗ WRONG!${NC}"
        if [ "$is_correct" == "yes" ]; then
            echo -e "${GREEN}This code is CORRECT!${NC}"
        else
            echo -e "${RED}This code is WRONG!${NC}"
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}Explanation:${NC}"
    echo "$explanation"
    echo ""
    read -p "Press ENTER..."
}

# ============================================================================
# SNIPPETS
# ============================================================================

# CORRECT: Default Constructor
show_snippet \
"Default Constructor" \
"vect2::vect2()
{
    this->x = 0;
    this->y = 0;
}" \
"yes" \
"✓ Initializes both members with 0
✓ Uses this-> (optional but clear)
✓ No return needed (Constructor)"

# WRONG: Default Constructor - forgets y
show_snippet \
"Default Constructor" \
"vect2::vect2()
{
    x = 0;
}" \
"no" \
"❌ y is NOT initialized!
→ y has a random value (undefined behavior)
→ MUST init both x AND y!"

# CORRECT: Copy Constructor
show_snippet \
"Copy Constructor" \
"vect2::vect2(const vect2& source)
{
    *this = source;
}" \
"yes" \
"✓ Uses operator= (code reuse)
✓ *this is the current object
✓ Short and elegant!"

# WRONG: Copy Constructor - forgets *
show_snippet \
"Copy Constructor" \
"vect2::vect2(const vect2& source)
{
    this = source;
}" \
"no" \
"❌ 'this = source' is WRONG!
→ this is a POINTER, source is an object
→ Correct: *this = source
→ Or: x = source.x; y = source.y;"

# CORRECT: operator=
show_snippet \
"Assignment Operator" \
"vect2& vect2::operator=(const vect2& source)
{
    if(this != &source)
    {
        this->x = source.x;
        this->y = source.y;
    }
    return(*this);
}" \
"yes" \
"✓ Self-assignment check (this != &source)
✓ Copies x and y
✓ return *this for chaining (v1 = v2 = v3)"

# WRONG: operator= - no return
show_snippet \
"Assignment Operator" \
"vect2& vect2::operator=(const vect2& source)
{
    if(this != &source)
    {
        x = source.x;
        y = source.y;
    }
}" \
"no" \
"❌ No return statement!
→ Return-Type is vect2& → MUST return *this
→ For chaining: v1 = v2 = v3;
→ Fix: return(*this);"

# CORRECT: operator[] const
show_snippet \
"operator[] const" \
"int vect2::operator[](int index) const
{
    if(index == 0)
        return(this->x);
    return(this->y);
}" \
"yes" \
"✓ const at the end (read-only access)
✓ Return-Type int (copy, not reference)
✓ if/else for x (index 0) and y"

# WRONG: operator[] const - return int&
show_snippet \
"operator[] const" \
"int& vect2::operator[](int index) const
{
    if(index == 0)
        return(x);
    return(y);
}" \
"no" \
"❌ Return-Type is int& (reference)!
→ NOT allowed for const function
→ Const means: read only, no writing
→ Correct: int (without &)"

# CORRECT: operator[] non-const
show_snippet \
"operator[] non-const" \
"int& vect2::operator[](int index)
{
    if(index == 0)
        return(this->x);
    return(this->y);
}" \
"yes" \
"✓ Return int& (reference!)
✓ No const → can modify
✓ Allows: v[0] = 10;"

# WRONG: operator[] non-const - return int
show_snippet \
"operator[] non-const" \
"int vect2::operator[](int index)
{
    if(index == 0)
        return(x);
    return(y);
}" \
"no" \
"❌ Return-Type is int (copy)!
→ v[0] = 10; would NOT work
→ Because you modify the copy, not the original
→ Correct: int& (reference)"

# CORRECT: operator+
show_snippet \
"operator+" \
"vect2 vect2::operator+(const vect2& obj) const
{
    vect2 temp = *this;
    temp += obj;
    return(temp);
}" \
"yes" \
"✓ Uses operator+= (code reuse)
✓ Does NOT change *this (const function)
✓ Returns new vect2 object"

# WRONG: operator+ - modifies this
show_snippet \
"operator+" \
"vect2 vect2::operator+(const vect2& obj) const
{
    *this += obj;
    return(*this);
}" \
"no" \
"❌ Modifies *this!
→ const function must NOT change *this
→ v1 + v2 would modify v1 (wrong!)
→ Correct: temp = *this; temp += obj; return temp;"

# CORRECT: operator+=
show_snippet \
"operator+=" \
"vect2& vect2::operator+=(const vect2& obj)
{
    this->x += obj.x;
    this->y += obj.y;
    return(*this);
}" \
"yes" \
"✓ Modifies *this (no const)
✓ return *this (for v1 += v2 += v3)
✓ Return-Type vect2& (reference)"

# WRONG: operator+= - return vect2
show_snippet \
"operator+=" \
"vect2 vect2::operator+=(const vect2& obj)
{
    x += obj.x;
    y += obj.y;
    return(*this);
}" \
"no" \
"❌ Return-Type is vect2 (copy)!
→ Should be vect2& (reference)
→ Chaining does not work: v1 += v2 += v3
→ Correct: vect2& as Return-Type"

# CORRECT: operator++ prefix
show_snippet \
"operator++ prefix" \
"vect2& vect2::operator++()
{
    ++this->x;
    ++this->y;
    return(*this);
}" \
"yes" \
"✓ No parameter (prefix)
✓ ++x and ++y
✓ return *this (new value)"

# CORRECT: operator++ postfix
show_snippet \
"operator++ postfix" \
"vect2 vect2::operator++(int)
{
    vect2 temp = *this;
    ++(*this);
    return(temp);
}" \
"yes" \
"✓ Parameter 'int' (dummy, identifies postfix)
✓ Saves old value in temp
✓ ++(*this) → calls prefix++
✓ return temp (OLD value)"

# WRONG: operator++ postfix - return *this
show_snippet \
"operator++ postfix" \
"vect2 vect2::operator++(int)
{
    ++x;
    ++y;
    return(*this);
}" \
"no" \
"❌ Returns NEW value!
→ Postfix should return OLD value
→ v++ returns old value, then v is incremented
→ Correct: save temp, then ++, then return temp"

# CORRECT: operator==
show_snippet \
"operator==" \
"bool vect2::operator==(const vect2& obj) const
{
    return(this->x == obj.x && this->y == obj.y);
}" \
"yes" \
"✓ return bool
✓ const function (changes nothing)
✓ Checks x AND y (&& operator)"

# WRONG: operator== - || instead of &&
show_snippet \
"operator==" \
"bool vect2::operator==(const vect2& obj) const
{
    return(x == obj.x || y == obj.y);
}" \
"no" \
"❌ Uses || (OR) instead of && (AND)!
→ (2,3) == (2,999) would be TRUE (because x is equal)
→ Both must be equal!
→ Correct: && instead of ||"

# CORRECT: operator* (scalar left) NON-MEMBER
show_snippet \
"operator* (scalar left) NON-MEMBER" \
"vect2 operator*(int num, const vect2& obj)
{
    return(obj * num);
}" \
"yes" \
"✓ NON-MEMBER (outside the class!)
✓ NO vect2:: prefix!
✓ Calls obj * num (member function)
✓ For: 5 * v"

# WRONG: operator* (scalar left) - is member
show_snippet \
"operator* (scalar left)" \
"vect2 vect2::operator*(int num, const vect2& obj)
{
    return(obj * num);
}" \
"no" \
"❌ Has vect2:: prefix (member function)!
→ Should be NON-MEMBER
→ Signature would be wrong: this, num, obj (3 parameters!)
→ Correct: vect2 operator*(int num, const vect2& obj)"

# CORRECT: operator<< NON-MEMBER
show_snippet \
"operator<< NON-MEMBER" \
"std::ostream& operator<<(std::ostream& os, const vect2& obj)
{
    os << \"{ \" << obj[0] << \", \" << obj[1] << \" }\";
    return(os);
}" \
"yes" \
"✓ NON-MEMBER (outside the class!)
✓ Return ostream& (for chaining)
✓ Format: { x, y } with spaces"

# WRONG: operator<< - return void
show_snippet \
"operator<<" \
"void operator<<(std::ostream& os, const vect2& obj)
{
    os << \"{ \" << obj[0] << \", \" << obj[1] << \" }\";
}" \
"no" \
"❌ Return-Type is void!
→ Chaining does not work: cout << v1 << v2
→ Must return ostream&
→ Fix: return os; at the end"

# FALSCH: operator<< - () statt {}
show_snippet \
"operator<<" \
"std::ostream& operator<<(std::ostream& os, const vect2& obj)
{
    os << \"(\" << obj[0] << \", \" << obj[1] << \")\";
    return(os);
}" \
"no" \
"❌ Benutzt () statt {}!
→ Je nach Test: erwartet { x, y } Format
→ Immer im Subject prüfen!
→ Meist: {} ist Standard"

# ============================================================================
# ERGEBNIS
# ============================================================================

clear
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      ERGEBNIS                                ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"

percentage=$((score * 100 / total))

echo -e "${BLUE}║${NC}  Punkte: ${GREEN}$score${NC} / $total"
echo -e "${BLUE}║${NC}  Prozent: ${percentage}%"

if [ $percentage -ge 90 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}🎉 EXCELLENT!${NC} Du erkennst Fehler sofort!"
elif [ $percentage -ge 70 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}👍 GUT!${NC} Noch ein paar Unsicherheiten"
elif [ $percentage -ge 50 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}⚠️  OKAY${NC} - Lies EXAM_QUICK_REF.md"
else
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${RED}❌ NOCH NICHT READY!${NC}"
fi

echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

read -p "Drück ENTER um zu beenden..."
