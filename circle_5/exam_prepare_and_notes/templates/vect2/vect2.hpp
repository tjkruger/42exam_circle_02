#ifndef VECT2_HPP
#define VECT2_HPP
#include <iostream>

class vect2 {
private:
    int x, y;
public:
    // Orthodox Canonical Form
    vect2() : x(0), y(0) {}
    vect2(int a, int b) : x(a), y(b) {}
    vect2(const vect2& v) : x(v.x), y(v.y) {}
    vect2& operator=(const vect2& v) { x = v.x; y = v.y; return *this; }
    
    // Array access
    int& operator[](int i) { return i == 0 ? x : y; }
    int operator[](int i) const { return i == 0 ? x : y; }
    
    // Arithmetic operators
    vect2 operator+(const vect2& v) const { return vect2(x + v.x, y + v.y); }
    vect2 operator-(const vect2& v) const { return vect2(x - v.x, y - v.y); }
    vect2 operator*(int n) const { return vect2(x * n, y * n); }
    vect2 operator-() const { return vect2(-x, -y); }
    
    // Compound assignment
    vect2& operator+=(const vect2& v) { x += v.x; y += v.y; return *this; }
    vect2& operator-=(const vect2& v) { x -= v.x; y -= v.y; return *this; }
    vect2& operator*=(int n) { x *= n; y *= n; return *this; }
    
    // Increment/Decrement
    vect2& operator++() { x++; y++; return *this; }
    vect2 operator++(int) { vect2 tmp(*this); x++; y++; return tmp; }
    vect2& operator--() { x--; y--; return *this; }
    vect2 operator--(int) { vect2 tmp(*this); x--; y--; return tmp; }
    
    // Comparison
    bool operator==(const vect2& v) const { return x == v.x && y == v.y; }
    bool operator!=(const vect2& v) const { return !(*this == v); }
};

// Non-member operator for (int * vect2)
vect2 operator*(int n, const vect2& v) { return v * n; }

// Stream output
std::ostream& operator<<(std::ostream& os, const vect2& v) {
    return os << "{" << v[0] << ", " << v[1] << "}";
}

#endif
