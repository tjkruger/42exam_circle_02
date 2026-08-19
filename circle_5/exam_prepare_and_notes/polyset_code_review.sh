#!/bin/bash

# polyset_code_review.sh - Ist dieser Code richtig?
# Trainiere dein Auge für Fehler bei virtual inheritance!

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
    read -p "Ist dieser Code RICHTIG? (y/n): " answer
    
    if [[ "$answer" == "y" && "$is_correct" == "yes" ]] || \
       [[ "$answer" == "n" && "$is_correct" == "no" ]]; then
        echo -e "${GREEN}✓ RICHTIG!${NC}"
        ((score++))
    else
        echo -e "${RED}✗ FALSCH!${NC}"
        if [ "$is_correct" == "yes" ]; then
            echo -e "${GREEN}Dieser Code ist RICHTIG!${NC}"
        else
            echo -e "${RED}Dieser Code ist FALSCH!${NC}"
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}Erklärung:${NC}"
    echo "$explanation"
    echo ""
    read -p "Drück ENTER..."
}

# ============================================================================
# SNIPPETS - INHERITANCE & CLASS DECLARATIONS
# ============================================================================

# RICHTIG: bag abstract class
show_snippet \
"bag.hpp - Abstract Base Class" \
"class bag
{
 public:
    virtual void insert(int) = 0;
    virtual void insert(int*, int) = 0;
    virtual void print() const = 0;
    virtual void clear() = 0;
};" \
"yes" \
"✓ Pure virtual methods (= 0)
✓ Macht bag ABSTRACT → kann nicht instanziert werden
✓ Derived classes MÜSSEN diese implementieren
→ Warum richtig? Abstract base für polymorphes Design"

# FALSCH: bag - fehlendes virtual
show_snippet \
"bag.hpp - Fehlende virtual Keyword" \
"class bag
{
 public:
    void insert(int) = 0;
    void insert(int*, int) = 0;
    void print() const = 0;
    void clear() = 0;
};" \
"no" \
"❌ Fehlt 'virtual' bei = 0!
→ Compiler Error: nur virtual kann = 0 sein
→ Pure virtual functions brauchen virtual keyword
→ Fix: virtual void insert(int) = 0;"

# RICHTIG: searchable_bag with virtual inheritance
show_snippet \
"searchable_bag.hpp - Virtual Inheritance" \
"class searchable_bag : virtual public bag
{
 public:
    virtual bool has(int) const = 0;
};" \
"yes" \
"✓ 'virtual public bag' → löst diamond problem
✓ Nur EINE bag-Instanz in searchable_array_bag
✓ has() ist pure virtual (= 0)
→ Warum richtig? Verhindert multiple bag copies"

# FALSCH: searchable_bag - fehlt virtual
show_snippet \
"searchable_bag.hpp - Fehlt virtual Inheritance" \
"class searchable_bag : public bag
{
 public:
    virtual bool has(int) const = 0;
};" \
"no" \
"❌ Fehlt 'virtual' vor 'public bag'!
→ searchable_array_bag hätte ZWEI bag-Instanzen
→ Diamond problem: Ambiguität bei bag methods
→ Fix: virtual public bag"

# RICHTIG: array_bag with virtual inheritance
show_snippet \
"array_bag.hpp - Virtual Inheritance" \
"class array_bag : virtual public bag
{
 protected:
    int *data;
    int size;
    
 public:
    array_bag();
    void insert(int);
    void print() const;
    void clear();
};" \
"yes" \
"✓ virtual public bag → für diamond prevention
✓ protected members für derived classes
✓ Implementiert alle bag methods (kein = 0)
→ Warum richtig? Concrete class mit virtual inheritance"

