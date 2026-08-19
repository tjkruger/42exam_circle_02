/* ************************************************************************** */
/*           VECT2 - ULTRA MINIMAL (basierend auf MAIN Analysis)              */
/* ************************************************************************** */

/*
   MAIN TESTET:
   ✓ vect2() - Default constructor
   ✓ vect2(int, int) - Constructor
   ✓ vect2(const vect2&) - Copy constructor
   ✓ operator= - Assignment
   ✓ operator<< - Stream output
   ✓ operator[] - Array access (const + non-const)
   ✓ operator++/-- - Pre/Post Increment/Decrement
   ✓ operator+=/-=/+/-/*= - Arithmetic
   ✓ operator* - Scalar multiplication (v * int UND int * v!)
   ✓ operator- - Negation
   ✓ operator==/!= - Comparison
*/

#ifndef VECT2_HPP
#define VECT2_HPP
#include <iostream>

class vect2 {
	int x, y;
public:
	vect2() : x(0), y(0) {}
	vect2(int a, int b) : x(a), y(b) {}
	vect2(const vect2& v) : x(v.x), y(v.y) {}
	vect2& operator=(const vect2& v) { x = v.x; y = v.y; return *this; }
	~vect2() {}
	
	int operator[](int i) const { return i == 0 ? x : y; }
	int& operator[](int i) { return i == 0 ? x : y; }
	
	vect2 operator+(const vect2& v) const { return vect2(x + v.x, y + v.y); }
	vect2 operator-(const vect2& v) const { return vect2(x - v.x, y - v.y); }
	vect2 operator*(int n) const { return vect2(x * n, y * n); }
	vect2 operator-() const { return vect2(-x, -y); }
	
	vect2& operator+=(const vect2& v) { x += v.x; y += v.y; return *this; }
	vect2& operator-=(const vect2& v) { x -= v.x; y -= v.y; return *this; }
	vect2& operator*=(int n) { x *= n; y *= n; return *this; }
	
	vect2& operator++() { x++; y++; return *this; }
	vect2 operator++(int) { vect2 t(*this); ++(*this); return t; }
	vect2& operator--() { x--; y--; return *this; }
	vect2 operator--(int) { vect2 t(*this); --(*this); return t; }
	
	bool operator==(const vect2& v) const { return x == v.x && y == v.y; }
	bool operator!=(const vect2& v) const { return !(*this == v); }
};

vect2 operator*(int n, const vect2& v) { return v * n; }
std::ostream& operator<<(std::ostream& os, const vect2& v) {
	return os << "{" << v[0] << ", " << v[1] << "}";
}
#endif
