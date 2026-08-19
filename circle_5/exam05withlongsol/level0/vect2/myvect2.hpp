#ifndef MYVECT2_HPP
# define MYVECT2_HPP

#include <iostream>

class vect2
{
    public:
        vect2(int _x = 0, int _y = 0): x(_x), y(_y) {}

        int& operator[](int i) { return i == 0 ? x : y;}
        int operator[](int i) const {return i == 0 ? x : y;}

        vect2& operator+=(const vect2& o) {x += o.x; y += o.y; return *this;}
        vect2& operator-=(const vect2& o) {x -= o.x; y -= o.y; return *this;}
        vect2& operator*=(int s) {x *= s; y *= s; return *this;}

        vect2 operator+(const vect2& o)const {return vect2(*this) += o;}
        vect2 operator-(const vect2& o)const {return vect2(*this) -= o;}
        vect2 operator*(int s)const {return vect2(*this) *= s;}
        vect2 operator-()const {return vect2(-x, -y);}

        vect2& operator++() {++x; ++y; return *this;}
        vect2 operator++(int) {vect2 tmp(*this); ++(*this); return tmp;}
        vect2& operator--() { --x; --y; return *this;}
        vect2 operator--(int) {vect2 tmp(*this); --(*this); return tmp;}

        bool operator==(const vect2& o) const {return x == o.x && y == o.y;}
        bool operator!=(const vect2& o) const {return!(*this == o);}

    private:
        int x;
        int y;

};


vect2 operator*(int s, const vect2& v);
std::ostream& operator <<(std::ostream& os, const vect2& v);

#endif
