#!/bin/bash

# ============================================================================
# POLYSET TRAINER - 42 School Rank05 Exam
# ============================================================================
# This trainer covers MULTIPLE INHERITANCE with virtual inheritance in C++
# You'll learn: virtual inheritance, abstract classes, composition
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TRAINING_DIR="/tmp/polyset_training"
RESOURCE_DIR="$SCRIPT_DIR/.resources/rank05/level1/polyset"

# ============================================================================
# INHERITANCE DIAGRAM
# ============================================================================
show_diagram() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           POLYSET INHERITANCE HIERARCHY (NO DIAMOND PROBLEM)         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}                           bag (abstract)${NC}"
    echo -e "${YELLOW}                    virtual │  virtual │${NC}"
    echo -e "${YELLOW}                    ┌───────┴───┬──────┴────────┐${NC}"
    echo -e "${YELLOW}                    │           │               │${NC}"
    echo -e "${GREEN}              array_bag   searchable_bag   tree_bag${NC}"
    echo -e "${GREEN}              (concrete)    (abstract)    (concrete)${NC}"
    echo -e "${GREEN}                    │           │               │${NC}"
    echo -e "${GREEN}                    └─────┬─────┼─────┬─────────┘${NC}"
    echo -e "${BLUE}                          │     │     │${NC}"
    echo -e "${BLUE}            searchable_array_bag │ searchable_tree_bag${NC}"
    echo -e "${BLUE}                   (YOU WRITE)   │    (YOU WRITE)${NC}"
    echo ""
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}COMPOSITION (set uses searchable_bag, no inheritance):${NC}"
    echo -e "${MAGENTA}                              set${NC}"
    echo -e "${MAGENTA}                              │${NC}"
    echo -e "${MAGENTA}                              └─ holds reference to ─┐${NC}"
    echo -e "${MAGENTA}                                                    │${NC}"
    echo -e "${MAGENTA}                                     searchable_bag&  │${NC}"
    echo -e "${MAGENTA}                                                    │${NC}"
    echo -e "${MAGENTA}                                     (points to either) │${NC}"
    echo -e "${MAGENTA}                                     ┌─────────────────┴─────────────────┐${NC}"
    echo -e "${MAGENTA}                                     │                                   │${NC}"
    echo -e "${MAGENTA}                       searchable_array_bag              searchable_tree_bag${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}KEY CONCEPTS:${NC}"
    echo -e "  • ${GREEN}Virtual Inheritance${NC}: Ensures only ONE bag instance in memory"
    echo -e "  • ${GREEN}Multiple Inheritance${NC}: searchable_* inherit from TWO classes"
    echo -e "  • ${GREEN}Composition${NC}: set HOLDS a reference, does NOT inherit"
    echo -e "  • No true diamond problem due to virtual inheritance"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# ABSTRACT CLASS EXPLANATION
# ============================================================================
show_abstract_explanation() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                 ABSTRACT CLASSES IN POLYSET                          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}1. bag (abstract base)${NC}"
    echo -e "   Pure virtual methods (${RED}= 0${NC} means you MUST implement):"
    echo -e "   ${GREEN}virtual void insert(int) = 0;${NC}"
    echo -e "   ${GREEN}virtual void insert(int*, int) = 0;${NC}"
    echo -e "   ${GREEN}virtual void print() const = 0;${NC}"
    echo -e "   ${GREEN}virtual void clear() = 0;${NC}"
    echo ""
    echo -e "${YELLOW}2. searchable_bag (abstract, adds search capability)${NC}"
    echo -e "   ${GREEN}class searchable_bag : virtual public bag${NC}"
    echo -e "   Pure virtual method:"
    echo -e "   ${GREEN}virtual bool has(int) const = 0;${NC}"
    echo ""
    echo -e "${YELLOW}3. array_bag (concrete, PROVIDED)${NC}"
    echo -e "   ${GREEN}class array_bag : virtual public bag${NC}"
    echo -e "   Implements all 4 bag methods using:"
    echo -e "   ${BLUE}protected: int *data; int size;${NC}"
    echo ""
    echo -e "${YELLOW}4. tree_bag (concrete, PROVIDED)${NC}"
    echo -e "   ${GREEN}class tree_bag : virtual public bag${NC}"
    echo -e "   Implements all 4 bag methods using:"
    echo -e "   ${BLUE}protected: struct node { node *l; node *r; int value; };${NC}"
    echo -e "   ${BLUE}protected: node *tree;${NC}"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}YOU MUST IMPLEMENT:${NC}"
    echo -e "  1. ${YELLOW}searchable_array_bag${NC} - inherits from array_bag + searchable_bag"
    echo -e "  2. ${YELLOW}searchable_tree_bag${NC}  - inherits from tree_bag + searchable_bag"
    echo -e "  3. ${YELLOW}set${NC}                  - wrapper that enforces uniqueness"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# WHAT'S PROVIDED VS WHAT YOU WRITE
# ============================================================================
show_comparison() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              PROVIDED vs YOU MUST WRITE (Comparison)                 ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}✓ PROVIDED (You get these files):${NC}"
    echo -e "  • ${BLUE}bag.hpp${NC}              - Abstract base class (4 pure virtual methods)"
    echo -e "  • ${BLUE}searchable_bag.hpp${NC}   - Abstract class (adds has() method)"
    echo -e "  • ${BLUE}array_bag.hpp/.cpp${NC}   - Concrete implementation using int *data"
    echo -e "  • ${BLUE}tree_bag.hpp/.cpp${NC}    - Concrete implementation using BST"
    echo ""
    echo -e "${RED}✗ YOU MUST WRITE:${NC}"
    echo -e "  • ${YELLOW}searchable_array_bag.hpp/.cpp${NC}"
    echo -e "    └─ Inherits: ${GREEN}array_bag${NC} + ${GREEN}searchable_bag${NC}"
    echo -e "    └─ Must implement: ${MAGENTA}Canon (4 methods) + has()${NC}"
    echo -e "    └─ Canon: Constructor, Copy Constructor, operator=, Destructor"
    echo -e "    └─ has(): Loop through data[], check if value exists"
    echo -e "    └─ Lines: ~35 lines total"
    echo ""
    echo -e "  • ${YELLOW}searchable_tree_bag.hpp/.cpp${NC}"
    echo -e "    └─ Inherits: ${GREEN}tree_bag${NC} + ${GREEN}searchable_bag${NC}"
    echo -e "    └─ Must implement: ${MAGENTA}Canon (4 methods) + has() + private search()${NC}"
    echo -e "    └─ Canon: Constructor, Copy Constructor, operator=, Destructor"
    echo -e "    └─ has(): Calls private search() helper"
    echo -e "    └─ search(): Recursive BST search (left < node < right)"
    echo -e "    └─ Lines: ~45 lines total"
    echo ""
    echo -e "  • ${YELLOW}set.hpp/.cpp${NC}"
    echo -e "    └─ Contains: ${GREEN}searchable_bag& bag${NC} (reference member!)"
    echo -e "    └─ ${RED}NO inheritance!${NC} Uses composition to wrap a searchable_bag"
    echo -e "    └─ Must implement: ${MAGENTA}Canon + 6 methods${NC}"
    echo -e "    └─ Canon: Constructor(searchable_bag&), Copy, operator=, Destructor"
    echo -e "    └─ Methods:"
    echo -e "       ${MAGENTA}bool has(int) const${NC}           - delegate to bag.has()"
    echo -e "       ${MAGENTA}void insert(int)${NC}               - only if !has(value)"
    echo -e "       ${MAGENTA}void insert(int*, int)${NC}         - loop + call insert(int)"
    echo -e "       ${MAGENTA}void print() const${NC}             - delegate to bag.print()"
    echo -e "       ${MAGENTA}void clear()${NC}                   - delegate to bag.clear()"
    echo -e "       ${MAGENTA}const searchable_bag& get_bag()${NC} - return bag reference"
    echo -e "    └─ ${YELLOW}Layer: set exists only if searchable_* object exists first!${NC}"
    echo -e "    └─ Lines: ~60 lines total"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}FAQ: Reihenfolge bei Constructor Initialization?${NC}"
    echo -e "  Q: ${BLUE}class searchable_array_bag : public array_bag, public searchable_bag${NC}"
    echo -e "     Beide im Constructor initialisieren?"
    echo -e "  A: ${GREEN}NEIN! Nur array_bag initialisieren:${NC}"
    echo -e "     ${GREEN}searchable_array_bag() : array_bag() { }${NC}"
    echo -e "     ${RED}NICHT: searchable_array_bag() : array_bag(), searchable_bag()${NC}"
    echo -e "     Warum? searchable_bag ist abstrakt und hat keine Member!"
    echo ""
    echo -e "${YELLOW}Layer Info: Wann passiert was?${NC}"
    echo -e "  1. ${GREEN}Objekterzeugung${NC}: searchable_array_bag sab; → bag, array_bag, searchable_bag werden initialisiert"
    echo -e "  2. ${GREEN}Referenzbindung${NC}: searchable_bag& ref = sab; → statischer Typ ändert sich, dynamischer bleibt"
    echo -e "  3. ${GREEN}Methodenaufruf${NC}: ref.has(x); → dispatcht zur konkreten Implementierung in searchable_array_bag"
    echo -e "  4. ${GREEN}set nutzt ref${NC}: set s(sab); → s.bag zeigt auf sab, s kann has/insert delegieren"
    echo -e "  → set funktioniert nur, wenn vorher ein konkretes searchable_* Objekt existiert!"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# LAYER INFO: Step-by-Step Execution
# ============================================================================
show_layer_info() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                  LAYER INFO: Step-by-Step Execution                   ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Step 1: Object Creation (Concrete Layer)${NC}"
    echo -e "  ${GREEN}searchable_array_bag sab;${NC}"
    echo -e "  → Creates: bag (virtual), array_bag, searchable_bag, searchable_array_bag"
    echo -e "  → Memory: One bag instance shared via virtual inheritance"
    echo -e "  → State: All pure virtual methods implemented"
    echo ""
    echo -e "${YELLOW}Step 2: Reference Binding (Interface Layer)${NC}"
    echo -e "  ${GREEN}searchable_bag& ref = sab;${NC}"
    echo -e "  → Static type: searchable_bag& (what compiler sees)"
    echo -e "  → Dynamic type: searchable_array_bag (what runtime uses)"
    echo -e "  → No copy, just alias to existing object"
    echo ""
    echo -e "${YELLOW}Step 3: Polymorphic Call (Dispatch Layer)${NC}"
    echo -e "  ${GREEN}ref.has(x);${NC}"
    echo -e "  → Compiler: Checks searchable_bag has has() method"
    echo -e "  → Runtime: Looks up vtable of searchable_array_bag"
    echo -e "  → Calls: searchable_array_bag::has(x)"
    echo ""
    echo -e "${YELLOW}Step 4: set Usage (Composition Layer)${NC}"
    echo -e "  ${GREEN}set s(sab);${NC}"
    echo -e "  → set.bag = reference to sab"
    echo -e "  → set delegates: s.has(x) → sab.has(x)"
    echo -e "  → set enforces: s.insert(x) only if !s.has(x)"
    echo -e "  → ${RED}set can only exist if searchable_* object exists first!${NC}"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Why this matters:${NC}"
    echo -e "  • Abstraction happens at object creation"
    echo -e "  • Polymorphism via references/pointers"
    echo -e "  • set is a policy wrapper, not a container"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# VIRTUAL INHERITANCE RULES
