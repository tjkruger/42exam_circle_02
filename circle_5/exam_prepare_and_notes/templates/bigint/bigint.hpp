#ifndef BIGINT_HPP
#define BIGINT_HPP
#include <string>
#include <iostream>

class bigint {
private:
    std::string num;
public:
    bigint();
    bigint(unsigned int n);
    bigint(const bigint& b);
    bigint& operator=(const bigint& b);
    
    bigint operator+(const bigint& b) const;
    bigint& operator+=(const bigint& b);
    bigint& operator++();
    bigint operator++(int);
    
    bigint operator<<(const bigint& shift) const;
    bigint& operator<<=(const bigint& shift);
    bigint operator>>(const bigint& shift) const;
    bigint& operator>>=(const bigint& shift);
    
    bool operator<(const bigint& b) const;
    bool operator<=(const bigint& b) const;
    bool operator>(const bigint& b) const;
    bool operator>=(const bigint& b) const;
    bool operator==(const bigint& b) const;
    bool operator!=(const bigint& b) const;
    
    friend std::ostream& operator<<(std::ostream& os, const bigint& b);
};

#endif
