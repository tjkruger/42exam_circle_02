/* ************************************************************************** */
/*                        SET - ULTRA MINIMAL                                  */
/* ************************************************************************** */

/*
   MAIN TESTET:
   ✓ set(searchable_bag&) - Constructor mit Reference!
   ✓ get_bag() - Gibt Referenz zurück
   ✓ insert(int), insert(int*, int)
   ✓ has(), print(), clear()
*/

#ifndef SET_HPP
#define SET_HPP
#include "searchable_bag.hpp"

class set {
	searchable_bag& bag;
public:
	set(searchable_bag& b) : bag(b) {}
	~set() {}
	
	void insert(int v) { if (!bag.has(v)) bag.insert(v); }
	void insert(int* arr, int sz) { for (int i = 0; i < sz; i++) insert(arr[i]); }
	bool has(int v) const { return bag.has(v); }
	void print() const { bag.print(); }
	void clear() { bag.clear(); }
	searchable_bag& get_bag() { return bag; }
};
#endif
