#ifndef BIGINT_HPP
#define BIGINT_HPP
#include <iostream>

class bigint {
private:
	unsigned long long n;
	unsigned long long pow10(unsigned int p) const {
		unsigned long long r = 1;
		while (p--) r *= 10;
		return r;
	}
public:
	bigint() : n(0) {}
	bigint(unsigned long long x) : n(x) {}
	bigint(const bigint& o) : n(o.n) {}
	bigint& operator=(const bigint& o) { n = o.n; return *this; }
	~bigint() {}

	unsigned long long val() const { return n; }

	bigint operator+(const bigint& o) const { return bigint(n + o.n); }
	bigint& operator+=(const bigint& o) { n += o.n; return *this; }
	bigint& operator++() { n++; return *this; }
	bigint operator++(int) { bigint t(*this); ++(*this); return t; }

	bigint operator<<(unsigned int p) const { return bigint(n * pow10(p)); }
	bigint operator>>(unsigned int p) const { return bigint(n / pow10(p)); }
	bigint& operator<<=(unsigned int p) { n *= pow10(p); return *this; }
	bigint& operator>>=(unsigned int p) { n /= pow10(p); return *this; }

	bigint operator<<(const bigint& o) const { return *this << (unsigned int)o.n; }
	bigint operator>>(const bigint& o) const { return *this >> (unsigned int)o.n; }
	bigint& operator<<=(const bigint& o) { return *this <<= (unsigned int)o.n; }
	bigint& operator>>=(const bigint& o) { return *this >>= (unsigned int)o.n; }

	bool operator==(const bigint& o) const { return n == o.n; }
	bool operator!=(const bigint& o) const { return n != o.n; }
	bool operator<(const bigint& o) const { return n < o.n; }
	bool operator>(const bigint& o) const { return n > o.n; }
	bool operator<=(const bigint& o) const { return n <= o.n; }
	bool operator>=(const bigint& o) const { return n >= o.n; }
};

std::ostream& operator<<(std::ostream& os, const bigint& o) { return os << o.val(); }

#endif