# FALSCH: array_bag - private statt protected
show_snippet \
"array_bag.hpp - Private Members" \
"class array_bag : virtual public bag
{
 private:
    int *data;
    int size;
    
 public:
    array_bag();
    void insert(int);
};" \
"no" \
"❌ data und size sind private!
→ searchable_array_bag kann NICHT auf data[] zugreifen
→ has() braucht data[] zum durchsuchen
→ Fix: protected statt private"

# RICHTIG: searchable_array_bag multiple inheritance
show_snippet \
"searchable_array_bag.hpp - Multiple Inheritance" \
"class searchable_array_bag : public array_bag, 
                               public searchable_bag
{
 public:
    searchable_array_bag();
    searchable_array_bag(const searchable_array_bag&);
    searchable_array_bag& operator=(const searchable_array_bag&);
    bool has(int) const;
    ~searchable_array_bag();
};" \
"yes" \
"✓ Erbt von array_bag UND searchable_bag
✓ Canon: Constructor, Copy, operator=, Destructor
✓ Implementiert has() (kein = 0 mehr!)
→ Warum richtig? Komplette concrete class"

# FALSCH: searchable_array_bag - fehlt has()
show_snippet \
"searchable_array_bag.hpp - Fehlt has() Implementation" \
"class searchable_array_bag : public array_bag,
                               public searchable_bag
{
 public:
    searchable_array_bag();
    ~searchable_array_bag();
};" \
"no" \
"❌ Fehlt 'bool has(int) const;' Deklaration!
→ searchable_bag fordert has() (pure virtual)
→ Ohne has() bleibt searchable_array_bag ABSTRACT
→ Fix: bool has(int) const; hinzufügen"

# ============================================================================
# SNIPPETS - CONSTRUCTORS & INITIALIZATION
# ============================================================================

# RICHTIG: searchable_array_bag default constructor
show_snippet \
"searchable_array_bag.cpp - Default Constructor" \
"searchable_array_bag::searchable_array_bag() : array_bag()
{
}" \
"yes" \
"✓ Initialisiert array_bag() im initializer list
✓ NICHT searchable_bag() (ist abstrakt, keine Member)
✓ bag() wird automatisch initialisiert (virtual)
→ Warum richtig? Nur concrete base class initialisieren!"

# FALSCH: searchable_array_bag - beide bases init
show_snippet \
"searchable_array_bag.cpp - Beide Bases Init" \
"searchable_array_bag::searchable_array_bag() 
    : array_bag(), searchable_bag()
{
}" \
"no" \
"❌ Initialisiert searchable_bag()!
→ searchable_bag hat keine Member-Variablen
→ searchable_bag ist abstrakt (nur interface)
→ Fix: nur array_bag() im initializer list"

# FALSCH: searchable_array_bag - keine initialization
show_snippet \
"searchable_array_bag.cpp - Keine Initialization" \
"searchable_array_bag::searchable_array_bag()
{
}" \
"no" \
"❌ Kein initializer list!
→ array_bag() wird nicht explizit aufgerufen
→ Funktioniert, aber NICHT idiomatisch
→ Best practice: : array_bag() im initializer list"

# RICHTIG: searchable_array_bag copy constructor
show_snippet \
"searchable_array_bag.cpp - Copy Constructor" \
"searchable_array_bag::searchable_array_bag(
    const searchable_array_bag& source) 
    : array_bag(source)
{
}" \
"yes" \
"✓ Ruft array_bag(source) copy constructor auf
✓ array_bag kopiert data[] und size
✓ NICHT searchable_bag (hat nichts zum kopieren)
→ Warum richtig? Delegiert an base class"

# FALSCH: searchable_array_bag - *this = source
show_snippet \
"searchable_array_bag.cpp - Copy via Assignment" \
"searchable_array_bag::searchable_array_bag(
    const searchable_array_bag& source)
{
    *this = source;
}" \
"no" \
"❌ Kein initializer list!
→ array_bag wird mit default constructor initialisiert
→ DANN erst *this = source (doppelte Arbeit)
→ Fix: : array_bag(source) im initializer list"

