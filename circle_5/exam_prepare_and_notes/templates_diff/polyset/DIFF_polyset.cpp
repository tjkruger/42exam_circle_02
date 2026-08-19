/* **************************************************************************** */
/*                        POLYSET - ULTRA KLARE DIFF                            */
/* **************************************************************************** */

/*
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎯 POLYSET EXAM - WAS IST WAS?                            ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  📦 GEGEBEN (schon da, NICHT anfassen!):                                    ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  ✅ bag.hpp                    ← Interface (pure virtual)                   ║
║  ✅ searchable_bag.hpp         ← Interface (pure virtual)                   ║
║  ✅ array_bag.hpp/.cpp         ← Funktioniert mit Array                     ║
║  ✅ tree_bag.hpp/.cpp          ← Funktioniert mit BST                       ║
║  ✅ main.cpp                   ← Test Programm                              ║
║                                                                              ║
║  → ALLES FERTIG! Du darfst sie NUR benutzen!                                ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  📝 DU MUSST SCHREIBEN (3 neue Classes):                                    ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  ❌ searchable_array_bag.hpp   ← NEUE Klasse (du schreibst)                ║
║  ❌ searchable_tree_bag.hpp    ← NEUE Klasse (du schreibst)                ║
║  ❌ searchable_set.hpp         ← NEUE Klasse (du schreibst)                ║
║                                                                              ║
║  → Diese 3 Files existieren NICHT! Du erstellst sie!                        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    📖 WIE FUNKTIONIERT DAS?                                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Gegeben sind 2 fertige Klassen:                                            ║
║                                                                              ║
║  ┌─────────────┐        ┌─────────────┐                                     ║
║  │ array_bag   │        │ tree_bag    │                                     ║
║  ├─────────────┤        ├─────────────┤                                     ║
║  │ insert()    │        │ insert()    │                                     ║
║  │ print()     │        │ print()     │                                     ║
║  │ clear()     │        │ clear()     │                                     ║
║  └─────────────┘        └─────────────┘                                     ║
║                                                                              ║
║  Problem: Sie haben KEIN has()!                                             ║
║                                                                              ║
║  Lösung: Kombiniere sie mit searchable_bag!                                 ║
║                                                                              ║
║  ┌─────────────────┐                                                        ║
║  │ searchable_bag  │  ← Interface mit has()                                ║
║  └─────────────────┘                                                        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  KLASSE 1: searchable_array_bag                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  File: searchable_array_bag.hpp  (DU ERSTELLST DAS!)                        ║
║                                                                              ║
║  ┌─ GEGEBEN: ──────────────────┐        ┌─ DU SCHREIBST: ────────────────┐ ║
║  │ array_bag                   │        │ searchable_array_bag           │ ║
║  │ ─────────────────────       │        │ ───────────────────────        │ ║
║  │ + insert()   ✅             │   ┌───→│ + insert()   (geerbt)          │ ║
║  │ + print()    ✅             │   │    │ + print()    (geerbt)          │ ║
║  │ + clear()    ✅             │   │    │ + clear()    (geerbt)          │ ║
║  │ + data[]                    │   │    │ + data[]     (geerbt)          │ ║
║  │ + size                      │   │    │ + size       (geerbt)          │ ║
║  └─────────────────────────────┘   │    │                                │ ║
║                                     │    │ + has()      ← NEU! 🎯        │ ║
║  ┌─ INTERFACE: ────────────────┐   │    │   (implementiere es!)          │ ║
║  │ searchable_bag              │   │    └────────────────────────────────┘ ║
║  │ ─────────────────────       │   │                                        ║
║  │ + has() = pure virtual  ❌  │───┘    Multiple Inheritance:               ║
║  └─────────────────────────────┘        : public array_bag,                 ║
║                                            public searchable_bag             ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  #ifndef SEARCHABLE_ARRAY_BAG_HPP                                            ║
║  #define SEARCHABLE_ARRAY_BAG_HPP                                            ║
║  #include "array_bag.hpp"          ← GEGEBEN                                ║
║  #include "searchable_bag.hpp"     ← GEGEBEN                                ║
║                                                                              ║
║  class searchable_array_bag                                                  ║
║      : public array_bag,           ← Erbt insert/print/clear                ║
║        public searchable_bag {     ← Muss has() implementieren              ║
║  public:                                                                     ║
║      searchable_array_bag() : array_bag() {}                                 ║
║      searchable_array_bag(const searchable_array_bag& o) : array_bag(o) {}   ║
║      searchable_array_bag& operator=(const searchable_array_bag& o) {        ║
║          if (this != &o) array_bag::operator=(o);                            ║
║          return *this;                                                       ║
║      }                                                                       ║
║      virtual ~searchable_array_bag() {}                                      ║
║                                                                              ║
║      // ⭐ DAS IST DER WICHTIGE TEIL: ⭐                                     ║
║      virtual bool has(int value) const {                                     ║
║          for (int i = 0; i < size; i++) {  // size von array_bag ✅         ║
║              if (data[i] == value)         // data von array_bag ✅         ║
║                  return true;                                                ║
║          }                                                                   ║
║          return false;                                                       ║
║      }                                                                       ║
║  };                                                                          ║
║  #endif                                                                      ║
║                                                                              ║
║  searchable_array_bag.cpp → #include "searchable_array_bag.hpp"             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  KLASSE 2: searchable_tree_bag                         ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  File: searchable_tree_bag.hpp  (DU ERSTELLST DAS!)                         ║
║                                                                              ║
║  ┌─ GEGEBEN: ──────────────────┐        ┌─ DU SCHREIBST: ────────────────┐ ║
║  │ tree_bag                    │        │ searchable_tree_bag            │ ║
║  │ ─────────────────────       │        │ ───────────────────────        │ ║
║  │ + insert()   ✅             │   ┌───→│ + insert()   (geerbt)          │ ║
║  │ + print()    ✅             │   │    │ + print()    (geerbt)          │ ║
║  │ + clear()    ✅             │   │    │ + clear()    (geerbt)          │ ║
║  │ + node* tree                │   │    │ + tree       (geerbt)          │ ║
║  └─────────────────────────────┘   │    │                                │ ║
║                                     │    │ + has()      ← NEU! 🎯        │ ║
║  ┌─ INTERFACE: ────────────────┐   │    │   (mit BST-Suche)              │ ║
║  │ searchable_bag              │   │    └────────────────────────────────┘ ║
║  │ ─────────────────────       │   │                                        ║
║  │ + has() = pure virtual  ❌  │───┘    Multiple Inheritance:               ║
║  └─────────────────────────────┘        : public tree_bag,                  ║
║                                            public searchable_bag             ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  #ifndef SEARCHABLE_TREE_BAG_HPP                                             ║
║  #define SEARCHABLE_TREE_BAG_HPP                                             ║
║  #include "tree_bag.hpp"           ← GEGEBEN                                ║
║  #include "searchable_bag.hpp"     ← GEGEBEN                                ║
║                                                                              ║
║  class searchable_tree_bag                                                   ║
║      : public tree_bag,            ← Erbt insert/print/clear                ║
║        public searchable_bag {     ← Muss has() implementieren              ║
║  public:                                                                     ║
║      searchable_tree_bag() : tree_bag() {}                                   ║
║      searchable_tree_bag(const searchable_tree_bag& o) : tree_bag(o) {}      ║
║      searchable_tree_bag& operator=(const searchable_tree_bag& o) {          ║
║          if (this != &o) tree_bag::operator=(o);                             ║
║          return *this;                                                       ║
║      }                                                                       ║
║      virtual ~searchable_tree_bag() {}                                       ║
║                                                                              ║
║      // ⭐ DAS IST DER WICHTIGE TEIL: ⭐                                     ║
║      virtual bool has(int value) const {                                     ║
║          return search_in_tree(tree, value);  // tree von tree_bag ✅       ║
║      }                                                                       ║
║                                                                              ║
║  private:                                                                    ║
║      // Hilfsfunktion: Rekursive BST-Suche                                  ║
║      static bool search_in_tree(node* n, int value) {                        ║
║          if (n == NULL) return false;                                        ║
║          if (n->value == value) return true;                                 ║
║          if (value < n->value)                                               ║
║              return search_in_tree(n->l, value);  // Links                  ║
║          else                                                                ║
║              return search_in_tree(n->r, value);  // Rechts                 ║
║      }                                                                       ║
║  };                                                                          ║
║  #endif                                                                      ║
║                                                                              ║
║  searchable_tree_bag.cpp → #include "searchable_tree_bag.hpp"               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  KLASSE 3: set (Wrapper)                               ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  File: set.hpp  (DU ERSTELLST DAS!)                                         ║
║                                                                              ║
║  ┌─ DU HAST JETZT: ────────────────────┐                                    ║
║  │ searchable_array_bag                │ ← Hat insert + has()               ║
║  │ searchable_tree_bag                 │ ← Hat insert + has()               ║
║  └─────────────────────────────────────┘                                    ║
║                                                                              ║
║  Problem: bag erlaubt Duplikate!                                            ║
║           bag.insert(5); bag.insert(5); → [5, 5]  ❌                        ║
║                                                                              ║
║  Lösung: Wrapper-Klasse "set"                                               ║
║           set.insert(5); set.insert(5); → [5]  ✅                           ║
║                                                                              ║
║  ┌─ DU SCHREIBST: ─────────────────────┐                                    ║
║  │ set                                 │                                    ║
║  │ ──────────────────────────          │                                    ║
║  │ - searchable_bag* bag  (pointer)    │ ← Zeigt auf array oder tree       ║
║  │                                     │                                    ║
║  │ + insert(int)    ← Prüft has()!     │                                    ║
║  │ + insert(int*, int)                 │                                    ║
║  │ + has(int)       ← Weiterleiten     │                                    ║
║  │ + print()        ← Weiterleiten     │                                    ║
║  │ + clear()        ← Weiterleiten     │                                    ║
║  └─────────────────────────────────────┘                                    ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  #ifndef SET_HPP                                                             ║
║  #define SET_HPP                                                             ║
║  #include "searchable_bag.hpp"     ← GEGEBEN                                ║
║                                                                              ║
║  class set {                                                                 ║
║  private:                                                                    ║
║      searchable_bag* bag;  // Pointer! (array oder tree)                    ║
║                                                                              ║
║  public:                                                                     ║
║      // Constructor: Nimmt ownership vom bag                                ║
║      set(searchable_bag* b) : bag(b) {}                                      ║
║                                                                              ║
║      ~set() { delete bag; }                                                  ║
║                                                                              ║
║      set(const set& other) : bag(NULL) {}  // Meist nicht getestet          ║
║                                                                              ║
║      set& operator=(const set& other) {                                      ║
║          if (this != &other) {                                               ║
║              delete bag;                                                     ║
║              bag = NULL;                                                     ║
║          }                                                                   ║
║          return *this;                                                       ║
║      }                                                                       ║
║                                                                              ║
║      // ⭐ DAS IST DER WICHTIGE TEIL: ⭐                                     ║
║      void insert(int value) {                                                ║
║          if (!bag->has(value))  // 🎯 Prüfe ZUERST ob vorhanden!           ║
║              bag->insert(value); // Nur einfügen wenn NEU                   ║
║      }                                                                       ║
║                                                                              ║
║      void insert(int* array, int size) {                                     ║
║          for (int i = 0; i < size; i++)                                      ║
║              insert(array[i]);  // Nutzt insert(int) → prüft has()          ║
║      }                                                                       ║
║                                                                              ║
║      // Rest: Einfach weiterleiten an bag                                   ║
║      bool has(int value) const { return bag->has(value); }                   ║
║      void print() const { bag->print(); }                                    ║
║      void clear() { bag->clear(); }                                          ║
║  };                                                                          ║
║  #endif                                                                      ║
║                                                                              ║
║  set.cpp → #include "set.hpp"                                               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                       📊 ZUSAMMENFASSUNG: Die 3 Klassen                      ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ┌──────────────────────────────────────────────────────────────────────┐   ║
║  │ GEGEBEN (NICHT ANFASSEN):                                            │   ║
║  ├──────────────────────────────────────────────────────────────────────┤   ║
║  │ ✅ array_bag       → insert, print, clear (mit Array)               │   ║
║  │ ✅ tree_bag        → insert, print, clear (mit BST)                 │   ║
║  │ ✅ searchable_bag  → Interface: has() = 0 (pure virtual)            │   ║
║  └──────────────────────────────────────────────────────────────────────┘   ║
║                                                                              ║
║  ┌──────────────────────────────────────────────────────────────────────┐   ║
║  │ DU SCHREIBST (3 NEUE FILES):                                         │   ║
║  ├──────────────────────────────────────────────────────────────────────┤   ║
║  │                                                                       │   ║
║  │ 1️⃣  searchable_array_bag                                             │   ║
║  │     ═══════════════════════                                          │   ║
║  │     : public array_bag, public searchable_bag                        │   ║
║  │                                                                       │   ║
║  │     Erbt von array_bag:        insert(), print(), clear(), data[]    │   ║
║  │     Implementiert von s_bag:   has() → linear search im Array        │   ║
║  │                                                                       │   ║
║  │ ─────────────────────────────────────────────────────────────────── │   ║
║  │                                                                       │   ║
║  │ 2️⃣  searchable_tree_bag                                              │   ║
║  │     ═══════════════════════                                          │   ║
║  │     : public tree_bag, public searchable_bag                         │   ║
║  │                                                                       │   ║
║  │     Erbt von tree_bag:         insert(), print(), clear(), tree      │   ║
║  │     Implementiert von s_bag:   has() → BST search im Tree            │   ║
║  │                                                                       │   ║
║  │ ─────────────────────────────────────────────────────────────────── │   ║
║  │                                                                       │   ║
║  │ 3️⃣  set                                                              │   ║
║  │     ═══════════════════════                                          │   ║
║  │     Wrapper um searchable_bag* (kann array ODER tree sein)           │   ║
║  │                                                                       │   ║
║  │     Speichert:  searchable_bag* bag                                  │   ║
║  │     insert():   if (!bag->has(value)) bag->insert(value);  🎯       │   ║
║  │     Rest:       Leitet an bag weiter (print, clear, has)            │   ║
║  │                                                                       │   ║
║  └──────────────────────────────────────────────────────────────────────┘   ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                       🎯 EXAM CHEAT SHEET                                    ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Pattern: Multiple Inheritance + Eine Funktion                              ║
║                                                                              ║
║  ┌─ Klasse 1 & 2: ──────────────────────────────────────────────────────┐  ║
║  │                                                                        │  ║
║  │  class searchable_XXX_bag                                             │  ║
║  │      : public XXX_bag,            ← Erbt insert/print/clear          │  ║
║  │        public searchable_bag {    ← Muss has() implementieren        │  ║
║  │  public:                                                              │  ║
║  │      // OCF (4 Zeilen)                                                │  ║
║  │      searchable_XXX_bag() : XXX_bag() {}                              │  ║
║  │      searchable_XXX_bag(const searchable_XXX_bag& o) : XXX_bag(o) {}  │  ║
║  │      searchable_XXX_bag& operator=(const searchable_XXX_bag& o) {     │  ║
║  │          if (this != &o) XXX_bag::operator=(o);                       │  ║
║  │          return *this;                                                │  ║
║  │      }                                                                │  ║
║  │      virtual ~searchable_XXX_bag() {}                                 │  ║
║  │                                                                        │  ║
║  │      // Die EINE wichtige Funktion:                                   │  ║
║  │      virtual bool has(int value) const {                              │  ║
║  │          // array: for-loop durch data[]                             │  ║
║  │          // tree:  rekursive BST-Suche                               │  ║
║  │      }                                                                │  ║
║  │  };                                                                   │  ║
║  │                                                                        │  ║
║  └────────────────────────────────────────────────────────────────────────┘  ║
║                                                                              ║
║  ┌─ Klasse 3: ────────────────────────────────────────────────────────────┐ ║
║  │                                                                        │ ║
║  │  class set {                                                          │ ║
║  │      searchable_bag* bag;                                             │ ║
║  │  public:                                                              │ ║
║  │      set(searchable_bag* b) : bag(b) {}                               │ ║
║  │      ~set() { delete bag; }                                           │ ║
║  │      set(const set& o) : bag(NULL) {}                                 │ ║
║  │      set& operator=(const set& o) {                                   │ ║
║  │          if (this != &o) { delete bag; bag = NULL; }                  │ ║
║  │          return *this;                                                │ ║
║  │      }                                                                │ ║
║  │                                                                        │ ║
║  │      // Die EINE wichtige Funktion:                                   │ ║
║  │      void insert(int value) {                                         │ ║
║  │          if (!bag->has(value))  // 🎯 Prüfe Duplikat!                │ ║
║  │              bag->insert(value);                                      │ ║
║  │      }                                                                │ ║
║  │                                                                        │ ║
║  │      // Rest: Weiterleiten                                            │ ║
║  │      void insert(int* a, int s) { for(int i=0; i<s; i++) insert(a[i]); }│ ║
║  │      bool has(int v) const { return bag->has(v); }                    │ ║
║  │      void print() const { bag->print(); }                             │ ║
║  │      void clear() { bag->clear(); }                                   │ ║
║  │  };                                                                   │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                       ⏱️  EXAM ZEITPLAN                                      ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Gesamt: ~20 Minuten                                                         ║
║                                                                              ║
║  1. Les main.cpp                         (1 min)                            ║
║     → Sieh wie set benutzt wird                                             ║
║     → Pointer oder Reference?                                               ║
║                                                                              ║
║  2. searchable_array_bag.hpp             (5 min)                            ║
║     → Multiple inheritance                                                  ║
║     → OCF (copy paste Pattern)                                              ║
║     → has() mit for-loop                                                    ║
║                                                                              ║
║  3. searchable_tree_bag.hpp              (7 min)                            ║
║     → Multiple inheritance                                                  ║
║     → OCF (copy paste)                                                      ║
║     → has() mit rekursiver Hilfsfunktion                                    ║
║                                                                              ║
║  4. set.hpp                              (5 min)                            ║
║     → Pointer member                                                        ║
║     → OCF                                                                   ║
║     → insert() mit has()-Prüfung                                            ║
║     → Rest weiterleiten                                                     ║
║                                                                              ║
║  5. Compile + Test                       (2 min)                            ║
║     → c++ *.cpp -o test                                                     ║
║     → ./test                                                                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
║                              ZUSAMMENFASSUNG                                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  SKELETON hat:         70% (bag, array_bag, tree_bag komplett)              ║
║  DU musst schreiben:   30% (3 kleine Wrapper-Klassen)                       ║
║                                                                              ║
║  KERNLOGIK:                                                                  ║
║    searchable_array_bag → lineares Suchen (for-Loop)                       ║
║    searchable_tree_bag  → BST Suche (rekursiv)                             ║
║    set                  → if (!has()) insert()                              ║
║                                                                              ║
║  TRICK: Du schreibst fast NIX außer Vererbung + Weiterleitung!             ║
║                                                                              ║
║  ⏱️  Zeit: ~10 Minuten                                                       ║
╚══════════════════════════════════════════════════════════════════════════════╝
*/
