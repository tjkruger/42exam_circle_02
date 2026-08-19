#include "bigint.hpp"
#include <sstream>
#include <algorithm>

bigint::bigint() : num("0") {}

bigint::bigint(unsigned int n) {
    std::stringstream ss;
    ss << n;
    num = ss.str();
}

bigint::bigint(const bigint& b) : num(b.num) {}

bigint& bigint::operator=(const bigint& b) {
    if (this != &b)
        num = b.num;
    return *this;
}


bigint bigint::operator+(const bigint& b) const {
    std::string s1 = num;
    std::string s2 = b.num;
    

    std::reverse(s1.begin(), s1.end());
    std::reverse(s2.begin(), s2.end());
    
    std::string result;
    int carry = 0;
    size_t maxLen = std::max(s1.size(), s2.size());
    
    for (size_t i = 0; i < maxLen || carry; i++) {
        int d1 = i < s1.size() ? s1[i] - '0' : 0;
        int d2 = i < s2.size() ? s2[i] - '0' : 0;
        int sum = d1 + d2 + carry;
        result += (sum % 10) + '0';
        carry = sum / 10;
    }
    
    std::reverse(result.begin(), result.end());
    

    size_t pos = result.find_first_not_of('0');
    if (pos != std::string::npos)
        result = result.substr(pos);
    else
        result = "0";
    
    bigint r;
    r.num = result;
    return r;
}

bigint& bigint::operator+=(const bigint& b) {
    *this = *this + b;
    return *this;
}

bigint& bigint::operator++() {
    *this += bigint(1);
    return *this;
}

bigint bigint::operator++(int) {
    bigint tmp(*this);
    ++(*this);
    return tmp;
}


bigint bigint::operator<<(const bigint& shift) const {
    bigint result(*this);
    std::stringstream ss(shift.num);
    int n;
    ss >> n;
    
    if (result.num == "0")
        return result;
    
    for (int i = 0; i < n; i++)
        result.num += '0';
    return result;
}

bigint& bigint::operator<<=(const bigint& shift) {
    *this = *this << shift;
    return *this;
}


bigint bigint::operator>>(const bigint& shift) const {
    bigint result(*this);
    std::stringstream ss(shift.num);
    int n;
    ss >> n;
    
    if (n >= (int)result.num.size()) {
        result.num = "0";
        return result;
    }
    
    result.num = result.num.substr(0, result.num.size() - n);
    
    if (result.num.empty() || result.num.find_first_not_of('0') == std::string::npos)
        result.num = "0";
    
    return result;
}

bigint& bigint::operator>>=(const bigint& shift) {
    *this = *this >> shift;
    return *this;
}


bool bigint::operator==(const bigint& b) const {
    return num == b.num;
}

bool bigint::operator!=(const bigint& b) const {
    return !(*this == b);
}

bool bigint::operator<(const bigint& b) const {
    if (num.size() != b.num.size())
        return num.size() < b.num.size();
    return num < b.num;
}

bool bigint::operator<=(const bigint& b) const {
    return *this < b || *this == b;
}

bool bigint::operator>(const bigint& b) const {
    return !(*this <= b);
}

bool bigint::operator>=(const bigint& b) const {
    return !(*this < b);
}

std::ostream& operator<<(std::ostream& os, const bigint& b) {
    return os << b.num;
}