# RICHTIG: searchable_array_bag operator=
show_snippet \
"searchable_array_bag.cpp - Assignment Operator" \
"searchable_array_bag& searchable_array_bag::operator=(
    const searchable_array_bag& source)
{
    if (this != &source)
    {
        array_bag::operator=(source);
    }
    return (*this);
}" \
"yes" \
"✓ Self-assignment check (this != &source)
✓ Delegiert an array_bag::operator=
✓ return *this für chaining
→ Warum richtig? Nutzt base class assignment"

# FALSCH: searchable_array_bag operator= - kein return
show_snippet \
"searchable_array_bag.cpp - Fehlt return" \
"searchable_array_bag& searchable_array_bag::operator=(
    const searchable_array_bag& source)
{
    if (this != &source)
    {
        array_bag::operator=(source);
    }
}" \
"no" \
"❌ Fehlt return Statement!
→ Return-Type ist searchable_array_bag&
→ MUSS *this returnen
→ Fix: return (*this); am Ende"

# ============================================================================
# SNIPPETS - has() METHOD IMPLEMENTATIONS
# ============================================================================

# RICHTIG: searchable_array_bag::has()
show_snippet \
"searchable_array_bag.cpp - has() Method" \
"bool searchable_array_bag::has(int value) const
{
    for (int i = 0; i < this->size; i++)
    {
        if (this->data[i] == value)
            return (true);
    }
    return (false);
}" \
"yes" \
"✓ Loop durch this->data[] (0 bis size-1)
✓ Return true wenn gefunden
✓ Return false wenn nicht gefunden
→ Warum richtig? Simple linear search in array"

# FALSCH: searchable_array_bag::has() - i <= size
show_snippet \
"searchable_array_bag.cpp - has() Out of Bounds" \
"bool searchable_array_bag::has(int value) const
{
    for (int i = 0; i <= this->size; i++)
    {
        if (this->data[i] == value)
            return (true);
    }
    return (false);
}" \
"no" \
"❌ Loop condition ist i <= size!
→ Array indices: 0 bis size-1
→ i <= size geht bis size (out of bounds!)
→ Fix: i < this->size (ohne =)"

# FALSCH: searchable_array_bag::has() - fehlt return
show_snippet \
"searchable_array_bag.cpp - has() Fehlt false Return" \
"bool searchable_array_bag::has(int value) const
{
    for (int i = 0; i < this->size; i++)
    {
        if (this->data[i] == value)
            return (true);
    }
}" \
"no" \
"❌ Fehlt return (false); nach Loop!
→ Wenn nicht gefunden, MUSS false returnen
→ Compiler Warning: control reaches end
→ Fix: return (false); nach Loop"

# RICHTIG: searchable_tree_bag::has() with helper
show_snippet \
"searchable_tree_bag.cpp - has() Method" \
"bool searchable_tree_bag::has(int value) const
{
    return (search(tree, value));
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
}" \
"yes" \
"✓ has() ruft search() helper auf
✓ search() ist recursive BST traversal
✓ Base case: n == NULL → false
✓ Check: n->value == value → true
✓ Recursive: left if value < n->value, else right
→ Warum richtig? Klassische BST search implementation"

# FALSCH: searchable_tree_bag::search() - kein base case
show_snippet \
"searchable_tree_bag.cpp - search() Kein Base Case" \
"bool searchable_tree_bag::search(node* n, int value) const
{
    if (n->value == value)
        return (true);
    if (value < n->value)
        return (search(n->l, value));
    return (search(n->r, value));
}" \
"no" \
"❌ Fehlt NULL check (base case)!
→ Wenn n == NULL, n->value ist undefined!
→ Segmentation fault
→ Fix: if (n == NULL) return (false); am Anfang"

