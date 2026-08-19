

#include "myvect2.hpp"

vect2 operator*(int s, const vect2& v)
{
    return(v * s);
}

std::ostream& operator<<(std::ostream os, const vect2& v)
{
    return os << "{" << v[0] << ", " << v[1] << "}";
}