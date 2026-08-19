/* **************************************************************************** */
/*                         BIGINT - SIDE BY SIDE DIFF                           */
/* **************************************************************************** */

/*
╔══════════════════════════════════════════════════════════════════════════════╗
║                        SKELETON (was du bekommst)                            ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  class bigint                                                                ║
║  {                                                                           ║
║      private:                                                                ║
║          std::string str;                                                    ║
║                                                                              ║
║      public:                                                                 ║
║          bigint();                                   ✅ Meist implementiert  ║
║          bigint(unsigned int num);                   ✅ Meist implementiert  ║
║          bigint(const bigint& source);               ✅ Meist implementiert  ║
║          std::string getStr() const;                 ✅ Meist implementiert  ║
║          bigint& operator=(const bigint& source);    ✅ Meist implementiert  ║
║                                                                              ║
║          bigint operator+(const bigint& other) const;    ❌ FEHLT LOGIC     ║
║          bigint& operator+=(const bigint& other);        ❌ FEHLT           ║
║          bigint& operator++();                           ❌ FEHLT           ║
║          bigint operator++(int);                         ❌ FEHLT           ║
║                                                                              ║
║          bigint operator<<(unsigned int n) const;        ❌ FEHLT LOGIC     ║
║          bigint operator>>(unsigned int n) const;        ❌ FEHLT LOGIC     ║
║          bigint& operator<<=(unsigned int n);            ❌ FEHLT           ║
║          bigint& operator>>=(unsigned int n);            ❌ FEHLT           ║
║                                                                              ║
║          bigint operator<<(const bigint& other) const;   ❌ FEHLT           ║
║          bigint operator>>(const bigint& other) const;   ❌ FEHLT           ║
║          bigint& operator<<=(const bigint& other);       ❌ FEHLT           ║
║          bigint& operator>>=(const bigint& other);       ❌ FEHLT           ║
║                                                                              ║
║          bool operator==(const bigint& other) const;     ❌ FEHLT           ║
║          bool operator!=(const bigint& other) const;     ❌ FEHLT           ║
║          bool operator<(const bigint& other) const;      ❌ FEHLT           ║
║          bool operator>(const bigint& other) const;      ❌ FEHLT           ║
║          bool operator<=(const bigint& other) const;     ❌ FEHLT           ║
║          bool operator>=(const bigint& other) const;     ❌ FEHLT           ║
║  };                                                                          ║
║                                                                              ║
║  ❌ FEHLT: std::ostream& operator<<(std::ostream&, const bigint&);          ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                      WAS DU SCHREIBEN MUSST (bigint.cpp)                     ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🔥 KERNFUNKTION #1: ADDITION (Grundschul-Methode)                          ║
║  ═════════════════════════════════════════════════════════════              ║
║                                                                              ║
║  std::string reverse(const std::string& str)                                 ║
║  {                                                                           ║
║      std::string revStr;                                                     ║
║      for(size_t i = str.length(); i > 0; i--)                                ║
║          revStr.push_back(str[i - 1]);                                       ║
║      return(revStr);                                                         ║
║  }                                                                           ║
║                                                                              ║
║  std::string addition(const bigint& obj1, const bigint& obj2)                ║
║  {                                                                           ║
║      std::string str1 = reverse(obj1.getStr());                              ║
║      std::string str2 = reverse(obj2.getStr());                              ║
║      std::string result;                                                     ║
║                                                                              ║
║      // Padding: Beide Strings gleich lang machen                           ║
║      size_t len1 = str1.length();                                            ║
║      size_t len2 = str2.length();                                            ║
║      if(len1 > len2) {                                                       ║
║          while(str2.length() < len1) str2.push_back('0');                    ║
║      } else if(len2 > len1) {                                                ║
║          while(str1.length() < len2) str1.push_back('0');                    ║
║      }                                                                       ║
║                                                                              ║
║      // Digit-by-digit addieren                                             ║
║      int carry = 0;                                                          ║
║      for(size_t i = 0; i < str1.length(); i++)                               ║
║      {                                                                       ║
║          int digit1 = str1[i] - '0';                                         ║
║          int digit2 = str2[i] - '0';                                         ║
║          int res = digit1 + digit2 + carry;                                  ║
║          if(res > 9) {                                                       ║
║              carry = res / 10;                                               ║
║              result.push_back((res % 10) + '0');                             ║
║          } else {                                                            ║
║              carry = 0;                                                      ║
║              result.push_back(res + '0');                                    ║
║          }                                                                   ║
║      }                                                                       ║
║      if(carry != 0)                                                          ║
║          result.push_back(carry + '0');                                      ║
║                                                                              ║
║      return(reverse(result));                                                ║
║  }                                                                           ║
║                                                                              ║
║  bigint bigint::operator+(const bigint& other) const                         ║
║  {                                                                           ║
║      bigint temp(other);                                                     ║
║      temp.str.clear();                                                       ║
║      temp.str = addition(*this, other);                                      ║
║      return(temp);                                                           ║
║  }                                                                           ║
║                                                                              ║
║  bigint& bigint::operator+=(const bigint& other)                             ║
║  {                                                                           ║
║      (*this) = (*this) + other;                                              ║
║      return(*this);                                                          ║
║  }                                                                           ║
║                                                                              ║
║  bigint& bigint::operator++()                                                ║
║  {                                                                           ║
║      *(this) = *(this) + bigint(1);                                          ║
║      return(*this);                                                          ║
║  }                                                                           ║
║                                                                              ║
║  bigint bigint::operator++(int)                                              ║
║  {                                                                           ║
║      bigint temp = (*this);                                                  ║
║      *(this) = *(this) + bigint(1);                                          ║
║      return(temp);                                                           ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🔥 KERNFUNKTION #2: LEFT SHIFT (Nullen anhängen)                           ║
║  ═════════════════════════════════════════════════════════════              ║
║                                                                              ║
║  bigint bigint::operator<<(unsigned int n) const                             ║
║  {                                                                           ║
║      bigint temp = *this;                                                    ║
║      temp.str.insert(temp.str.end(), n, '0');  // n Nullen anhängen         ║
║      return(temp);                                                           ║
║  }                                                                           ║
║                                                                              ║
║  bigint& bigint::operator<<=(unsigned int n)                                 ║
║  {                                                                           ║
║      (*this) = (*this) << n;                                                 ║
║      return(*this);                                                          ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🔥 KERNFUNKTION #3: RIGHT SHIFT (Stellen abschneiden)                      ║
║  ═════════════════════════════════════════════════════════════              ║
║                                                                              ║
║  bigint bigint::operator>>(unsigned int n) const                             ║
║  {                                                                           ║
║      bigint temp = *this;                                                    ║
║      size_t len = temp.str.length();                                         ║
║      if(n >= len)                                                            ║
║          temp.str = "0";                                                     ║
║      else                                                                    ║
║          temp.str.erase(temp.str.length() - n, n);                           ║
║      return(temp);                                                           ║
║  }                                                                           ║
║                                                                              ║
║  bigint& bigint::operator>>=(unsigned int n)                                 ║
║  {                                                                           ║
║      (*this) = (*this) >> n;                                                 ║
║      return(*this);                                                          ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🔄 SHIFT MIT BIGINT (konvertiere zu unsigned int)                          ║
║  ═════════════════════════════════════════════════════════════              ║
║                                                                              ║
║  unsigned int stringToUINT(std::string str)                                  ║
║  {                                                                           ║
║      std::stringstream ss(str);                                              ║
║      unsigned int res;                                                       ║
║      ss >> res;                                                              ║
║      return (res);                                                           ║
║  }                                                                           ║
║                                                                              ║
║  bigint bigint::operator<<(const bigint& other) const                        ║
║  {                                                                           ║
║      return (*this) << stringToUINT(other.str);                              ║
║  }                                                                           ║
║                                                                              ║
║  bigint bigint::operator>>(const bigint& other) const                        ║
║  {                                                                           ║
║      return (*this) >> stringToUINT(other.str);                              ║
║  }                                                                           ║
║                                                                              ║
║  bigint& bigint::operator<<=(const bigint& other)                            ║
║  {                                                                           ║
║      (*this) = (*this) << stringToUINT(other.str);                           ║
║      return(*this);                                                          ║
║  }                                                                           ║
║                                                                              ║
║  bigint& bigint::operator>>=(const bigint& other)                            ║
║  {                                                                           ║
║      (*this) = (*this) >> stringToUINT(other.str);                           ║
║      return(*this);                                                          ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  ✅ COMPARISON (einfach!)                                                    ║
║  ═════════════════════════════════════════════════════════════              ║
║                                                                              ║
║  bool bigint::operator==(const bigint& other) const                          ║
║  {                                                                           ║
║      return(this->getStr() == other.getStr());                               ║
║  }                                                                           ║
║                                                                              ║
║  bool bigint::operator!=(const bigint& other) const                          ║
║  {                                                                           ║
║      return(!((*this) == (other)));                                          ║
║  }                                                                           ║
║                                                                              ║
║  bool bigint::operator<(const bigint& other) const                           ║
║  {                                                                           ║
║      std::string str1 = this->str;                                           ║
║      std::string str2 = other.getStr();                                      ║
║      size_t len1 = str1.length();                                            ║
║      size_t len2 = str2.length();                                            ║
║      if(len1 != len2)                                                        ║
║          return(len1 < len2);  // Kürzere Zahl ist kleiner                  ║
║      return(str1 < str2);      // Gleiche Länge → lexikographisch           ║
║  }                                                                           ║
║                                                                              ║
║  bool bigint::operator>(const bigint& other) const                           ║
║  {                                                                           ║
║      return(!((*this) < other) && !((*this) == other));                      ║
║  }                                                                           ║
║                                                                              ║
║  bool bigint::operator<=(const bigint& other) const                          ║
║  {                                                                           ║
║      return(((*this) < other) || ((*this) == other));                        ║
║  }                                                                           ║
║                                                                              ║
║  bool bigint::operator>=(const bigint& other) const                          ║
║  {                                                                           ║
║      return(((*this) > other) || ((*this) == other));                        ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  📺 STREAM OUTPUT                                                            ║
║  ═════════════════════════════════════════════════════════════              ║
║                                                                              ║
║  std::ostream& operator<<(std::ostream& output, const bigint& obj)           ║
║  {                                                                           ║
║      output << obj.getStr();                                                 ║
║      return(output);                                                         ║
║  }                                                                           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                              ZUSAMMENFASSUNG                                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  SKELETON hat:         ~30% (nur Struktur + Constructors)                    ║
║  DU musst schreiben:   ~70% (alle Operator-Logik)                            ║
║                                                                              ║
║  3 KERNFUNKTIONEN:                                                           ║
║    1. addition() - Grundschul-Methode mit carry                             ║
║    2. operator<< - .insert(end, n, '0')                                     ║
║    3. operator>> - .erase(len - n, n)                                       ║
║                                                                              ║
║  Rest ist Wrapper um diese 3 Funktionen!                                     ║
║                                                                              ║
║  ⏱️  Zeit: ~20 Minuten                                                       ║
╚══════════════════════════════════════════════════════════════════════════════╝
*/