# FALSCH: searchable_tree_bag::search() - <= statt <
show_snippet \
"searchable_tree_bag.cpp - search() Falsche Condition" \
"bool searchable_tree_bag::search(node* n, int value) const
{
    if (n == NULL)
        return (false);
    if (n->value == value)
        return (true);
    if (value <= n->value)
        return (search(n->l, value));
    return (search(n->r, value));
}" \
"no" \
"❌ Condition ist 'value <= n->value'!
→ Wenn value == n->value, geht es nach links
→ ABER: wurde schon mit n->value == value gecheckt!
→ Sollte nur < sein, nicht <=
→ Fix: value < n->value (ohne =)"

# ============================================================================
# SNIPPETS - SET CLASS
# ============================================================================

# RICHTIG: set.hpp declaration
show_snippet \
"set.hpp - Class Declaration" \
"class set
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
};" \
"yes" \
"✓ Member: searchable_bag& (REFERENZ!)
✓ Constructor nimmt searchable_bag& parameter
✓ Canon: Constructor, Copy, operator=, Destructor
✓ Methods: has, insert x2, print, clear, get_bag
→ Warum richtig? Wrapper für uniqueness enforcement"

# FALSCH: set - bag ist pointer
show_snippet \
"set.hpp - bag als Pointer" \
"class set
{
 private:
    searchable_bag* bag;
    
 public:
    set(searchable_bag* s_bag);
    bool has(int) const;
    void insert(int);
};" \
"no" \
"❌ bag ist pointer (searchable_bag*)!
→ Subject sagt: searchable_bag& (Referenz)
→ Mit pointer: mehr memory management nötig
→ Fix: searchable_bag& bag; (Referenz)"

# RICHTIG: set constructor
show_snippet \
"set.cpp - Constructor" \
"set::set(searchable_bag& s_bag) : bag(s_bag)
{
}" \
"yes" \
"✓ Initialisiert bag reference mit s_bag
✓ References MÜSSEN im initializer list init werden
✓ Können nicht later assigned werden
→ Warum richtig? Reference binding bei construction"

# FALSCH: set constructor - assignment in body
show_snippet \
"set.cpp - Constructor Assignment" \
"set::set(searchable_bag& s_bag)
{
    bag = s_bag;
}" \
"no" \
"❌ Reference binding im body!
→ References MÜSSEN im initializer list gebunden werden
→ Compiler Error: uninitialized reference
→ Fix: : bag(s_bag) im initializer list"

# RICHTIG: set copy constructor
show_snippet \
"set.cpp - Copy Constructor" \
"set::set(const set& source) : bag(source.bag)
{
}" \
"yes" \
"✓ Bindet bag an source.bag
✓ Reference copy (kein deep copy nötig)
✓ Beide sets sharen gleichen bag
→ Warum richtig? Reference binding im initializer"

# RICHTIG: set operator=
show_snippet \
"set.cpp - Assignment Operator" \
"set& set::operator=(const set& source)
{
    (void)source;
    // Reference cannot be reassigned
    return (*this);
}" \
"yes" \
"✓ References können NICHT reassigned werden!
✓ bag bleibt gebunden an original reference
✓ (void)source vermeidet unused warning
→ Warum richtig? References sind immutable bindings"

# FALSCH: set operator= - versucht reassignment
show_snippet \
"set.cpp - Versucht Reference Reassignment" \
"set& set::operator=(const set& source)
{
    if (this != &source)
    {
        bag = source.bag;
    }
    return (*this);
}" \
"no" \
"❌ Versucht bag reference zu reassign!
→ References können nach init NICHT geändert werden
→ bag = source.bag ruft bag.operator= auf (falsch)
→ Fix: (void)source; return *this; (nichts tun)"

# RICHTIG: set::insert(int) with uniqueness check
show_snippet \
"set.cpp - insert(int) Method" \
"void set::insert(int value)
{
    if (!(this->has(value)))
        bag.insert(value);
}" \
"yes" \
"✓ Checkt ERST ob value existiert (has())
✓ Nur wenn NICHT vorhanden → bag.insert()
✓ Enforces uniqueness (SET property)
→ Warum richtig? Verhindert duplicates"