# ============================================================================
show_virtual_inheritance_rules() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                  VIRTUAL INHERITANCE RULES                           ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Problem: The Diamond${NC}"
    echo -e "  Without virtual inheritance:"
    echo -e "                    ${RED}bag${NC}"
    echo -e "                   /   \\"
    echo -e "             ${RED}array_bag searchable_bag${NC}"
    echo -e "                   \\   /"
    echo -e "          ${RED}searchable_array_bag${NC}"
    echo -e "  → Result: ${RED}TWO copies of bag${NC} in searchable_array_bag → AMBIGUITY!"
    echo ""
    echo -e "${YELLOW}Solution: virtual public inheritance${NC}"
    echo -e "  ${GREEN}class array_bag : virtual public bag${NC}"
    echo -e "  ${GREEN}class searchable_bag : virtual public bag${NC}"
    echo -e "  → Result: ${GREEN}ONE copy of bag${NC} shared by both paths"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Constructor Rules:${NC}"
    echo -e "  1. Most derived class calls ${GREEN}bag()${NC} constructor directly"
    echo -e "  2. Middle classes (array_bag, searchable_bag) DON'T call bag()"
    echo ""
    echo -e "  Example in searchable_array_bag:"
    echo -e "  ${GREEN}searchable_array_bag::searchable_array_bag() : array_bag()${NC}"
    echo -e "  ${GREEN}{ }${NC}"
    echo ""
    echo -e "  Copy constructor:"
    echo -e "  ${GREEN}searchable_array_bag::searchable_array_bag(const searchable_array_bag& s)${NC}"
    echo -e "  ${GREEN}    : array_bag(s)${NC}"
    echo -e "  ${GREEN}{ }${NC}"
    echo ""
    echo -e "  Assignment operator:"
    echo -e "  ${GREEN}searchable_array_bag& operator=(const searchable_array_bag& s)${NC}"
    echo -e "  ${GREEN}{${NC}"
    echo -e "  ${GREEN}    if (this != &s)${NC}"
    echo -e "  ${GREEN}        array_bag::operator=(s);${NC}"
    echo -e "  ${GREEN}    return *this;${NC}"
    echo -e "  ${GREEN}}${NC}"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}WICHTIG: Nur EINE Basisklasse im Constructor initialisieren!${NC}"
    echo ""
    echo -e "  ${RED}❌ FALSCH:${NC}"
    echo -e "  ${RED}searchable_array_bag::searchable_array_bag()${NC}"
    echo -e "  ${RED}    : array_bag(), searchable_bag()  // ← searchable_bag() ist FALSCH!${NC}"
    echo ""
    echo -e "  ${GREEN}✓ RICHTIG:${NC}"
    echo -e "  ${GREEN}searchable_array_bag::searchable_array_bag()${NC}"
    echo -e "  ${GREEN}    : array_bag()  // ← Nur array_bag, searchable_bag weglassen!${NC}"
    echo ""
    echo -e "  ${YELLOW}Warum?${NC}"
    echo -e "  • searchable_bag hat ${BLUE}keine Member-Variablen${NC}"
    echo -e "  • searchable_bag ist ${BLUE}abstrakt${NC} (nur pure virtual has())"
    echo -e "  • Die virtuelle Basisklasse (bag) wird ${BLUE}automatisch${NC} initialisiert"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# METHOD IMPLEMENTATION GUIDE
# ============================================================================
show_method_guide() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                   METHOD IMPLEMENTATION GUIDE                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}1. searchable_array_bag::has(int value) const${NC}"
    echo -e "   Goal: Check if value exists in data[]"
    echo -e "   Available: ${BLUE}this->data${NC} (int*), ${BLUE}this->size${NC} (int)"
    echo -e "   Logic:"
    echo -e "   ${GREEN}for (int i = 0; i < this->size; i++)${NC}"
    echo -e "   ${GREEN}    if (this->data[i] == value)${NC}"
    echo -e "   ${GREEN}        return true;${NC}"
    echo -e "   ${GREEN}return false;${NC}"
    echo ""
    echo -e "${YELLOW}2. searchable_tree_bag::has(int value) const${NC}"
    echo -e "   Goal: Search BST for value"
    echo -e "   Available: ${BLUE}this->tree${NC} (node*)"
    echo -e "   Need helper: ${GREEN}bool search(node* n, int value) const${NC}"
    echo -e "   Logic (recursive):"
    echo -e "   ${GREEN}bool search(node* n, int value) const {${NC}"
    echo -e "   ${GREEN}    if (n == NULL) return false;${NC}"
    echo -e "   ${GREEN}    if (n->value == value) return true;${NC}"
    echo -e "   ${GREEN}    if (value < n->value)${NC}"
    echo -e "   ${GREEN}        return search(n->l, value);${NC}"
    echo -e "   ${GREEN}    return search(n->r, value);${NC}"
    echo -e "   ${GREEN}}${NC}"
    echo ""
    echo -e "${YELLOW}3. set::insert(int value)${NC}"
    echo -e "   Goal: Only insert if NOT already in set (uniqueness)"
    echo -e "   Available: ${BLUE}bag${NC} (searchable_bag& reference)"
    echo -e "   Logic:"
    echo -e "   ${GREEN}if (!(this->has(value)))${NC}"
    echo -e "   ${GREEN}    bag.insert(value);${NC}"
    echo ""
    echo -e "${YELLOW}4. set::insert(int* data, int size)${NC}"
    echo -e "   Goal: Insert array, but skip duplicates"
    echo -e "   Logic:"
    echo -e "   ${GREEN}for (int i = 0; i < size; i++)${NC}"
    echo -e "   ${GREEN}    this->insert(data[i]);  // calls insert(int) above${NC}"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# SETUP TRAINING ENVIRONMENT
# ============================================================================
setup_training_environment() {
    rm -rf "$TRAINING_DIR"
    mkdir -p "$TRAINING_DIR"
    
    # Copy PROVIDED files (read-only reference)
    cp "$RESOURCE_DIR/bag.hpp" "$TRAINING_DIR/"
    cp "$RESOURCE_DIR/searchable_bag.hpp" "$TRAINING_DIR/"
    cp "$RESOURCE_DIR/array_bag.hpp" "$TRAINING_DIR/"
    cp "$RESOURCE_DIR/array_bag.cpp" "$TRAINING_DIR/"
    cp "$RESOURCE_DIR/tree_bag.hpp" "$TRAINING_DIR/"
    cp "$RESOURCE_DIR/tree_bag.cpp" "$TRAINING_DIR/"
    
    # Copy main test file
    if [ -f "$RESOURCE_DIR/main.cpp" ]; then
        cp "$RESOURCE_DIR/main.cpp" "$TRAINING_DIR/"
    fi
}

# ============================================================================
# EXERCISE 1: searchable_array_bag header
# ============================================================================
exercise1_header() {
    cat > "$TRAINING_DIR/searchable_array_bag.hpp" << 'EOF'
#pragma once

#include "array_bag.hpp"
#include "searchable_bag.hpp"

// TODO: Define searchable_array_bag class
// - Inherit from BOTH array_bag AND searchable_bag
// - Declare: constructor, copy constructor, assignment operator, destructor
// - Declare: bool has(int) const;

EOF
}

show_solution1() {
    cat << 'EOF'
#pragma once

#include "array_bag.hpp"
#include "searchable_bag.hpp"

class searchable_array_bag : public array_bag, public searchable_bag
{
	public:
		searchable_array_bag();
		searchable_array_bag(const searchable_array_bag& source);
		searchable_array_bag& operator=(const searchable_array_bag& source);
		bool has(int) const;
		~searchable_array_bag();
};
EOF
}

# ============================================================================
# EXERCISE 2: searchable_array_bag implementation
# ============================================================================
exercise2_impl() {
    cat > "$TRAINING_DIR/searchable_array_bag.cpp" << 'EOF'
#include "searchable_array_bag.hpp"

// TODO: Implement all methods

// Constructor: Call array_bag()
searchable_array_bag::searchable_array_bag()
{
}

// Copy constructor: Call array_bag(source)


// Assignment operator: Delegate to array_bag


// has() method: Loop through this->data[], check if value exists


// Destructor

EOF
}

show_solution2() {
    cat << 'EOF'
#include "searchable_array_bag.hpp"

searchable_array_bag::searchable_array_bag() : array_bag()
{
}

searchable_array_bag::searchable_array_bag(const searchable_array_bag& source) 
    : array_bag(source)
{
}

searchable_array_bag& searchable_array_bag::operator=(const searchable_array_bag& source)
{
	if (this != &source)
	{
		array_bag::operator=(source);
	}
	return (*this);
}

bool searchable_array_bag::has(int value) const
{
	for (int i = 0; i < this->size; i++)
	{
		if (this->data[i] == value)
			return (true);
	}
	return (false);
}

searchable_array_bag::~searchable_array_bag()
{
}
EOF
}

# ============================================================================
# EXERCISE 3: searchable_tree_bag header
# ============================================================================
exercise3_header() {
    cat > "$TRAINING_DIR/searchable_tree_bag.hpp" << 'EOF'
#pragma once

#include "tree_bag.hpp"
#include "searchable_bag.hpp"

// TODO: Define searchable_tree_bag class
// - Inherit from BOTH tree_bag AND searchable_bag
// - Declare private: bool search(node* n, int value) const;
// - Declare public: constructor, copy constructor, assignment operator, destructor
// - Declare public: bool has(int) const;

EOF
}

show_solution3() {
    cat << 'EOF'
#pragma once

#include "tree_bag.hpp"
#include "searchable_bag.hpp"

class searchable_tree_bag : public tree_bag, public searchable_bag
{
	private:
		bool search(node* n, int value) const;
	public:
		searchable_tree_bag();
		searchable_tree_bag(const searchable_tree_bag& source);
		searchable_tree_bag& operator=(const searchable_tree_bag& source);
		bool has(int) const;
		~searchable_tree_bag();
};
EOF
}

# ============================================================================
# EXERCISE 4: searchable_tree_bag implementation
# ============================================================================
exercise4_impl() {
    cat > "$TRAINING_DIR/searchable_tree_bag.cpp" << 'EOF'
#include "searchable_tree_bag.hpp"
#include <cstddef>

// TODO: Implement all methods

// Constructor


// Copy constructor


// Assignment operator


// Private helper: search() - recursive BST search
// Base case: if n == NULL, return false
// If n->value == value, return true
// If value < n->value, search left subtree (n->l)
// Otherwise, search right subtree (n->r)


// Public has(): call search(tree, value)


// Destructor

EOF
}

