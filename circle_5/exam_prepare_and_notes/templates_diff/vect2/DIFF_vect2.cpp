/* **************************************************************************** */
/*                         VECT2 - SIDE BY SIDE DIFF                            */
/* **************************************************************************** */

/*
╔══════════════════════════════════════════════════════════════════════════════╗
║                        SKELETON (was du bekommst)                            ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  class vect2                                                                 ║
║  {                                                                           ║
║      private:                                                                ║
║          int x;                                                              ║
║          int y;                                                              ║
║      public:                                                                 ║
║          vect2();                                                            ║
║          vect2(int num1, int num2);                                          ║
║          vect2(const vect2& source);                                         ║
║          vect2& operator=(const vect2& source);                              ║
║                                                                              ║
║          int operator[](int index) const;                                    ║
║          int& operator[](int index);                                         ║
║                                                                              ║
║          vect2 operator-() const;                                            ║
║          vect2 operator*(int num) const;                                     ║
║          vect2& operator*=(int num);                                         ║
║                                                                              ║
║          vect2& operator+=(const vect2& obj);                                ║
║          vect2& operator-=(const vect2& obj);                                ║
║          vect2& operator*=(const vect2& obj);        ⚠️ NICHT NÖTIG!         ║
║                                                                              ║
║          vect2 operator+(const vect2& obj) const;                            ║
║          vect2 operator-(const vect2& obj) const;                            ║
║          vect2 operator*(const vect2& obj) const;    ⚠️ NICHT NÖTIG!         ║
║                                                                              ║
║          vect2& operator++();                                                ║
║          vect2 operator++(int);                                              ║
║          vect2& operator--();                                                ║
║          vect2 operator--(int);                                              ║
║                                                                              ║
║          bool operator==(const vect2& obj) const;                            ║
║          bool operator!=(const vect2& obj) const;                            ║
║                                                                              ║
║          ~vect2();                                                           ║
║  };                                                                          ║
║                                                                              ║
║  ❌ FEHLT: vect2 operator*(int num, const vect2& obj);                       ║
║  ❌ FEHLT: std::ostream& operator<<(...)                                     ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                      WAS DU HINZUFÜGEN MUSST (Header)                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  // NACH der Klasse, VOR #endif:                                            ║
║                                                                              ║
║  vect2 operator*(int num, const vect2& obj);  ← NON-MEMBER!                 ║
║  std::ostream& operator<<(std::ostream& os, const vect2& obj);              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                  WAS DU IMPLEMENTIEREN MUSST (vect2.cpp)                     ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ✅ SCHON DA (meist implementiert im Skeleton):                             ║
║     - vect2(), vect2(int, int), Copy Constructor, operator=                 ║
║     - operator[], operator*, operator*=, operator+=, operator-=             ║
║     - operator+, operator-, operator-                                       ║
║                                                                              ║
║  ✅ SCHON DA (meist komplett):                                              ║
║     - operator++, operator--, operator==, operator!=                        ║
║                                                                              ║
║  ❌ MUSST DU ERGÄNZEN am Ende der Datei:                                    ║
║                                                                              ║
║     // NON-MEMBER FUNCTIONS                                                 ║
║     std::ostream& operator<<(std::ostream& os, const vect2& obj)            ║
║     {                                                                        ║
║         std::cout << "{" << obj[0] << ", " << obj[1] << "}";                ║
║         return(os);                                                          ║
║     }                                                                        ║
║                                                                              ║
║     vect2 operator*(int num, const vect2& obj)                              ║
║     {                                                                        ║
║         vect2 temp(obj);                                                     ║
║         temp *= num;                                                         ║
║         return(temp);                                                        ║
║     }                                                                        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                              ZUSAMMENFASSUNG                                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  SKELETON hat:         ~90% der Klasse                                       ║
║  DU musst ergänzen:    2 Funktionen am Ende!                                 ║
║                                                                              ║
║  FEHLERQUELLE #1:  operator<< vergessen → Compile Error                     ║
║  FEHLERQUELLE #2:  operator*(int, vect2) vergessen → "3 * v2" Error         ║
║                                                                              ║
║  ⏱️  Zeit: ~3 Minuten                                                        ║
╚══════════════════════════════════════════════════════════════════════════════╝
*/

// QUICK COPY-PASTE für vect2.cpp (am Ende einfügen):

std::ostream& operator<<(std::ostream& os, const vect2& obj)
{
	std::cout << "{" << obj[0] << ", " << obj[1] << "}";
	return(os);
}

vect2 operator*(int num, const vect2& obj)
{
	vect2 temp(obj);
	temp *= num;
	return(temp);
}


temp[0] = -temp[0];
temp.operator[](0) = -(temp.operator[](0));

int& vect2::operator[](int index)  // Eine ganz normale Funktion!
{
    if(index == 0)
        return(this->x);  // Du gibst einfach x zurück
    return(this->y);      // Oder y
}

int arr[2] = {10, 20};
arr[0] = 5;  // Compiler: gehe zu Speicheradresse arr + (0 * sizeof(int))

vect2 temp(10, 20);
temp[0] = 5;  // Compiler: rufe temp.operator[](0) auf
              //           → gibt this->x zurück
              //           → x wird zu 5

class vect2 {
    int x, y;
public:
    int& operator[](int index) {
        if(index == 0)
            return x;  // ICH sage: [0] bedeutet x
        return y;      // ICH sage: [1] bedeutet y
    }
};


int& operator[](int index) {
    if(index == 0)
        return y;  // [0] könnte auch y sein!
    return x;      // [1] könnte x sein!
}