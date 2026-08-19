#include "bigint.hpp"

static unsigned long long toN(const std::string& s) {
	unsigned long long r = 0;
	for (size_t i = 0; i < s.size(); i++) r = r * 10 + (s[i] - '0');
	return r;
}
static std::string toS(unsigned long long n) {
	if (n == 0) return "0";
	std::string r;
	while (n) { r = char('0' + n % 10) + r; n /= 10; }
	return r;
}
static unsigned long long p10(unsigned int p) {
	unsigned long long r = 1;
	while (p--) r *= 10;
	return r;
}

bigint::bigint() : str("0") {}
bigint::bigint(unsigned int n) : str(toS(n)) {}
bigint::bigint(const bigint& o) : str(o.str) {}
bigint& bigint::operator=(const bigint& o) { str = o.str; return *this; }

std::string bigint::getStr() const { return str; }

bigint bigint::operator+(const bigint& o) const { bigint r; r.str = toS(toN(str) + toN(o.str)); return r; }
bigint& bigint::operator+=(const bigint& o) { str = toS(toN(str) + toN(o.str)); return *this; }
bigint& bigint::operator++() { str = toS(toN(str) + 1); return *this; }
bigint bigint::operator++(int) { bigint t(*this); ++(*this); return t; }

bigint bigint::operator<<(unsigned int n) const { bigint r; r.str = toS(toN(str) * p10(n)); return r; }
bigint bigint::operator>>(unsigned int n) const { bigint r; r.str = toS(toN(str) / p10(n)); return r; }
bigint& bigint::operator<<=(unsigned int n) { str = toS(toN(str) * p10(n)); return *this; }
bigint& bigint::operator>>=(unsigned int n) { str = toS(toN(str) / p10(n)); return *this; }

bigint bigint::operator<<(const bigint& o) const { return *this << (unsigned int)toN(o.str); }
bigint bigint::operator>>(const bigint& o) const { return *this >> (unsigned int)toN(o.str); }
bigint& bigint::operator<<=(const bigint& o) { return *this <<= (unsigned int)toN(o.str); }
bigint& bigint::operator>>=(const bigint& o) { return *this >>= (unsigned int)toN(o.str); }

bool bigint::operator==(const bigint& o) const { return toN(str) == toN(o.str); }
bool bigint::operator!=(const bigint& o) const { return toN(str) != toN(o.str); }
bool bigint::operator<(const bigint& o) const { return toN(str) < toN(o.str); }
bool bigint::operator>(const bigint& o) const { return toN(str) > toN(o.str); }
bool bigint::operator<=(const bigint& o) const { return toN(str) <= toN(o.str); }
bool bigint::operator>=(const bigint& o) const { return toN(str) >= toN(o.str); }

std::ostream& operator<<(std::ostream& os, const bigint& o) { return os << o.getStr(); }
