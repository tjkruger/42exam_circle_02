#ifndef SET_HPP
#define SET_HPP

#include "searchable_bag.hpp"

// Set = Bag ohne Duplikate
// Wrapper um searchable_bag der vor insert() prüft ob Element schon existiert
class set {
private:
    searchable_bag* bag;
    
public:
    // Constructor: Nimmt einen Pointer auf searchable_bag
    set(searchable_bag* b) : bag(b) {}
    
    // Destructor: Gibt bag frei
    ~set() {
        delete bag;
    }
    
    // Copy constructor
    set(const set& other) : bag(NULL) {
        // Deep copy wäre komplex, für Exam meist nicht nötig
        // Falls doch: bag = new searchable_array_bag(*dynamic_cast<searchable_array_bag*>(other.bag));
    }
    
    // Assignment operator
    set& operator=(const set& other) {
        if (this != &other) {
            delete bag;
            bag = NULL; // Simplified
        }
        return *this;
    }
    
    // Fügt Element nur hinzu wenn es noch nicht existiert
    void insert(int value) {
        if (!bag->has(value))
            bag->insert(value);
    }
    
    // Bulk insert
    void insert(int* array, int size) {
        for (int i = 0; i < size; i++)
            insert(array[i]);
    }
    
    // Prüft ob Element im Set ist
    bool has(int value) const {
        return bag->has(value);
    }
    
    // Print
    void print() const {
        bag->print();
    }
    
    // Clear
    void clear() {
        bag->clear();
    }
};

#endif