show_solution4() {
    cat << 'EOF'
#include "searchable_tree_bag.hpp"
#include <cstddef>

searchable_tree_bag::searchable_tree_bag() : tree_bag()
{
}

searchable_tree_bag::searchable_tree_bag(const searchable_tree_bag& source) 
    : tree_bag(source)
{
}

searchable_tree_bag& searchable_tree_bag::operator=(const searchable_tree_bag& source)
{
	if (this != &source)
	{
		tree_bag::operator=(source);
	}
	return (*this);
}

bool searchable_tree_bag::search(node* n, int value) const
{
	if (n == NULL)
		return (false);
	if (n->value == value)
		return (true);
	if (value < n->value)
		return (search(n->l, value));
	return (search(n->r, value));
}

bool searchable_tree_bag::has(int value) const
{
	return (search(tree, value));
}

searchable_tree_bag::~searchable_tree_bag()
{
}
EOF
}

# ============================================================================
# EXERCISE 5: set header
# ============================================================================
exercise5_header() {
    cat > "$TRAINING_DIR/set.hpp" << 'EOF'
#include "searchable_bag.hpp"

// TODO: Define set class
// - Private member: searchable_bag& bag; (REFERENCE!)
// - Constructor: set(searchable_bag& s_bag);
// - Copy constructor, assignment operator, destructor
// - Methods: bool has(int) const;
//            void insert(int);
//            void insert(int*, int);
//            void print() const;
//            void clear();
//            const searchable_bag& get_bag() const;

EOF
}

show_solution5() {
    cat << 'EOF'
#include "searchable_bag.hpp"

class set
{
	private:
		searchable_bag& bag;
	public:
		set(searchable_bag& s_bag);
		set(const set& source);
		set& operator=(const set& source);

		bool has(int) const;
		void insert(int);
		void insert(int*, int);
		void print() const;
		void clear();

		const searchable_bag& get_bag() const;

		~set();
};
EOF
}

# ============================================================================
# EXERCISE 6: set implementation
# ============================================================================
exercise6_impl() {
    cat > "$TRAINING_DIR/set.cpp" << 'EOF'
#include "set.hpp"

// TODO: Implement all methods

// Constructor: Initialize bag reference with s_bag


// Copy constructor: Initialize bag reference with source.bag


// Assignment operator: 
// NOTE: References cannot be reassigned! Just return *this;


// has(): Delegate to bag.has(value)


// insert(int): Only insert if NOT already in set
// Use: if (!(this->has(value))) bag.insert(value);


// insert(int*, int): Loop and call insert(int) for each element


// print(): Delegate to bag.print()


// clear(): Delegate to bag.clear()


// get_bag(): Return bag reference


// Destructor

EOF
}

show_solution6() {
    cat << 'EOF'
#include "set.hpp"

set::set(searchable_bag& s_bag) : bag(s_bag)
{
}

set::set(const set& source) : bag(source.bag)
{
}

set& set::operator=(const set& source)
{
	(void)source;
	// Reference cannot be reassigned, so nothing to do
	return (*this);
}

bool set::has(int value) const
{
	return (bag.has(value));
}

void set::insert(int value)
{
	if (!(this->has(value)))
		bag.insert(value);
}

void set::insert(int* data, int size)
{
	for (int i = 0; i < size; i++)
	{
		this->insert(data[i]);
	}
}

void set::print() const
{
	bag.print();
}

void set::clear()
{
	bag.clear();
}

const searchable_bag& set::get_bag() const
{
	return (this->bag);
}

set::~set()
{
}
EOF
}

# ============================================================================
# COMPILE AND TEST
# ============================================================================
compile_and_test() {
    local exercise=$1
    
    cd "$TRAINING_DIR"
    
    case $exercise in
        1)
            # Header: Create dummy cpp to test syntax and declaration
            cat > temp_test.cpp << 'EOF'
#include "searchable_array_bag.hpp"

int main() {
    searchable_array_bag sab;
    return 0;
}
EOF
            c++ -Wall -Wextra -Werror -std=c++98 -c temp_test.cpp 2>&1
            rm -f temp_test.cpp
            ;;
        2)
            echo -e "${YELLOW}Compiling searchable_array_bag...${NC}"
            if [ -f "main.cpp" ]; then
                c++ -Wall -Wextra -Werror -std=c++98 -o test \
                    array_bag.cpp searchable_array_bag.cpp main.cpp 2>&1
            else
                # Simple test without main
                c++ -Wall -Wextra -Werror -std=c++98 -c \
                    searchable_array_bag.cpp 2>&1
            fi
            ;;
        3)
            # Header: Create dummy cpp to test syntax and declaration
            cat > temp_test.cpp << 'EOF'
#include "searchable_tree_bag.hpp"

int main() {
    searchable_tree_bag stb;
    return 0;
}
EOF
            c++ -Wall -Wextra -Werror -std=c++98 -c temp_test.cpp 2>&1
            rm -f temp_test.cpp
            ;;
        4)
            echo -e "${YELLOW}Compiling searchable_tree_bag...${NC}"
            if [ -f "main.cpp" ]; then
                c++ -Wall -Wextra -Werror -std=c++98 -o test \
                    tree_bag.cpp searchable_tree_bag.cpp main.cpp 2>&1
            else
                c++ -Wall -Wextra -Werror -std=c++98 -c \
                    searchable_tree_bag.cpp 2>&1
            fi
            ;;
        5)
            # Header: Create dummy cpp to test syntax and declaration
            cat > temp_test.cpp << 'EOF'
#include "set.hpp"

int main() {
    // Can't instantiate set without searchable_bag, so just include
    return 0;
}
EOF
            c++ -Wall -Wextra -Werror -std=c++98 -c temp_test.cpp 2>&1
            rm -f temp_test.cpp
            ;;
        6)
            echo -e "${YELLOW}Compiling set...${NC}"
            if [ -f "main.cpp" ]; then
                c++ -Wall -Wextra -Werror -std=c++98 -o test \
                    array_bag.cpp searchable_array_bag.cpp set.cpp main.cpp 2>&1
            else
                c++ -Wall -Wextra -Werror -std=c++98 -c \
                    set.cpp 2>&1
            fi
            ;;
    esac
}

test_exercise() {
    local exercise=$1
    
    echo -e "${CYAN}Testing Exercise $exercise...${NC}"
    
    local compile_output=$(compile_and_test $exercise)
    local compile_status=$?
    
    if [ $compile_status -eq 0 ]; then
        echo -e "${GREEN}✓ Compilation successful!${NC}"
        return 0
    else
        echo -e "${RED}✗ Compilation failed!${NC}"
        echo -e "${YELLOW}Compiler output:${NC}"
        echo "$compile_output"
        echo ""
        echo -e "${CYAN}Analyzing errors for Exercise $exercise...${NC}"
        
        # Analyze compile errors and give hints
        case $exercise in
            1)
                if echo "$compile_output" | grep -q "searchable_array_bag.hpp"; then
                    if echo "$compile_output" | grep -q "expected.*class.*before.*:"; then
                        echo -e "${YELLOW}Hint: Missing class declaration${NC}"
                        echo -e "  class searchable_array_bag : public array_bag, public searchable_bag {"
                    elif echo "$compile_output" | grep -q "expected.*{"; then
                        echo -e "${YELLOW}Hint: Missing opening brace or inheritance syntax${NC}"
                        echo -e "  class searchable_array_bag : public array_bag, public searchable_bag {"
                    elif echo "$compile_output" | grep -q "does not name a type"; then
                        echo -e "${YELLOW}Hint: Missing include or wrong inheritance${NC}"
                        echo -e "  Make sure to include array_bag.hpp and searchable_bag.hpp"
                    elif echo "$compile_output" | grep -q "expected.*;"; then
                        echo -e "${YELLOW}Hint: Missing semicolon after class declaration${NC}"
                        echo -e "  Add ; after the closing brace of the class"
                    fi
                fi
                ;;
            2)
                if echo "$compile_output" | grep -q "searchable_array_bag.cpp"; then
                    if echo "$compile_output" | grep -q "expected.*;"; then
                        echo -e "${YELLOW}Hint: Missing semicolon${NC}"
                        echo -e "  Check for missing ; at end of statements"
                    elif echo "$compile_output" | grep -q "was not declared"; then
                        echo -e "${YELLOW}Hint: Missing include or wrong member access${NC}"
                        echo -e "  Make sure to include searchable_array_bag.hpp"
                    elif echo "$compile_output" | grep -q "has.*not been declared"; then
                        echo -e "${YELLOW}Hint: Implement has() method${NC}"
                        echo -e "  bool searchable_array_bag::has(int value) const { ... }"
                    elif echo "$compile_output" | grep -q "expected.*{"; then
                        echo -e "${YELLOW}Hint: Missing opening brace for function${NC}"
                        echo -e "  bool searchable_array_bag::has(int value) const {"
                    fi
                fi
                ;;
            3)
                if echo "$compile_output" | grep -q "searchable_tree_bag.hpp"; then
                    if echo "$compile_output" | grep -q "expected.*class.*before.*:"; then
                        echo -e "${YELLOW}Hint: Missing class declaration${NC}"
                        echo -e "  class searchable_tree_bag : public tree_bag, public searchable_bag {"
                    elif echo "$compile_output" | grep -q "does not name a type"; then
                        echo -e "${YELLOW}Hint: Missing include or wrong inheritance${NC}"
                        echo -e "  Make sure to include tree_bag.hpp and searchable_bag.hpp"
                    elif echo "$compile_output" | grep -q "expected.*;"; then
                        echo -e "${YELLOW}Hint: Missing semicolon after class declaration${NC}"
                    fi
                fi
                ;;
            4)
                if echo "$compile_output" | grep -q "searchable_tree_bag.cpp"; then
                    if echo "$compile_output" | grep -q "expected.*;"; then
                        echo -e "${YELLOW}Hint: Missing semicolon${NC}"
                    elif echo "$compile_output" | grep -q "has.*not been declared"; then
                        echo -e "${YELLOW}Hint: Implement has() method${NC}"
                        echo -e "  bool searchable_tree_bag::has(int value) const { ... }"
                    elif echo "$compile_output" | grep -q "expected.*{"; then
                        echo -e "${YELLOW}Hint: Missing opening brace for function${NC}"
                    fi
                fi
                ;;
            5)
                if echo "$compile_output" | grep -q "set.hpp"; then
                    if echo "$compile_output" | grep -q "expected.*class.*before.*{"; then
                        echo -e "${YELLOW}Hint: Missing class declaration${NC}"
                        echo -e "  class set { ... };"
                    elif echo "$compile_output" | grep -q "does not name a type"; then
                        echo -e "${YELLOW}Hint: Missing include for searchable_bag${NC}"
                        echo -e "  #include \"searchable_bag.hpp\""
                    elif echo "$compile_output" | grep -q "expected.*;"; then
                        echo -e "${YELLOW}Hint: Missing semicolon after class declaration${NC}"
                    fi
                fi
                ;;
            6)
                if echo "$compile_output" | grep -q "set.cpp"; then
                    if echo "$compile_output" | grep -q "expected.*;"; then
                        echo -e "${YELLOW}Hint: Missing semicolon${NC}"
                    elif echo "$compile_output" | grep -q "bag.*not been declared"; then
                        echo -e "${YELLOW}Hint: Wrong member access${NC}"
                        echo -e "  Use bag.has(value) and bag.insert(value)"
                    elif echo "$compile_output" | grep -q "expected.*{"; then
                        echo -e "${YELLOW}Hint: Missing opening brace for function${NC}"
                    fi
                fi
                ;;
        esac
        return 1
    fi
}

