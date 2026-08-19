/* ************************************************************************** */
/*                    SEARCHABLE_TREE_BAG - ULTRA MINIMAL                     */
/* ************************************************************************** */

#ifndef SEARCHABLE_TREE_BAG_HPP
#define SEARCHABLE_TREE_BAG_HPP
#include "tree_bag.hpp"
#include "searchable_bag.hpp"

class searchable_tree_bag : public tree_bag, public searchable_bag {
public:
	searchable_tree_bag() : tree_bag() {}
	searchable_tree_bag(const searchable_tree_bag& o) : tree_bag(o) {}
	searchable_tree_bag& operator=(const searchable_tree_bag& o) {
		if (this != &o) tree_bag::operator=(o);
		return *this;
	}
	virtual ~searchable_tree_bag() {}
	
	virtual bool has(int v) const { return search(tree, v); }
	
private:
	static bool search(node* n, int v) {
		if (!n) return false;
		if (n->value == v) return true;
		return v < n->value ? search(n->l, v) : search(n->r, v);
	}
};
#endif
