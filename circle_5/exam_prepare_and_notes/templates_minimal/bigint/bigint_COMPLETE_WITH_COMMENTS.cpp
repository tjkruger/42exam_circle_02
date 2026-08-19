/* ************************************************************************** */
/*         BIGINT.CPP - MINIMAL VERSION (nur was du ausfüllen musst)         */
/* ************************************************************************** */

#include "bigint.hpp"

/* ========================================================================== */
/* TEIL 1: Constructors - IM EXAM MEIST SCHON GEGEBEN                        */
/* ========================================================================== */

bigint::bigint()
{
	this->str = "0";
}

bigint::bigint(unsigned int num)
{
	std::stringstream ss;
	ss << num;
	this->str = ss.str();
}

bigint::bigint(const bigint& source)
{
	(*this) = source;
}

bigint& bigint::operator=(const bigint& source)
{
	if(this == &source)
		return(*this);
	this->str = source.str;
	return(*this);
}

std::string bigint::getStr() const
{
	return(this->str);
}


/* ========================================================================== */
/* TEIL 2: HELPER FUNCTIONS - DU MUSST SIE SCHREIBEN                         */
/* ========================================================================== */

// String umdrehen (für Addition)
std::string reverse(const std::string& str)
{
	std::string revStr;
	for(size_t i = str.length(); i > 0; i--)
	{
		revStr.push_back(str[i - 1]);
	}
	return(revStr);
}

// Addition wie in der Grundschule
std::string addition(const bigint& obj1, const bigint& obj2)
{
	// 1. Beide Strings umdrehen
	std::string str1 = reverse(obj1.getStr());
	std::string str2 = reverse(obj2.getStr());
	std::string result;
	
	size_t len1 = str1.length();
	size_t len2 = str2.length();
	
	// 2. Kürzeren String mit Nullen auffüllen
	if(len1 > len2)
	{
		int diff = len1 - len2;
		while(diff > 0)
		{
			str2.push_back('0');
			diff--;
		}
	}
	else if(len2 > len1)
	{
		int diff = len2 - len1;
		while(diff > 0)
		{
			str1.push_back('0');
			diff--;
		}
	}
	
	// 3. Stelle für Stelle addieren mit Übertrag
	int carry = 0;
	size_t len = str1.length();
	
	for(size_t i = 0; i < len; i++)
	{
		int digit1 = str1[i] - '0';
		int digit2 = str2[i] - '0';
		int res = digit1 + digit2 + carry;
		
		if(res > 9)
		{
			carry = res / 10;
			result.push_back((res % 10) + '0');
		}
		else
		{
			carry = 0;
			result.push_back(res + '0');
		}
	}
	
	// 4. Letzten Übertrag anhängen
	if(carry != 0)
		result.push_back(carry + '0');
	
	// 5. Zurück umdrehen
	return(reverse(result));
}

// String zu unsigned int konvertieren (für Shift mit bigint)
unsigned int stringToUINT(std::string str)
{
	std::stringstream ss(str);
	unsigned int res;
	ss >> res;
	return (res);
}


/* ========================================================================== */
/* TEIL 3: ADDITION OPERATORS - HIER MUSST DU ARBEITEN                       */
/* ========================================================================== */

bigint bigint::operator+(const bigint& other) const
{
	bigint temp(other);
	temp.str.clear();
	std::string result = addition(*this, other);
	temp.str = result;
	return(temp);
}

bigint& bigint::operator+=(const bigint& other)
{
	(*this) = (*this) + other;
	return(*this);
}

bigint& bigint::operator++()
{
	*(this) = *(this) + bigint(1);
	return(*this);
}

bigint bigint::operator++(int)
{
	bigint temp = (*this);
	*(this) = *(this) + bigint(1);
	return(temp);
}


/* ========================================================================== */
/* TEIL 4: SHIFT OPERATORS - KRITISCHER TEIL!                                */
/* ========================================================================== */

// LEFT SHIFT: Nullen anhängen (42 << 3 = 42000)
bigint bigint::operator<<(unsigned int n) const
{
	bigint temp = *this;
	temp.str.insert(temp.str.end(), n, '0');  // n Nullen anhängen
	return(temp);
}

// RIGHT SHIFT: Stellen entfernen (1337 >> 2 = 13)
bigint bigint::operator>>(unsigned int n) const
{
	bigint temp = *this;
	size_t len = temp.str.length();
	
	if(n >= len)
		temp.str = "0";
	else
		temp.str.erase(temp.str.length() - n, n);  // n Zeichen von rechts löschen
	
	return(temp);
}

// Compound assignments
bigint& bigint::operator<<=(unsigned int n)
{
	(*this) = (*this) << n;
	return(*this);
}

bigint& bigint::operator>>=(unsigned int n)
{
	(*this) = (*this) >> n;
	return(*this);
}

// Shift mit bigint (konvertiere zu unsigned int)
bigint bigint::operator<<(const bigint& other) const
{
	bigint temp;
	temp = (*this) << stringToUINT(other.str);
	return(temp);
}

bigint bigint::operator>>(const bigint& other) const
{
	bigint temp;
	temp = (*this) >> stringToUINT(other.str);
	return(temp);
}

bigint& bigint::operator<<=(const bigint& other)
{
	(*this) = (*this) << stringToUINT(other.str);
	return(*this);
}

bigint& bigint::operator>>=(const bigint& other)
{
	(*this) = (*this) >> stringToUINT(other.str);
	return(*this);
}


/* ========================================================================== */
/* TEIL 5: COMPARISON - EASY PEASY                                           */
/* ========================================================================== */

bool bigint::operator==(const bigint& other) const
{
	if(this->getStr() == other.getStr())
		return(true);
	return(false);
}

bool bigint::operator!=(const bigint& other) const
{
	return(!((*this) == (other)));
}

bool bigint::operator<(const bigint& other) const
{
	std::string str1 = this->str;
	std::string str2 = other.getStr();
	size_t len1 = str1.length();
	size_t len2 = str2.length();
	
	// Kürzere Zahl ist kleiner
	if(len1 != len2)
		return(len1 < len2);
	
	// Gleiche Länge → lexikographischer Vergleich
	return(str1 < str2);
}

bool bigint::operator>(const bigint& other) const
{
	return(!((*this) < other) && !((*this) == other));
}

bool bigint::operator<=(const bigint& other) const
{
	return(((*this) < other) || ((*this) == other));
}

bool bigint::operator>=(const bigint& other) const
{
	return(((*this) > other) || ((*this) == other));
}


/* ========================================================================== */
/* TEIL 6: NON-MEMBER - STREAM OUTPUT                                        */
/* ========================================================================== */

std::ostream& operator<<(std::ostream& output, const bigint& obj)
{
	output << obj.getStr();
	return(output);
}


/* ========================================================================== */
/* CHEAT SHEET: DIE 3 KERNFUNKTIONEN                                         */
/* ========================================================================== */
/*
   1. addition() - String reverse, digit-by-digit add, handle carry
   2. operator<<  - .insert(end, n, '0')
   3. operator>>  - .erase(len - n, n)
   
   Rest ist nur Wrapper!
*/