# FALSCH: set::insert(int) - keine uniqueness check
show_snippet \
"set.cpp - insert(int) Ohne Check" \
"void set::insert(int value)
{
    bag.insert(value);
}" \
"no" \
"❌ Keine uniqueness check!
→ Duplicates werden eingefügt
→ Kein SET mehr, nur bag wrapper
→ Fix: if (!(this->has(value))) vor insert"

# RICHTIG: set::insert(int*, int) array version
show_snippet \
"set.cpp - insert(int*, int) Method" \
"void set::insert(int* data, int size)
{
    for (int i = 0; i < size; i++)
    {
        this->insert(data[i]);
    }
}" \
"yes" \
"✓ Loop durch array
✓ Ruft this->insert(int) für jedes Element auf
✓ insert(int) macht uniqueness check
→ Warum richtig? Code reuse, DRY principle"

# FALSCH: set::insert(int*, int) - ruft bag.insert direkt
show_snippet \
"set.cpp - insert(int*, int) Keine Uniqueness" \
"void set::insert(int* data, int size)
{
    bag.insert(data, size);
}" \
"no" \
"❌ Ruft bag.insert() direkt auf!
→ Keine uniqueness check per element
→ Array mit duplicates wird komplett eingefügt
→ Fix: Loop + this->insert(data[i])"

# RICHTIG: set::has() delegation
show_snippet \
"set.cpp - has() Method" \
"bool set::has(int value) const
{
    return (bag.has(value));
}" \
"yes" \
"✓ Delegiert direkt an bag.has()
✓ Kein eigener Code nötig
→ Warum richtig? Simple wrapper delegation"

# RICHTIG: set::print() delegation
show_snippet \
"set.cpp - print() Method" \
"void set::print() const
{
    bag.print();
}" \
"yes" \
"✓ Delegiert direkt an bag.print()
✓ Kein eigener Code nötig
→ Warum richtig? Simple wrapper delegation"

# RICHTIG: set::get_bag()
show_snippet \
"set.cpp - get_bag() Method" \
"const searchable_bag& set::get_bag() const
{
    return (this->bag);
}" \
"yes" \
"✓ Return const reference
✓ const method (ändert set nicht)
✓ Getter für internal bag
→ Warum richtig? Const-correct getter"

# FALSCH: set::get_bag() - return by value
show_snippet \
"set.cpp - get_bag() Return by Value" \
"searchable_bag set::get_bag() const
{
    return (bag);
}" \
"no" \
"❌ Return-Type ist searchable_bag (by value)!
→ searchable_bag ist abstrakt → KANN NICHT kopiert werden
→ Compiler Error: cannot instantiate abstract class
→ Fix: const searchable_bag& (by reference)"

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
    echo -e "${BLUE}║${NC}  ${GREEN}🎉 EXCELLENT!${NC} Du erkennst polyset Fehler sofort!"
    echo -e "${BLUE}║${NC}  ${GREEN}Virtual inheritance, multiple inheritance: MASTERED!${NC}"
elif [ $percentage -ge 70 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}👍 GUT!${NC} Noch ein paar Unsicherheiten bei inheritance"
    echo -e "${BLUE}║${NC}  ${YELLOW}Review: virtual public, initializer lists, references${NC}"
elif [ $percentage -ge 50 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}⚠️  OKAY${NC} - Lies polyset_trainer.sh sections"
    echo -e "${BLUE}║${NC}  ${YELLOW}Focus: diamond problem, virtual inheritance${NC}"
else
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${RED}❌ NOCH NICHT READY!${NC}"
    echo -e "${BLUE}║${NC}  ${RED}Run ./polyset_trainer.sh Theory sections 1-5${NC}"
fi

echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

read -p "Drück ENTER um zu beenden..."
