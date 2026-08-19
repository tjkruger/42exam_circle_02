#include "searchable_tree_bag.hpp"
#include <cstddef>


searchable_tree_bag::searchable_tree_bag() : tree_bag()
{

}

searchable_tree_bag::searchable_tree_bag(const searchable_tree_bag& source) : tree_bag(source)
{

}

searchable_tree_bag& searchable_tree_bag::operator=(const searchable_tree_bag& source)
{
    if(this != &source)
    {
        tree_bag::operator=(source);
    }
    return(*this);
}

bool searchable_tree_bag::search(node* n, const int value) const  // ← Changed 'node' to 'n'
{
    if(n == NULL)  // ← Changed nullptr to NULL
        return(false);
    if(n->value == value)
        return(true);
    if(value < n->value)
        return(search(n->l, value));
    return(search(n->r, value));
}

bool searchable_tree_bag::has(int value) const
{
    return(search(tree, value));
}

searchable_tree_bag::~searchable_tree_bag()
{

}
