#pragma once
#include <iostream>
#include <sstream>

class bigint {
    unsigned long long v;
public:
    bigint() : v(0) {}
    bigint(unsigned int n) : v(n) {}
    bigint(const bigint& o) : v(o.v) {}
    bigint& operator=(const bigint& o) { v = o.v; return *this; }
    std::string getStr() const { std::ostringstream ss; ss << v; return ss.str(); }

    bigint operator+(const bigint& o) const { return bigint(v + o.v); }
    bigint& operator+=(const bigint& o) { v += o.v; return *this; }
    bigint& operator++() { ++v; return *this; }
    bigint operator++(int) { bigint t(*this); ++v; return t; }
    bigint operator<<(unsigned int n) const { unsigned long long r = v; for(unsigned int i=0;i<n;++i) r *= 10; return bigint(r); }
    bigint operator>>(unsigned int n) const { unsigned long long r = v; for(unsigned int i=0;i<n;++i) r /= 10; return bigint(r); }
    bigint& operator<<=(unsigned int n) { for(unsigned int i=0;i<n;++i) v *= 10; return *this; }
    bigint& operator>>=(unsigned int n) { for(unsigned int i=0;i<n;++i) v /= 10; return *this; }
    bigint operator<<(const bigint& o) const { return *this << static_cast<unsigned int>(o.v); }
    bigint operator>>(const bigint& o) const { return *this >> static_cast<unsigned int>(o.v); }
    bigint& operator<<=(const bigint& o) { return *this <<= static_cast<unsigned int>(o.v); }
    bigint& operator>>=(const bigint& o) { return *this >>= static_cast<unsigned int>(o.v); }
    bool operator==(const bigint& o) const { return v == o.v; }
    bool operator!=(const bigint& o) const { return v != o.v; }
    bool operator<(const bigint& o) const { return v < o.v; }
    bool operator>(const bigint& o) const { return v > o.v; }
    bool operator<=(const bigint& o) const { return v <= o.v; }
    bool operator>=(const bigint& o) const { return v >= o.v; }
};

inline std::ostream& operator<<(std::ostream& os, const bigint& b) { return os << b.getStr(); }