# ============================================================================
# INTERACTIVE EXERCISE LOOP
# ============================================================================
run_exercise() {
    local ex_num=$1
    local ex_name=$2
    local ex_file=$3
    
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    EXERCISE $ex_num: $ex_name${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}File: $ex_file${NC}"
    echo -e "Edit this file in VS Code and implement the required methods."
    echo ""
    echo -e "Options:"
    echo -e "  ${GREEN}[t]${NC} Test your solution"
    echo -e "  ${GREEN}[s]${NC} Show solution"
    echo -e "  ${GREEN}[o]${NC} Open file in VS Code"
    echo -e "  ${GREEN}[r]${NC} Reset file (start over)"
    echo -e "  ${GREEN}[h]${NC} Show method implementation guide"
    echo -e "  ${GREEN}[b]${NC} Back to menu"
    echo ""
    
    # Auto-open in VS Code
    code "$TRAINING_DIR/$ex_file" 2>/dev/null
    
    while true; do
        echo -ne "${CYAN}Your choice: ${NC}"
        read -r choice
        
        case $choice in
            t)
                test_exercise $ex_num
                echo ""
                ;;
            s)
                clear
                echo -e "${YELLOW}═══════ SOLUTION: $ex_name ═══════${NC}"
                show_solution${ex_num}
                echo ""
                echo -e "${YELLOW}Press [c] to copy solution, [b] back${NC}"
                read -r copy_choice
                if [ "$copy_choice" = "c" ]; then
                    show_solution${ex_num} > "$TRAINING_DIR/$ex_file"
                    echo -e "${GREEN}✓ Solution copied to $ex_file${NC}"
                fi
                ;;
            o)
                code "$TRAINING_DIR/$ex_file" 2>/dev/null
                echo -e "${GREEN}Opened in VS Code${NC}"
                ;;
            r)
                case $ex_num in
                    1) exercise1_header ;;
                    2) exercise2_impl ;;
                    3) exercise3_header ;;
                    4) exercise4_impl ;;
                    5) exercise5_header ;;
                    6) exercise6_impl ;;
                esac
                echo -e "${YELLOW}File reset${NC}"
                ;;
            h)
                show_method_guide
                echo -e "${CYAN}Press Enter to continue...${NC}"
                read
                ;;
            b)
                return
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
    done
}

# ============================================================================
# MAIN MENU
# ============================================================================
main_menu() {
    while true; do
        clear
        echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║                      POLYSET TRAINER - MAIN MENU                     ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}Theory (Read first!):${NC}"
        echo -e "  ${GREEN}[1]${NC} Show inheritance diagram (no diamond problem)"
        echo -e "  ${GREEN}[2]${NC} Explain abstract classes"
        echo -e "  ${GREEN}[3]${NC} Show provided vs you-write comparison"
        echo -e "  ${GREEN}[4]${NC} Layer info: step-by-step execution"
        echo -e "  ${GREEN}[5]${NC} Virtual inheritance rules"
        echo -e "  ${GREEN}[6]${NC} Method implementation guide"
        echo ""
        echo -e "${YELLOW}Practice Exercises:${NC}"
        echo -e "  ${GREEN}[7]${NC}  Launch vect2-style trainer (recommended)"
        echo -e "  ${RED}[8-12]${NC} Disabled for now"
        echo ""
        #echo -e "  ${GREEN}[a]${NC} Do ALL exercises in order"
        echo -e "  ${GREEN}[q]${NC} Quit"
        echo ""
        echo -ne "${CYAN}Your choice: ${NC}"
        read -r choice
        
        case $choice in
            1) show_diagram; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
            2) show_abstract_explanation; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
            3) show_comparison; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
            4) show_layer_info; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
            5) show_virtual_inheritance_rules; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
            6) show_method_guide; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
            7)
                VECT_TRAINER="/home/chuhlig/Desktop/42_examshell/polyset_trainer_vect2style_comment_only.sh"
                if [ -x "$VECT_TRAINER" ]; then
                    exec "$VECT_TRAINER"
                else
                    echo -e "${RED}Trainer not found or not executable:${NC} $VECT_TRAINER"
                    echo -e "${YELLOW}Please ensure the script exists and is chmod +x.${NC}"
                    echo -e "${YELLOW}Press Enter to return...${NC}"; read
                fi
                ;;
            8|9|10|11|12)
                echo -e "${YELLOW}These exercises are temporarily disabled.${NC}"
                echo -e "Use option 7 to launch the vect2-style trainer."
                echo -e "${YELLOW}Press Enter to continue...${NC}"; read
                ;;
            # a)
            #     # Do all exercises
            #     for i in {1..6}; do
            #         case $i in
            #             1) exercise1_header; run_exercise 1 "searchable_array_bag.hpp" "searchable_array_bag.hpp" ;;
            #             2) exercise2_impl; run_exercise 2 "searchable_array_bag.cpp" "searchable_array_bag.cpp" ;;
            #             3) exercise3_header; run_exercise 3 "searchable_tree_bag.hpp" "searchable_tree_bag.hpp" ;;
            #             4) exercise4_impl; run_exercise 4 "searchable_tree_bag.cpp" "searchable_tree_bag.cpp" ;;
            #             5) exercise5_header; run_exercise 5 "set.hpp" "set.hpp" ;;
            #             6) exercise6_impl; run_exercise 6 "set.cpp" "set.cpp" ;;
            #         esac
            #     done
            #     ;;
            q)
                echo -e "${GREEN}Good luck on your exam! 🍀${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ============================================================================
# STARTUP
# ============================================================================
# Normal startup (exercises handled via option 7)
setup_training_environment
main_menu



# # # # #!/bin/bash old one

# # # # # ============================================================================
# # # # # POLYSET TRAINER - 42 School Rank05 Exam
# # # # # ============================================================================
# # # # # This trainer covers MULTIPLE INHERITANCE with virtual inheritance in C++
# # # # # You'll learn: virtual inheritance, abstract classes, composition
# # # # # ============================================================================

# # # # RED='\033[0;31m'
# # # # GREEN='\033[0;32m'
# # # # YELLOW='\033[1;33m'
# # # # BLUE='\033[0;34m'
# # # # CYAN='\033[0;36m'
# # # # MAGENTA='\033[0;35m'
# # # # NC='\033[0m' # No Color

# # # # TRAINING_DIR="/tmp/polyset_training"
# # # # RESOURCE_DIR="$HOME/Desktop/42_examshell/.resources/rank05/level1/polyset"

# # # # # ============================================================================
# # # # # INHERITANCE DIAGRAM
# # # # # ============================================================================
# # # # show_diagram() {
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║           POLYSET INHERITANCE HIERARCHY (NO DIAMOND PROBLEM)         ║${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}                           bag (abstract)${NC}"
# # # #     echo -e "${YELLOW}                    virtual │  virtual │${NC}"
# # # #     echo -e "${YELLOW}                    ┌───────┴───┬──────┴────────┐${NC}"
# # # #     echo -e "${YELLOW}                    │           │               │${NC}"
# # # #     echo -e "${GREEN}              array_bag   searchable_bag   tree_bag${NC}"
# # # #     echo -e "${GREEN}              (concrete)    (abstract)    (concrete)${NC}"
# # # #     echo -e "${GREEN}                    │           │               │${NC}"
# # # #     echo -e "${GREEN}                    └─────┬─────┼─────┬─────────┘${NC}"
# # # #     echo -e "${BLUE}                          │     │     │${NC}"
# # # #     echo -e "${BLUE}            searchable_array_bag │ searchable_tree_bag${NC}"
# # # #     echo -e "${BLUE}                   (YOU WRITE)   │    (YOU WRITE)${NC}"
# # # #     echo ""
# # # #     echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${MAGENTA}COMPOSITION (set uses searchable_bag, no inheritance):${NC}"
# # # #     echo -e "${MAGENTA}                              set${NC}"
# # # #     echo -e "${MAGENTA}                              │${NC}"
# # # #     echo -e "${MAGENTA}                              └─ holds reference to ─┐${NC}"
# # # #     echo -e "${MAGENTA}                                                    │${NC}"
# # # #     echo -e "${MAGENTA}                                     searchable_bag&  │${NC}"
# # # #     echo -e "${MAGENTA}                                                    │${NC}"
# # # #     echo -e "${MAGENTA}                                     (points to either) │${NC}"
# # # #     echo -e "${MAGENTA}                                     ┌─────────────────┴─────────────────┐${NC}"
# # # #     echo -e "${MAGENTA}                                     │                                   │${NC}"
# # # #     echo -e "${MAGENTA}                       searchable_array_bag              searchable_tree_bag${NC}"
# # # #     echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${YELLOW}KEY CONCEPTS:${NC}"
# # # #     echo -e "  • ${GREEN}Virtual Inheritance${NC}: Ensures only ONE bag instance in memory"
# # # #     echo -e "  • ${GREEN}Multiple Inheritance${NC}: searchable_* inherit from TWO classes"
# # # #     echo -e "  • ${GREEN}Composition${NC}: set HOLDS a reference, does NOT inherit"
# # # #     echo -e "  • No true diamond problem due to virtual inheritance"
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # # }

# # # # # ============================================================================
# # # # # ABSTRACT CLASS EXPLANATION
# # # # # ============================================================================
# # # # show_abstract_explanation() {
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║                 ABSTRACT CLASSES IN POLYSET                          ║${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}1. bag (abstract base)${NC}"
# # # #     echo -e "   Pure virtual methods (${RED}= 0${NC} means you MUST implement):"
# # # #     echo -e "   ${GREEN}virtual void insert(int) = 0;${NC}"
# # # #     echo -e "   ${GREEN}virtual void insert(int*, int) = 0;${NC}"
# # # #     echo -e "   ${GREEN}virtual void print() const = 0;${NC}"
# # # #     echo -e "   ${GREEN}virtual void clear() = 0;${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}2. searchable_bag (abstract, adds search capability)${NC}"
# # # #     echo -e "   ${GREEN}class searchable_bag : virtual public bag${NC}"
# # # #     echo -e "   Pure virtual method:"
# # # #     echo -e "   ${GREEN}virtual bool has(int) const = 0;${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}3. array_bag (concrete, PROVIDED)${NC}"
# # # #     echo -e "   ${GREEN}class array_bag : virtual public bag${NC}"
# # # #     echo -e "   Implements all 4 bag methods using:"
# # # #     echo -e "   ${BLUE}protected: int *data; int size;${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}4. tree_bag (concrete, PROVIDED)${NC}"
# # # #     echo -e "   ${GREEN}class tree_bag : virtual public bag${NC}"
# # # #     echo -e "   Implements all 4 bag methods using:"
# # # #     echo -e "   ${BLUE}protected: struct node { node *l; node *r; int value; };${NC}"
# # # #     echo -e "   ${BLUE}protected: node *tree;${NC}"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${RED}YOU MUST IMPLEMENT:${NC}"
# # # #     echo -e "  1. ${YELLOW}searchable_array_bag${NC} - inherits from array_bag + searchable_bag"
# # # #     echo -e "  2. ${YELLOW}searchable_tree_bag${NC}  - inherits from tree_bag + searchable_bag"
# # # #     echo -e "  3. ${YELLOW}set${NC}                  - wrapper that enforces uniqueness"
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # # }

