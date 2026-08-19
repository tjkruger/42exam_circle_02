/* ************************************************************************** */
/*        POLYSET - ULTRA MINIMAL (basierend auf MAIN Analysis)               */
/* ************************************************************************** */

/*
   MAIN TESTET:
   ✓ searchable_tree_bag - Erbt von tree_bag + searchable_bag
   ✓ searchable_array_bag - Erbt von array_bag + searchable_bag
   ✓ has() - Suche im bag
   ✓ insert(), print(), clear() - Von bag geerbt
   ✓ set - Wrapper mit get_bag()
   ✓ Orthodox Canonical Form (Copy Constructor wird getestet!)
*/

#ifndef SEARCHABLE_ARRAY_BAG_HPP
#define SEARCHABLE_ARRAY_BAG_HPP
#include "array_bag.hpp"
#include "searchable_bag.hpp"

class searchable_array_bag : public array_bag, public searchable_bag {
public:
	searchable_array_bag() : array_bag() {}
	searchable_array_bag(const searchable_array_bag& o) : array_bag(o) {}
	searchable_array_bag& operator=(const searchable_array_bag& o) {
		if (this != &o) array_bag::operator=(o);
		return *this;
	}
	virtual ~searchable_array_bag() {}
	
	virtual bool has(int v) const {
		for (int i = 0; i < size; i++)
			if (data[i] == v) return true;
		return false;
	}
};
#endif
