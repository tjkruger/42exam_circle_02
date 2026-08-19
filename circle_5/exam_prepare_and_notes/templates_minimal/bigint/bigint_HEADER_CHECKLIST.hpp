/* ************************************************************************** */
/*                    BIGINT - WAS FEHLT IM SKELETON                          */
/* ************************************************************************** */

/*
   IM EXAM SKELETON MEIST GEGEBEN:
   - Klassen-Struktur
   - Private: std::string str
   - Basis Constructors
   - getStr()
   
   WAS DU ERGÄNZEN MUSST:
   - Addition Logic
   - Shift Logic (<<, >>)
   - Comparison Logic
*/

#ifndef BIGINT
#define BIGINT

#include <sstream>
#include <iostream>
#include <string>
#include <cstdlib>

class bigint
{
	private:
		std::string str;
	
	public:
		bigint();
		bigint(unsigned int num);
		bigint(const bigint& source);
		
		std::string getStr() const;
		bigint& operator=(const bigint& source);
		
		// ===== ADDITION - MUSST DU IMPLEMENTIEREN =====
		bigint operator+(const bigint& other) const;
		bigint& operator+=(const bigint& other);
		bigint& operator++();
		bigint operator++(int);
		
		// ===== SHIFT - MUSST DU IMPLEMENTIEREN =====
		bigint operator<<(unsigned int n) const;
		bigint operator>>(unsigned int n) const;
		bigint& operator<<=(unsigned int n);
		bigint& operator>>=(unsigned int n);
		
		bigint operator<<(const bigint& other) const;
		bigint operator>>(const bigint& other) const;
		bigint& operator<<=(const bigint& other);
		bigint& operator>>=(const bigint& other);
		
		// ===== COMPARISON - EASY =====
		bool operator==(const bigint& other) const;
		bool operator!=(const bigint& other) const;
		bool operator<(const bigint& other) const;
		bool operator>(const bigint& other) const;
		bool operator<=(const bigint& other) const;
		bool operator>=(const bigint& other) const;
};

// NON-MEMBER für Stream Output
std::ostream& operator<<(std::ostream& output, const bigint& obj);

#endif