# # # # # ============================================================================
# # # # # WHAT'S PROVIDED VS WHAT YOU WRITE
# # # # # ============================================================================
# # # # show_comparison() {
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║              PROVIDED vs YOU MUST WRITE (Comparison)                 ║${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${GREEN}✓ PROVIDED (You get these files):${NC}"
# # # #     echo -e "  • ${BLUE}bag.hpp${NC}              - Abstract base class (4 pure virtual methods)"
# # # #     echo -e "  • ${BLUE}searchable_bag.hpp${NC}   - Abstract class (adds has() method)"
# # # #     echo -e "  • ${BLUE}array_bag.hpp/.cpp${NC}   - Concrete implementation using int *data"
# # # #     echo -e "  • ${BLUE}tree_bag.hpp/.cpp${NC}    - Concrete implementation using BST"
# # # #     echo ""
# # # #     echo -e "${RED}✗ YOU MUST WRITE:${NC}"
# # # #     echo -e "  • ${YELLOW}searchable_array_bag.hpp/.cpp${NC}"
# # # #     echo -e "    └─ Inherits: ${GREEN}array_bag${NC} + ${GREEN}searchable_bag${NC}"
# # # #     echo -e "    └─ Must implement: ${MAGENTA}Canon (4 methods) + has()${NC}"
# # # #     echo -e "    └─ Canon: Constructor, Copy Constructor, operator=, Destructor"
# # # #     echo -e "    └─ has(): Loop through data[], check if value exists"
# # # #     echo -e "    └─ Lines: ~35 lines total"
# # # #     echo ""
# # # #     echo -e "  • ${YELLOW}searchable_tree_bag.hpp/.cpp${NC}"
# # # #     echo -e "    └─ Inherits: ${GREEN}tree_bag${NC} + ${GREEN}searchable_bag${NC}"
# # # #     echo -e "    └─ Must implement: ${MAGENTA}Canon (4 methods) + has() + private search()${NC}"
# # # #     echo -e "    └─ Canon: Constructor, Copy Constructor, operator=, Destructor"
# # # #     echo -e "    └─ has(): Calls private search() helper"
# # # #     echo -e "    └─ search(): Recursive BST search (left < node < right)"
# # # #     echo -e "    └─ Lines: ~45 lines total"
# # # #     echo ""
# # # #     echo -e "  • ${YELLOW}set.hpp/.cpp${NC}"
# # # #     echo -e "    └─ Contains: ${GREEN}searchable_bag& bag${NC} (reference member!)"
# # # #     echo -e "    └─ ${RED}NO inheritance!${NC} Uses composition to wrap a searchable_bag"
# # # #     echo -e "    └─ Must implement: ${MAGENTA}Canon + 6 methods${NC}"
# # # #     echo -e "    └─ Canon: Constructor(searchable_bag&), Copy, operator=, Destructor"
# # # #     echo -e "    └─ Methods:"
# # # #     echo -e "       ${MAGENTA}bool has(int) const${NC}           - delegate to bag.has()"
# # # #     echo -e "       ${MAGENTA}void insert(int)${NC}               - only if !has(value)"
# # # #     echo -e "       ${MAGENTA}void insert(int*, int)${NC}         - loop + call insert(int)"
# # # #     echo -e "       ${MAGENTA}void print() const${NC}             - delegate to bag.print()"
# # # #     echo -e "       ${MAGENTA}void clear()${NC}                   - delegate to bag.clear()"
# # # #     echo -e "       ${MAGENTA}const searchable_bag& get_bag()${NC} - return bag reference"
# # # #     echo -e "    └─ ${YELLOW}Layer: set exists only if searchable_* object exists first!${NC}"
# # # #     echo -e "    └─ Lines: ~60 lines total"
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${YELLOW}FAQ: Reihenfolge bei Constructor Initialization?${NC}"
# # # #     echo -e "  Q: ${BLUE}class searchable_array_bag : public array_bag, public searchable_bag${NC}"
# # # #     echo -e "     Beide im Constructor initialisieren?"
# # # #     echo -e "  A: ${GREEN}NEIN! Nur array_bag initialisieren:${NC}"
# # # #     echo -e "     ${GREEN}searchable_array_bag() : array_bag() { }${NC}"
# # # #     echo -e "     ${RED}NICHT: searchable_array_bag() : array_bag(), searchable_bag()${NC}"
# # # #     echo -e "     Warum? searchable_bag ist abstrakt und hat keine Member!"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Layer Info: Wann passiert was?${NC}"
# # # #     echo -e "  1. ${GREEN}Objekterzeugung${NC}: searchable_array_bag sab; → bag, array_bag, searchable_bag werden initialisiert"
# # # #     echo -e "  2. ${GREEN}Referenzbindung${NC}: searchable_bag& ref = sab; → statischer Typ ändert sich, dynamischer bleibt"
# # # #     echo -e "  3. ${GREEN}Methodenaufruf${NC}: ref.has(x); → dispatcht zur konkreten Implementierung in searchable_array_bag"
# # # #     echo -e "  4. ${GREEN}set nutzt ref${NC}: set s(sab); → s.bag zeigt auf sab, s kann has/insert delegieren"
# # # #     echo -e "  → set funktioniert nur, wenn vorher ein konkretes searchable_* Objekt existiert!"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # # }

# # # # # ============================================================================
# # # # # LAYER INFO: Step-by-Step Execution
# # # # # ============================================================================
# # # # show_layer_info() {
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║                  LAYER INFO: Step-by-Step Execution                   ║${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Step 1: Object Creation (Concrete Layer)${NC}"
# # # #     echo -e "  ${GREEN}searchable_array_bag sab;${NC}"
# # # #     echo -e "  → Creates: bag (virtual), array_bag, searchable_bag, searchable_array_bag"
# # # #     echo -e "  → Memory: One bag instance shared via virtual inheritance"
# # # #     echo -e "  → State: All pure virtual methods implemented"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Step 2: Reference Binding (Interface Layer)${NC}"
# # # #     echo -e "  ${GREEN}searchable_bag& ref = sab;${NC}"
# # # #     echo -e "  → Static type: searchable_bag& (what compiler sees)"
# # # #     echo -e "  → Dynamic type: searchable_array_bag (what runtime uses)"
# # # #     echo -e "  → No copy, just alias to existing object"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Step 3: Polymorphic Call (Dispatch Layer)${NC}"
# # # #     echo -e "  ${GREEN}ref.has(x);${NC}"
# # # #     echo -e "  → Compiler: Checks searchable_bag has has() method"
# # # #     echo -e "  → Runtime: Looks up vtable of searchable_array_bag"
# # # #     echo -e "  → Calls: searchable_array_bag::has(x)"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Step 4: set Usage (Composition Layer)${NC}"
# # # #     echo -e "  ${GREEN}set s(sab);${NC}"
# # # #     echo -e "  → set.bag = reference to sab"
# # # #     echo -e "  → set delegates: s.has(x) → sab.has(x)"
# # # #     echo -e "  → set enforces: s.insert(x) only if !s.has(x)"
# # # #     echo -e "  → ${RED}set can only exist if searchable_* object exists first!${NC}"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${YELLOW}Why this matters:${NC}"
# # # #     echo -e "  • Abstraction happens at object creation"
# # # #     echo -e "  • Polymorphism via references/pointers"
# # # #     echo -e "  • set is a policy wrapper, not a container"
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # # }

# # # # # ============================================================================
# # # # # VIRTUAL INHERITANCE RULES
# # # # # ============================================================================
# # # # show_virtual_inheritance_rules() {
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║                  VIRTUAL INHERITANCE RULES                           ║${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Problem: The Diamond${NC}"
# # # #     echo -e "  Without virtual inheritance:"
# # # #     echo -e "                    ${RED}bag${NC}"
# # # #     echo -e "                   /   \\"
# # # #     echo -e "             ${RED}array_bag searchable_bag${NC}"
# # # #     echo -e "                   \\   /"
# # # #     echo -e "          ${RED}searchable_array_bag${NC}"
# # # #     echo -e "  → Result: ${RED}TWO copies of bag${NC} in searchable_array_bag → AMBIGUITY!"
# # # #     echo ""
# # # #     echo -e "${YELLOW}Solution: virtual public inheritance${NC}"
# # # #     echo -e "  ${GREEN}class array_bag : virtual public bag${NC}"
# # # #     echo -e "  ${GREEN}class searchable_bag : virtual public bag${NC}"
# # # #     echo -e "  → Result: ${GREEN}ONE copy of bag${NC} shared by both paths"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${YELLOW}Constructor Rules:${NC}"
# # # #     echo -e "  1. Most derived class calls ${GREEN}bag()${NC} constructor directly"
# # # #     echo -e "  2. Middle classes (array_bag, searchable_bag) DON'T call bag()"
# # # #     echo ""
# # # #     echo -e "  Example in searchable_array_bag:"
# # # #     echo -e "  ${GREEN}searchable_array_bag::searchable_array_bag() : array_bag()${NC}"
# # # #     echo -e "  ${GREEN}{ }${NC}"
# # # #     echo ""
# # # #     echo -e "  Copy constructor:"
# # # #     echo -e "  ${GREEN}searchable_array_bag::searchable_array_bag(const searchable_array_bag& s)${NC}"
# # # #     echo -e "  ${GREEN}    : array_bag(s)${NC}"
# # # #     echo -e "  ${GREEN}{ }${NC}"
# # # #     echo ""
# # # #     echo -e "  Assignment operator:"
# # # #     echo -e "  ${GREEN}searchable_array_bag& operator=(const searchable_array_bag& s)${NC}"
# # # #     echo -e "  ${GREEN}{${NC}"
# # # #     echo -e "  ${GREEN}    if (this != &s)${NC}"
# # # #     echo -e "  ${GREEN}        array_bag::operator=(s);${NC}"
# # # #     echo -e "  ${GREEN}    return *this;${NC}"
# # # #     echo -e "  ${GREEN}}${NC}"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo -e "${RED}WICHTIG: Nur EINE Basisklasse im Constructor initialisieren!${NC}"
# # # #     echo ""
# # # #     echo -e "  ${RED}❌ FALSCH:${NC}"
# # # #     echo -e "  ${RED}searchable_array_bag::searchable_array_bag()${NC}"
# # # #     echo -e "  ${RED}    : array_bag(), searchable_bag()  // ← searchable_bag() ist FALSCH!${NC}"
# # # #     echo ""
# # # #     echo -e "  ${GREEN}✓ RICHTIG:${NC}"
# # # #     echo -e "  ${GREEN}searchable_array_bag::searchable_array_bag()${NC}"
# # # #     echo -e "  ${GREEN}    : array_bag()  // ← Nur array_bag, searchable_bag weglassen!${NC}"
# # # #     echo ""
# # # #     echo -e "  ${YELLOW}Warum?${NC}"
# # # #     echo -e "  • searchable_bag hat ${BLUE}keine Member-Variablen${NC}"
# # # #     echo -e "  • searchable_bag ist ${BLUE}abstrakt${NC} (nur pure virtual has())"
# # # #     echo -e "  • Die virtuelle Basisklasse (bag) wird ${BLUE}automatisch${NC} initialisiert"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # # }

# # # # # ============================================================================
# # # # # METHOD IMPLEMENTATION GUIDE
# # # # # ============================================================================
# # # # show_method_guide() {
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║                   METHOD IMPLEMENTATION GUIDE                        ║${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}1. searchable_array_bag::has(int value) const${NC}"
# # # #     echo -e "   Goal: Check if value exists in data[]"
# # # #     echo -e "   Available: ${BLUE}this->data${NC} (int*), ${BLUE}this->size${NC} (int)"
# # # #     echo -e "   Logic:"
# # # #     echo -e "   ${GREEN}for (int i = 0; i < this->size; i++)${NC}"
# # # #     echo -e "   ${GREEN}    if (this->data[i] == value)${NC}"
# # # #     echo -e "   ${GREEN}        return true;${NC}"
# # # #     echo -e "   ${GREEN}return false;${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}2. searchable_tree_bag::has(int value) const${NC}"
# # # #     echo -e "   Goal: Search BST for value"
# # # #     echo -e "   Available: ${BLUE}this->tree${NC} (node*)"
# # # #     echo -e "   Need helper: ${GREEN}bool search(node* n, int value) const${NC}"
# # # #     echo -e "   Logic (recursive):"
# # # #     echo -e "   ${GREEN}bool search(node* n, int value) const {${NC}"
# # # #     echo -e "   ${GREEN}    if (n == NULL) return false;${NC}"
# # # #     echo -e "   ${GREEN}    if (n->value == value) return true;${NC}"
# # # #     echo -e "   ${GREEN}    if (value < n->value)${NC}"
# # # #     echo -e "   ${GREEN}        return search(n->l, value);${NC}"
# # # #     echo -e "   ${GREEN}    return search(n->r, value);${NC}"
# # # #     echo -e "   ${GREEN}}${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}3. set::insert(int value)${NC}"
# # # #     echo -e "   Goal: Only insert if NOT already in set (uniqueness)"
# # # #     echo -e "   Available: ${BLUE}bag${NC} (searchable_bag& reference)"
# # # #     echo -e "   Logic:"
# # # #     echo -e "   ${GREEN}if (!(this->has(value)))${NC}"
# # # #     echo -e "   ${GREEN}    bag.insert(value);${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}4. set::insert(int* data, int size)${NC}"
# # # #     echo -e "   Goal: Insert array, but skip duplicates"
# # # #     echo -e "   Logic:"
# # # #     echo -e "   ${GREEN}for (int i = 0; i < size; i++)${NC}"
# # # #     echo -e "   ${GREEN}    this->insert(data[i]);  // calls insert(int) above${NC}"
# # # #     echo ""
# # # #     echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════${NC}"
# # # #     echo ""
# # # # }

# # # # # ============================================================================
# # # # # SETUP TRAINING ENVIRONMENT
# # # # # ============================================================================
# # # # setup_training_environment() {
# # # #     rm -rf "$TRAINING_DIR"
# # # #     mkdir -p "$TRAINING_DIR"
    
# # # #     # Copy PROVIDED files (read-only reference)
# # # #     cp "$RESOURCE_DIR/bag.hpp" "$TRAINING_DIR/"
# # # #     cp "$RESOURCE_DIR/searchable_bag.hpp" "$TRAINING_DIR/"
# # # #     cp "$RESOURCE_DIR/array_bag.hpp" "$TRAINING_DIR/"
# # # #     cp "$RESOURCE_DIR/array_bag.cpp" "$TRAINING_DIR/"
# # # #     cp "$RESOURCE_DIR/tree_bag.hpp" "$TRAINING_DIR/"
# # # #     cp "$RESOURCE_DIR/tree_bag.cpp" "$TRAINING_DIR/"
    
# # # #     # Copy main test file
# # # #     if [ -f "$RESOURCE_DIR/main.cpp" ]; then
# # # #         cp "$RESOURCE_DIR/main.cpp" "$TRAINING_DIR/"
# # # #     fi
# # # # }

# # # # # ============================================================================
# # # # # EXERCISE 1: searchable_array_bag header
# # # # # ============================================================================
# # # # exercise1_header() {
# # # #     cat > "$TRAINING_DIR/searchable_array_bag.hpp" << 'EOF'
# # # # #pragma once

# # # # #include "array_bag.hpp"
# # # # #include "searchable_bag.hpp"

# # # # // TODO: Define searchable_array_bag class
# # # # // - Inherit from BOTH array_bag AND searchable_bag
# # # # // - Declare: constructor, copy constructor, assignment operator, destructor
# # # # // - Declare: bool has(int) const;

# # # # EOF
# # # # }

# # # # show_solution1() {
# # # #     cat << 'EOF'
# # # # #pragma once

# # # # #include "array_bag.hpp"
# # # # #include "searchable_bag.hpp"

# # # # class searchable_array_bag : public array_bag, public searchable_bag
# # # # {
# # # # 	public:
# # # # 		searchable_array_bag();
# # # # 		searchable_array_bag(const searchable_array_bag& source);
# # # # 		searchable_array_bag& operator=(const searchable_array_bag& source);
# # # # 		bool has(int) const;
# # # # 		~searchable_array_bag();
# # # # };
# # # # EOF
# # # # }

# # # # # ============================================================================
# # # # # EXERCISE 2: searchable_array_bag implementation
# # # # # ============================================================================
# # # # exercise2_impl() {
# # # #     cat > "$TRAINING_DIR/searchable_array_bag.cpp" << 'EOF'
# # # # #include "searchable_array_bag.hpp"

# # # # // TODO: Implement all methods

# # # # // Constructor: Call array_bag()
# # # # searchable_array_bag::searchable_array_bag()
# # # # {
# # # # }

# # # # // Copy constructor: Call array_bag(source)


# # # # // Assignment operator: Delegate to array_bag


# # # # // has() method: Loop through this->data[], check if value exists


# # # # // Destructor

# # # # EOF
# # # # }

# # # # show_solution2() {
# # # #     cat << 'EOF'
# # # # #include "searchable_array_bag.hpp"

# # # # searchable_array_bag::searchable_array_bag() : array_bag()
# # # # {
# # # # }

# # # # searchable_array_bag::searchable_array_bag(const searchable_array_bag& source) 
# # # #     : array_bag(source)
# # # # {
# # # # }

# # # # searchable_array_bag& searchable_array_bag::operator=(const searchable_array_bag& source)
# # # # {
# # # # 	if (this != &source)
# # # # 	{
# # # # 		array_bag::operator=(source);
# # # # 	}
# # # # 	return (*this);
# # # # }

# # # # bool searchable_array_bag::has(int value) const
# # # # {
# # # # 	for (int i = 0; i < this->size; i++)
# # # # 	{
# # # # 		if (this->data[i] == value)
# # # # 			return (true);
# # # # 	}
# # # # 	return (false);
# # # # }

# # # # searchable_array_bag::~searchable_array_bag()
# # # # {
# # # # }
# # # # EOF
# # # # }

# # # # # ============================================================================
# # # # # EXERCISE 3: searchable_tree_bag header
# # # # # ============================================================================
# # # # exercise3_header() {
# # # #     cat > "$TRAINING_DIR/searchable_tree_bag.hpp" << 'EOF'
# # # # #pragma once

# # # # #include "tree_bag.hpp"
# # # # #include "searchable_bag.hpp"

# # # # // TODO: Define searchable_tree_bag class
# # # # // - Inherit from BOTH tree_bag AND searchable_bag
# # # # // - Declare private: bool search(node* n, int value) const;
# # # # // - Declare public: constructor, copy constructor, assignment operator, destructor
# # # # // - Declare public: bool has(int) const;

# # # # EOF
# # # # }

# # # # show_solution3() {
# # # #     cat << 'EOF'
# # # # #pragma once

# # # # #include "tree_bag.hpp"
# # # # #include "searchable_bag.hpp"

# # # # class searchable_tree_bag : public tree_bag, public searchable_bag
# # # # {
# # # # 	private:
# # # # 		bool search(node* n, int value) const;
# # # # 	public:
# # # # 		searchable_tree_bag();
# # # # 		searchable_tree_bag(const searchable_tree_bag& source);
# # # # 		searchable_tree_bag& operator=(const searchable_tree_bag& source);
# # # # 		bool has(int) const;
# # # # 		~searchable_tree_bag();
# # # # };
# # # # EOF
# # # # }

# # # # # ============================================================================
# # # # # EXERCISE 4: searchable_tree_bag implementation
# # # # # ============================================================================
# # # # exercise4_impl() {
# # # #     cat > "$TRAINING_DIR/searchable_tree_bag.cpp" << 'EOF'
# # # # #include "searchable_tree_bag.hpp"
# # # # #include <cstddef>

# # # # // TODO: Implement all methods

# # # # // Constructor


# # # # // Copy constructor


# # # # // Assignment operator


# # # # // Private helper: search() - recursive BST search
# # # # // Base case: if n == NULL, return false
# # # # // If n->value == value, return true
# # # # // If value < n->value, search left subtree (n->l)
# # # # // Otherwise, search right subtree (n->r)


# # # # // Public has(): call search(tree, value)


# # # # // Destructor

# # # # EOF
# # # # }

# # # # show_solution4() {
# # # #     cat << 'EOF'
# # # # #include "searchable_tree_bag.hpp"
# # # # #include <cstddef>

# # # # searchable_tree_bag::searchable_tree_bag() : tree_bag()
# # # # {
# # # # }

# # # # searchable_tree_bag::searchable_tree_bag(const searchable_tree_bag& source) 
# # # #     : tree_bag(source)
# # # # {
# # # # }

# # # # searchable_tree_bag& searchable_tree_bag::operator=(const searchable_tree_bag& source)
# # # # {
# # # # 	if (this != &source)
# # # # 	{
# # # # 		tree_bag::operator=(source);
# # # # 	}
# # # # 	return (*this);
# # # # }

# # # # bool searchable_tree_bag::search(node* n, int value) const
# # # # {
# # # # 	if (n == NULL)
# # # # 		return (false);
# # # # 	if (n->value == value)
# # # # 		return (true);
# # # # 	if (value < n->value)
# # # # 		return (search(n->l, value));
# # # # 	return (search(n->r, value));
# # # # }

# # # # bool searchable_tree_bag::has(int value) const
# # # # {
# # # # 	return (search(tree, value));
# # # # }

# # # # searchable_tree_bag::~searchable_tree_bag()
# # # # {
# # # # }
# # # # EOF
# # # # }

# # # # # ============================================================================
# # # # # EXERCISE 5: set header
# # # # # ============================================================================
# # # # exercise5_header() {
# # # #     cat > "$TRAINING_DIR/set.hpp" << 'EOF'
# # # # #include "searchable_bag.hpp"

# # # # // TODO: Define set class
# # # # // - Private member: searchable_bag& bag; (REFERENCE!)
# # # # // - Constructor: set(searchable_bag& s_bag);
# # # # // - Copy constructor, assignment operator, destructor
# # # # // - Methods: bool has(int) const;
# # # # //            void insert(int);
# # # # //            void insert(int*, int);
# # # # //            void print() const;
# # # # //            void clear();
# # # # //            const searchable_bag& get_bag() const;

# # # # EOF
# # # # }

# # # # show_solution5() {
# # # #     cat << 'EOF'
# # # # #include "searchable_bag.hpp"

# # # # class set
# # # # {
# # # # 	private:
# # # # 		searchable_bag& bag;
# # # # 	public:
# # # # 		set(searchable_bag& s_bag);
# # # # 		set(const set& source);
# # # # 		set& operator=(const set& source);

# # # # 		bool has(int) const;
# # # # 		void insert(int);
# # # # 		void insert(int*, int);
# # # # 		void print() const;
# # # # 		void clear();

# # # # 		const searchable_bag& get_bag() const;

# # # # 		~set();
# # # # };
# # # # EOF
# # # # }

# # # # # ============================================================================
# # # # # EXERCISE 6: set implementation
# # # # # ============================================================================
# # # # exercise6_impl() {
# # # #     cat > "$TRAINING_DIR/set.cpp" << 'EOF'
# # # # #include "set.hpp"

# # # # // TODO: Implement all methods

# # # # // Constructor: Initialize bag reference with s_bag


# # # # // Copy constructor: Initialize bag reference with source.bag


# # # # // Assignment operator: 
# # # # // NOTE: References cannot be reassigned! Just return *this;


# # # # // has(): Delegate to bag.has(value)


# # # # // insert(int): Only insert if NOT already in set
# # # # // Use: if (!(this->has(value))) bag.insert(value);


# # # # // insert(int*, int): Loop and call insert(int) for each element


# # # # // print(): Delegate to bag.print()


# # # # // clear(): Delegate to bag.clear()


# # # # // get_bag(): Return bag reference


# # # # // Destructor

# # # # EOF
# # # # }

# # # # show_solution6() {
# # # #     cat << 'EOF'
# # # # #include "set.hpp"

# # # # set::set(searchable_bag& s_bag) : bag(s_bag)
# # # # {
# # # # }

# # # # set::set(const set& source) : bag(source.bag)
# # # # {
# # # # }

# # # # set& set::operator=(const set& source)
# # # # {
# # # # 	(void)source;
# # # # 	// Reference cannot be reassigned, so nothing to do
# # # # 	return (*this);
# # # # }

# # # # bool set::has(int value) const
# # # # {
# # # # 	return (bag.has(value));
# # # # }

# # # # void set::insert(int value)
# # # # {
# # # # 	if (!(this->has(value)))
# # # # 		bag.insert(value);
# # # # }

# # # # void set::insert(int* data, int size)
# # # # {
# # # # 	for (int i = 0; i < size; i++)
# # # # 	{
# # # # 		this->insert(data[i]);
# # # # 	}
# # # # }

# # # # void set::print() const
# # # # {
# # # # 	bag.print();
# # # # }

# # # # void set::clear()
# # # # {
# # # # 	bag.clear();
# # # # }

# # # # const searchable_bag& set::get_bag() const
# # # # {
# # # # 	return (this->bag);
# # # # }

# # # # set::~set()
# # # # {
# # # # }
# # # # EOF
# # # # }

# # # # # ============================================================================
# # # # # COMPILE AND TEST
# # # # # ============================================================================
# # # # compile_and_test() {
# # # #     local exercise=$1
    
# # # #     cd "$TRAINING_DIR"
    
# # # #     case $exercise in
# # # #         1)
# # # #             # Header: Create dummy cpp to test syntax and declaration
# # # #             cat > temp_test.cpp << 'EOF'
# # # # #include "searchable_array_bag.hpp"

# # # # int main() {
# # # #     searchable_array_bag sab;
# # # #     return 0;
# # # # }
# # # # EOF
# # # #             c++ -Wall -Wextra -Werror -std=c++98 -c temp_test.cpp 2>&1
# # # #             rm -f temp_test.cpp
# # # #             ;;
# # # #         2)
# # # #             echo -e "${YELLOW}Compiling searchable_array_bag...${NC}"
# # # #             if [ -f "main.cpp" ]; then
# # # #                 c++ -Wall -Wextra -Werror -std=c++98 -o test \
# # # #                     array_bag.cpp searchable_array_bag.cpp main.cpp 2>&1
# # # #             else
# # # #                 # Simple test without main
# # # #                 c++ -Wall -Wextra -Werror -std=c++98 -c \
# # # #                     searchable_array_bag.cpp 2>&1
# # # #             fi
# # # #             ;;
# # # #         3)
# # # #             # Header: Create dummy cpp to test syntax and declaration
# # # #             cat > temp_test.cpp << 'EOF'
# # # # #include "searchable_tree_bag.hpp"

# # # # int main() {
# # # #     searchable_tree_bag stb;
# # # #     return 0;
# # # # }
# # # # EOF
# # # #             c++ -Wall -Wextra -Werror -std=c++98 -c temp_test.cpp 2>&1
# # # #             rm -f temp_test.cpp
# # # #             ;;
# # # #         4)
# # # #             echo -e "${YELLOW}Compiling searchable_tree_bag...${NC}"
# # # #             if [ -f "main.cpp" ]; then
# # # #                 c++ -Wall -Wextra -Werror -std=c++98 -o test \
# # # #                     tree_bag.cpp searchable_tree_bag.cpp main.cpp 2>&1
# # # #             else
# # # #                 c++ -Wall -Wextra -Werror -std=c++98 -c \
# # # #                     searchable_tree_bag.cpp 2>&1
# # # #             fi
# # # #             ;;
# # # #         5)
# # # #             # Header: Create dummy cpp to test syntax and declaration
# # # #             cat > temp_test.cpp << 'EOF'
# # # # #include "set.hpp"

# # # # int main() {
# # # #     // Can't instantiate set without searchable_bag, so just include
# # # #     return 0;
# # # # }
# # # # EOF
# # # #             c++ -Wall -Wextra -Werror -std=c++98 -c temp_test.cpp 2>&1
# # # #             rm -f temp_test.cpp
# # # #             ;;
# # # #         6)
# # # #             echo -e "${YELLOW}Compiling set...${NC}"
# # # #             if [ -f "main.cpp" ]; then
# # # #                 c++ -Wall -Wextra -Werror -std=c++98 -o test \
# # # #                     array_bag.cpp searchable_array_bag.cpp set.cpp main.cpp 2>&1
# # # #             else
# # # #                 c++ -Wall -Wextra -Werror -std=c++98 -c \
# # # #                     set.cpp 2>&1
# # # #             fi
# # # #             ;;
# # # #     esac
# # # # }

# # # # test_exercise() {
# # # #     local exercise=$1
    
# # # #     echo -e "${CYAN}Testing Exercise $exercise...${NC}"
    
# # # #     local compile_output=$(compile_and_test $exercise)
# # # #     local compile_status=$?
    
# # # #     if [ $compile_status -eq 0 ]; then
# # # #         echo -e "${GREEN}✓ Compilation successful!${NC}"
# # # #         return 0
# # # #     else
# # # #         echo -e "${RED}✗ Compilation failed!${NC}"
# # # #         echo -e "${YELLOW}Compiler output:${NC}"
# # # #         echo "$compile_output"
# # # #         echo ""
# # # #         echo -e "${CYAN}Analyzing errors for Exercise $exercise...${NC}"
        
# # # #         # Analyze compile errors and give hints
# # # #         case $exercise in
# # # #             1)
# # # #                 if echo "$compile_output" | grep -q "searchable_array_bag.hpp"; then
# # # #                     if echo "$compile_output" | grep -q "expected.*class.*before.*:"; then
# # # #                         echo -e "${YELLOW}Hint: Missing class declaration${NC}"
# # # #                         echo -e "  class searchable_array_bag : public array_bag, public searchable_bag {"
# # # #                     elif echo "$compile_output" | grep -q "expected.*{"; then
# # # #                         echo -e "${YELLOW}Hint: Missing opening brace or inheritance syntax${NC}"
# # # #                         echo -e "  class searchable_array_bag : public array_bag, public searchable_bag {"
# # # #                     elif echo "$compile_output" | grep -q "does not name a type"; then
# # # #                         echo -e "${YELLOW}Hint: Missing include or wrong inheritance${NC}"
# # # #                         echo -e "  Make sure to include array_bag.hpp and searchable_bag.hpp"
# # # #                     elif echo "$compile_output" | grep -q "expected.*;"; then
# # # #                         echo -e "${YELLOW}Hint: Missing semicolon after class declaration${NC}"
# # # #                         echo -e "  Add ; after the closing brace of the class"
# # # #                     fi
# # # #                 fi
# # # #                 ;;
# # # #             2)
# # # #                 if echo "$compile_output" | grep -q "searchable_array_bag.cpp"; then
# # # #                     if echo "$compile_output" | grep -q "expected.*;"; then
# # # #                         echo -e "${YELLOW}Hint: Missing semicolon${NC}"
# # # #                         echo -e "  Check for missing ; at end of statements"
# # # #                     elif echo "$compile_output" | grep -q "was not declared"; then
# # # #                         echo -e "${YELLOW}Hint: Missing include or wrong member access${NC}"
# # # #                         echo -e "  Make sure to include searchable_array_bag.hpp"
# # # #                     elif echo "$compile_output" | grep -q "has.*not been declared"; then
# # # #                         echo -e "${YELLOW}Hint: Implement has() method${NC}"
# # # #                         echo -e "  bool searchable_array_bag::has(int value) const { ... }"
# # # #                     elif echo "$compile_output" | grep -q "expected.*{"; then
# # # #                         echo -e "${YELLOW}Hint: Missing opening brace for function${NC}"
# # # #                         echo -e "  bool searchable_array_bag::has(int value) const {"
# # # #                     fi
# # # #                 fi
# # # #                 ;;
# # # #             3)
# # # #                 if echo "$compile_output" | grep -q "searchable_tree_bag.hpp"; then
# # # #                     if echo "$compile_output" | grep -q "expected.*class.*before.*:"; then
# # # #                         echo -e "${YELLOW}Hint: Missing class declaration${NC}"
# # # #                         echo -e "  class searchable_tree_bag : public tree_bag, public searchable_bag {"
# # # #                     elif echo "$compile_output" | grep -q "does not name a type"; then
# # # #                         echo -e "${YELLOW}Hint: Missing include or wrong inheritance${NC}"
# # # #                         echo -e "  Make sure to include tree_bag.hpp and searchable_bag.hpp"
# # # #                     elif echo "$compile_output" | grep -q "expected.*;"; then
# # # #                         echo -e "${YELLOW}Hint: Missing semicolon after class declaration${NC}"
# # # #                     fi
# # # #                 fi
# # # #                 ;;
# # # #             4)
# # # #                 if echo "$compile_output" | grep -q "searchable_tree_bag.cpp"; then
# # # #                     if echo "$compile_output" | grep -q "expected.*;"; then
# # # #                         echo -e "${YELLOW}Hint: Missing semicolon${NC}"
# # # #                     elif echo "$compile_output" | grep -q "has.*not been declared"; then
# # # #                         echo -e "${YELLOW}Hint: Implement has() method${NC}"
# # # #                         echo -e "  bool searchable_tree_bag::has(int value) const { ... }"
# # # #                     elif echo "$compile_output" | grep -q "expected.*{"; then
# # # #                         echo -e "${YELLOW}Hint: Missing opening brace for function${NC}"
# # # #                     fi
# # # #                 fi
# # # #                 ;;
# # # #             5)
# # # #                 if echo "$compile_output" | grep -q "set.hpp"; then
# # # #                     if echo "$compile_output" | grep -q "expected.*class.*before.*{"; then
# # # #                         echo -e "${YELLOW}Hint: Missing class declaration${NC}"
# # # #                         echo -e "  class set { ... };"
# # # #                     elif echo "$compile_output" | grep -q "does not name a type"; then
# # # #                         echo -e "${YELLOW}Hint: Missing include for searchable_bag${NC}"
# # # #                         echo -e "  #include \"searchable_bag.hpp\""
# # # #                     elif echo "$compile_output" | grep -q "expected.*;"; then
# # # #                         echo -e "${YELLOW}Hint: Missing semicolon after class declaration${NC}"
# # # #                     fi
# # # #                 fi
# # # #                 ;;
# # # #             6)
# # # #                 if echo "$compile_output" | grep -q "set.cpp"; then
# # # #                     if echo "$compile_output" | grep -q "expected.*;"; then
# # # #                         echo -e "${YELLOW}Hint: Missing semicolon${NC}"
# # # #                     elif echo "$compile_output" | grep -q "bag.*not been declared"; then
# # # #                         echo -e "${YELLOW}Hint: Wrong member access${NC}"
# # # #                         echo -e "  Use bag.has(value) and bag.insert(value)"
# # # #                     elif echo "$compile_output" | grep -q "expected.*{"; then
# # # #                         echo -e "${YELLOW}Hint: Missing opening brace for function${NC}"
# # # #                     fi
# # # #                 fi
# # # #                 ;;
# # # #         esac
# # # #         return 1
# # # #     fi
# # # # }

# # # # # ============================================================================
# # # # # INTERACTIVE EXERCISE LOOP
# # # # # ============================================================================
# # # # run_exercise() {
# # # #     local ex_num=$1
# # # #     local ex_name=$2
# # # #     local ex_file=$3
    
# # # #     clear
# # # #     echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #     echo -e "${CYAN}║                    EXERCISE $ex_num: $ex_name${NC}"
# # # #     echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #     echo ""
# # # #     echo -e "${YELLOW}File: $ex_file${NC}"
# # # #     echo -e "Edit this file in VS Code and implement the required methods."
# # # #     echo ""
# # # #     echo -e "Options:"
# # # #     echo -e "  ${GREEN}[t]${NC} Test your solution"
# # # #     echo -e "  ${GREEN}[s]${NC} Show solution"
# # # #     echo -e "  ${GREEN}[o]${NC} Open file in VS Code"
# # # #     echo -e "  ${GREEN}[r]${NC} Reset file (start over)"
# # # #     echo -e "  ${GREEN}[h]${NC} Show method implementation guide"
# # # #     echo -e "  ${GREEN}[b]${NC} Back to menu"
# # # #     echo ""
    
# # # #     # Auto-open in VS Code
# # # #     code "$TRAINING_DIR/$ex_file" 2>/dev/null
    
# # # #     while true; do
# # # #         echo -ne "${CYAN}Your choice: ${NC}"
# # # #         read -r choice
        
# # # #         case $choice in
# # # #             t)
# # # #                 test_exercise $ex_num
# # # #                 echo ""
# # # #                 ;;
# # # #             s)
# # # #                 clear
# # # #                 echo -e "${YELLOW}═══════ SOLUTION: $ex_name ═══════${NC}"
# # # #                 show_solution${ex_num}
# # # #                 echo ""
# # # #                 echo -e "${YELLOW}Press [c] to copy solution, [b] back${NC}"
# # # #                 read -r copy_choice
# # # #                 if [ "$copy_choice" = "c" ]; then
# # # #                     show_solution${ex_num} > "$TRAINING_DIR/$ex_file"
# # # #                     echo -e "${GREEN}✓ Solution copied to $ex_file${NC}"
# # # #                 fi
# # # #                 ;;
# # # #             o)
# # # #                 code "$TRAINING_DIR/$ex_file" 2>/dev/null
# # # #                 echo -e "${GREEN}Opened in VS Code${NC}"
# # # #                 ;;
# # # #             r)
# # # #                 case $ex_num in
# # # #                     1) exercise1_header ;;
# # # #                     2) exercise2_impl ;;
# # # #                     3) exercise3_header ;;
# # # #                     4) exercise4_impl ;;
# # # #                     5) exercise5_header ;;
# # # #                     6) exercise6_impl ;;
# # # #                 esac
# # # #                 echo -e "${YELLOW}File reset${NC}"
# # # #                 ;;
# # # #             h)
# # # #                 show_method_guide
# # # #                 echo -e "${CYAN}Press Enter to continue...${NC}"
# # # #                 read
# # # #                 ;;
# # # #             b)
# # # #                 return
# # # #                 ;;
# # # #             *)
# # # #                 echo -e "${RED}Invalid option${NC}"
# # # #                 ;;
# # # #         esac
# # # #     done
# # # # }

# # # # # ============================================================================
# # # # # MAIN MENU
# # # # # ============================================================================
# # # # main_menu() {
# # # #     while true; do
# # # #         clear
# # # #         echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
# # # #         echo -e "${CYAN}║                      POLYSET TRAINER - MAIN MENU                     ║${NC}"
# # # #         echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
# # # #         echo ""
# # # #         echo -e "${YELLOW}Theory (Read first!):${NC}"
# # # #         echo -e "  ${GREEN}[1]${NC} Show inheritance diagram (no diamond problem)"
# # # #         echo -e "  ${GREEN}[2]${NC} Explain abstract classes"
# # # #         echo -e "  ${GREEN}[3]${NC} Show provided vs you-write comparison"
# # # #         echo -e "  ${GREEN}[4]${NC} Layer info: step-by-step execution"
# # # #         echo -e "  ${GREEN}[5]${NC} Virtual inheritance rules"
# # # #         echo -e "  ${GREEN}[6]${NC} Method implementation guide"
# # # #         echo ""
# # # #         echo -e "${YELLOW}Practice Exercises:${NC}"
# # # #         echo -e "  ${GREEN}[7]${NC}  Exercise 1: searchable_array_bag.hpp (header)"
# # # #         echo -e "  ${GREEN}[8]${NC}  Exercise 2: searchable_array_bag.cpp (implementation)"
# # # #         echo -e "  ${GREEN}[9]${NC}  Exercise 3: searchable_tree_bag.hpp (header)"
# # # #         echo -e "  ${GREEN}[10]${NC} Exercise 4: searchable_tree_bag.cpp (implementation)"
# # # #         echo -e "  ${GREEN}[11]${NC} Exercise 5: set.hpp (header)"
# # # #         echo -e "  ${GREEN}[12]${NC} Exercise 6: set.cpp (implementation)"
# # # #         echo ""
# # # #         echo -e "  ${GREEN}[a]${NC} Do ALL exercises in order"
# # # #         echo -e "  ${GREEN}[q]${NC} Quit"
# # # #         echo ""
# # # #         echo -ne "${CYAN}Your choice: ${NC}"
# # # #         read -r choice
        
# # # #         case $choice in
# # # #             1) show_diagram; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
# # # #             2) show_abstract_explanation; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
# # # #             3) show_comparison; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
# # # #             4) show_layer_info; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
# # # #             5) show_virtual_inheritance_rules; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
# # # #             6) show_method_guide; echo ""; echo -e "${CYAN}Press Enter...${NC}"; read ;;
# # # #             7) 
# # # #                 exercise1_header
# # # #                 run_exercise 1 "searchable_array_bag.hpp" "searchable_array_bag.hpp"
# # # #                 ;;
# # # #             8)
# # # #                 exercise2_impl
# # # #                 run_exercise 2 "searchable_array_bag.cpp" "searchable_array_bag.cpp"
# # # #                 ;;
# # # #             9)
# # # #                 exercise3_header
# # # #                 run_exercise 3 "searchable_tree_bag.hpp" "searchable_tree_bag.hpp"
# # # #                 ;;
# # # #             10)
# # # #                 exercise4_impl
# # # #                 run_exercise 4 "searchable_tree_bag.cpp" "searchable_tree_bag.cpp"
# # # #                 ;;
# # # #             11)
# # # #                 exercise5_header
# # # #                 run_exercise 5 "set.hpp" "set.hpp"
# # # #                 ;;
# # # #             12)
# # # #                 exercise6_impl
# # # #                 run_exercise 6 "set.cpp" "set.cpp"
# # # #                 ;;
# # # #             a)
# # # #                 # Do all exercises
# # # #                 for i in {1..6}; do
# # # #                     case $i in
# # # #                         1) exercise1_header; run_exercise 1 "searchable_array_bag.hpp" "searchable_array_bag.hpp" ;;
# # # #                         2) exercise2_impl; run_exercise 2 "searchable_array_bag.cpp" "searchable_array_bag.cpp" ;;
# # # #                         3) exercise3_header; run_exercise 3 "searchable_tree_bag.hpp" "searchable_tree_bag.hpp" ;;
# # # #                         4) exercise4_impl; run_exercise 4 "searchable_tree_bag.cpp" "searchable_tree_bag.cpp" ;;
# # # #                         5) exercise5_header; run_exercise 5 "set.hpp" "set.hpp" ;;
# # # #                         6) exercise6_impl; run_exercise 6 "set.cpp" "set.cpp" ;;
# # # #                     esac
# # # #                 done
# # # #                 ;;
# # # #             q)
# # # #                 echo -e "${GREEN}Good luck on your exam! 🍀${NC}"
# # # #                 exit 0
# # # #                 ;;
# # # #             *)
# # # #                 echo -e "${RED}Invalid option${NC}"
# # # #                 sleep 1
# # # #                 ;;
# # # #         esac
# # # #     done
# # # # }

# # # # # ============================================================================
# # # # # STARTUP
# # # # # ============================================================================
# # # # # Temporarily disable local exercises and delegate to vect2-style trainer
# # # # # setup_training_environment
# # # # # main_menu

# # # # VECT_TRAINER="/home/chuhlig/Desktop/42_examshell/polyset_trainer_vect2style_comment_only.sh"
# # # # if [ -x "$VECT_TRAINER" ]; then
# # # #     exec "$VECT_TRAINER"
# # # # else
# # # #     echo "Error: vect2-style trainer not found or not executable: $VECT_TRAINER" >&2
# # # #     exit 1
# # # # fi
