#ifndef SEARCHABLE_TREE_BAG_HPP
#define SEARCHABLE_TREE_BAG_HPP

#include "tree_bag.hpp"
#include "searchable_bag.hpp"

// Kombiniert tree_bag mit searchable_bag
class searchable_tree_bag : public tree_bag, public searchable_bag {
public:
    searchable_tree_bag() : tree_bag() {}
    
    searchable_tree_bag(const searchable_tree_bag& other) : tree_bag(other) {}
    
    searchable_tree_bag& operator=(const searchable_tree_bag& other) {
        if (this != &other)
            tree_bag::operator=(other);
        return *this;
    }
    
    virtual ~searchable_tree_bag() {}
    
    // Implementierung von searchable_bag::has()
    // Durchsucht den Binary Search Tree
    virtual bool has(int value) const {
        return search_in_tree(tree, value);
    }
    
private:
    // Hilfsfunktion: Rekursive Suche im BST
    static bool search_in_tree(node* n, int value) {
        if (n == NULL)
            return false;
        if (n->value == value)
            return true;
        if (value < n->value)
            return search_in_tree(n->l, value);
        else
            return search_in_tree(n->r, value);
    }
};

#endif
