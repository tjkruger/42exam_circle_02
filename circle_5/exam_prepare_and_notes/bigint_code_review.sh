#!/bin/bash

# bigint_code_review.sh - Ist dieser Code richtig?
# Trainiere dein Auge für Fehler bei string manipulation!

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

score=0
total=0

show_snippet() {
    local title=$1
    local code=$2
    local is_correct=$3
    local explanation=$4
    
    ((total++))
    
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  CODE REVIEW [$total]${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}$title${NC}"
    echo ""
    echo -e "${YELLOW}Code:${NC}"
    echo "────────────────────────────────────────────────────────"
    echo "$code"
    echo "────────────────────────────────────────────────────────"
    echo ""
    read -p "Ist dieser Code RICHTIG? (y/n): " answer
    
    if [[ "$answer" == "y" && "$is_correct" == "yes" ]] || \
       [[ "$answer" == "n" && "$is_correct" == "no" ]]; then
        echo -e "${GREEN}✓ RICHTIG!${NC}"
        ((score++))
    else
        echo -e "${RED}✗ FALSCH!${NC}"
        if [ "$is_correct" == "yes" ]; then
            echo -e "${GREEN}Dieser Code ist RICHTIG!${NC}"
        else
            echo -e "${RED}Dieser Code ist FALSCH!${NC}"
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}Erklärung:${NC}"
    echo "$explanation"
    echo ""
    read -p "Drück ENTER..."
}

# ============================================================================
# SNIPPETS - CONSTRUCTORS
# ============================================================================

# RICHTIG: Default Constructor
show_snippet \
"bigint.cpp - Default Constructor" \
"bigint::bigint()
{
    this->str = \"0\";
}" \
"yes" \
"✓ Initialisiert str mit \"0\"
✓ Default bigint ist 0
✓ String representation
→ Warum richtig? Sinnvoller default value"

# FALSCH: Default Constructor - leerer string
show_snippet \
"bigint.cpp - Default Constructor Empty String" \
"bigint::bigint()
{
    this->str = \"\";
}" \
"no" \
"❌ str ist leer (\"\")!
→ Leerer string ist KEIN gültiger bigint
→ Operationen würden fehlschlagen
→ Fix: str = \"0\"; (default ist Null)"

# RICHTIG: int Constructor
show_snippet \
"bigint.cpp - int Constructor" \
"bigint::bigint(int n)
{
    std::stringstream ss;
    ss << n;
    this->str = ss.str();
}" \
"yes" \
"✓ Nutzt stringstream für int→string conversion
✓ ss << n schreibt int in stream
✓ ss.str() gibt string zurück
→ Warum richtig? Standard C++98 int-to-string"

# FALSCH: int Constructor - kein ss.str()
show_snippet \
"bigint.cpp - int Constructor Fehlt str()" \
"bigint::bigint(int n)
{
    std::stringstream ss;
    ss << n;
    this->str = ss;
}" \
"no" \
"❌ Assigned ss zu str (type mismatch)!
→ ss ist stringstream, str ist string
→ Compiler Error: cannot convert
→ Fix: this->str = ss.str(); (str() method)"

# RICHTIG: string Constructor
show_snippet \
"bigint.cpp - string Constructor" \
"bigint::bigint(const std::string& s)
{
    this->str = s;
}" \
"yes" \
"✓ Kopiert string s nach str
✓ const& parameter (keine Kopie nötig)
→ Warum richtig? Simple string assignment"

# RICHTIG: Copy Constructor
show_snippet \
"bigint.cpp - Copy Constructor" \
"bigint::bigint(const bigint& source)
{
    this->str = source.str;
}" \
"yes" \
"✓ Kopiert source.str nach this->str
✓ Deep copy (string hat eigenen copy)
→ Warum richtig? Proper deep copy"

# FALSCH: Copy Constructor - *this = source
show_snippet \
"bigint.cpp - Copy Constructor via operator=" \
"bigint::bigint(const bigint& source)
{
    *this = source;
}" \
"no" \
"❌ Nutzt operator= im constructor!
→ Funktioniert, aber NICHT empfohlen in C++98
→ operator= geht von initialisiertem Objekt aus
→ Best practice: this->str = source.str;"

# ============================================================================
# SNIPPETS - HELPER FUNCTIONS
# ============================================================================

# RICHTIG: reverse() helper
show_snippet \
"bigint.cpp - reverse() Helper" \
"std::string bigint::reverse(std::string s)
{
    std::string result;
    for (int i = s.length() - 1; i >= 0; i--)
        result += s[i];
    return (result);
}" \
"yes" \
"✓ Loop von Ende bis Anfang (length-1 bis 0)
✓ result += s[i] fügt chars in reverse order ein
✓ Return reversed string
→ Warum richtig? Klassische reverse implementation"

# FALSCH: reverse() - i <= s.length()
show_snippet \
"bigint.cpp - reverse() Wrong Start Index" \
"std::string bigint::reverse(std::string s)
{
    std::string result;
    for (int i = s.length(); i >= 0; i--)
        result += s[i];
    return (result);
}" \
"no" \
"❌ Start index ist s.length()!
→ String indices: 0 bis length-1
→ s[length] ist out of bounds
→ Fix: i = s.length() - 1 (mit -1)"

# FALSCH: reverse() - i > 0
show_snippet \
"bigint.cpp - reverse() Missing Last Char" \
"std::string bigint::reverse(std::string s)
{
    std::string result;
    for (int i = s.length() - 1; i > 0; i--)
        result += s[i];
    return (result);
}" \
"no" \
"❌ Loop condition ist i > 0!
→ Stoppt bei i == 1, überspringt s[0]
→ Letztes char fehlt im result
→ Fix: i >= 0 (mit =)"

# RICHTIG: remove_leading_zeros()
show_snippet \
"bigint.cpp - remove_leading_zeros()" \
"std::string bigint::remove_leading_zeros(std::string s)
{
    while (s.length() > 1 && s[0] == '0')
        s = s.substr(1);
    return (s);
}" \
"yes" \
"✓ Loop solange s[0] == '0' UND length > 1
✓ substr(1) entfernt erstes char
✓ Stoppt bei \"0\" (nicht leeren string)
→ Warum richtig? Erhält mindestens \"0\""

# FALSCH: remove_leading_zeros() - fehlt length > 1
show_snippet \
"bigint.cpp - remove_leading_zeros() Empty Result" \
"std::string bigint::remove_leading_zeros(std::string s)
{
    while (s[0] == '0')
        s = s.substr(1);
    return (s);
}" \
"no" \
"❌ Keine length > 1 check!
→ \"000\" würde komplett geleert werden → \"\"
→ Leerer string ist ungültig
→ Fix: while (s.length() > 1 && s[0] == '0')"

# ============================================================================
# SNIPPETS - operator+ (Addition)
# ============================================================================

# RICHTIG: operator+ basic structure
show_snippet \
"bigint.cpp - operator+ Structure" \
"bigint bigint::operator+(const bigint& obj) const
{
    std::string num1 = this->str;
    std::string num2 = obj.str;
    std::string result;
    int carry = 0;
    
    num1 = reverse(num1);
    num2 = reverse(num2);
    
    // ... addition logic ...
    
    result = reverse(result);
    return (bigint(result));
}" \
"yes" \
"✓ Return bigint (new object)
✓ const method (ändert this nicht)
✓ Reverse → add → reverse back
✓ Carry tracking
→ Warum richtig? Standard addition algorithm"

# FALSCH: operator+ - fehlt reverse back
show_snippet \
"bigint.cpp - operator+ Missing Reverse Back" \
"bigint bigint::operator+(const bigint& obj) const
{
    std::string num1 = reverse(this->str);
    std::string num2 = reverse(obj.str);
    std::string result;
    int carry = 0;
    
    // ... addition logic ...
    
    return (bigint(result));
}" \
"no" \
"❌ result wird NICHT zurück reversed!
→ Addition arbeitet reversed (LSD first)
→ Result ist reversed → muss zurück reversed werden
→ Fix: result = reverse(result); vor return"

# RICHTIG: operator+ digit addition
show_snippet \
"bigint.cpp - operator+ Digit Addition" \
"int digit1 = (i < num1.length()) ? num1[i] - '0' : 0;
int digit2 = (i < num2.length()) ? num2[i] - '0' : 0;
int sum = digit1 + digit2 + carry;

result += (sum % 10) + '0';
carry = sum / 10;" \
"yes" \
"✓ Ternary für unterschiedliche lengths
✓ - '0' konvertiert char→int ('5' - '0' = 5)
✓ sum % 10 gibt digit, sum / 10 gibt carry
✓ + '0' konvertiert int→char (5 + '0' = '5')
→ Warum richtig? Proper char/int conversion + carry"

# FALSCH: operator+ - fehlt '0' conversion
show_snippet \
"bigint.cpp - operator+ Fehlt Char Conversion" \
"int digit1 = (i < num1.length()) ? num1[i] : 0;
int digit2 = (i < num2.length()) ? num2[i] : 0;
int sum = digit1 + digit2 + carry;

result += (sum % 10);
carry = sum / 10;" \
"no" \
"❌ Fehlt - '0' und + '0' conversion!
→ num1[i] ist char ('5'), nicht int (5)
→ char '5' hat ASCII value 53, nicht 5
→ result += (sum % 10) fügt int, nicht char ein
→ Fix: num1[i] - '0' und (sum % 10) + '0'"

# RICHTIG: operator+ final carry
show_snippet \
"bigint.cpp - operator+ Final Carry" \
"// Nach der loop:
if (carry > 0)
    result += carry + '0';

result = reverse(result);
result = remove_leading_zeros(result);
return (bigint(result));" \
"yes" \
"✓ Checkt ob carry nach loop noch > 0
✓ Fügt final carry digit hinzu
✓ Reverse back + remove leading zeros
→ Warum richtig? Handled overflow case (999 + 1 = 1000)"

# FALSCH: operator+ - fehlt final carry check
show_snippet \
"bigint.cpp - operator+ Missing Final Carry" \
"// Nach der loop:
result = reverse(result);
result = remove_leading_zeros(result);
return (bigint(result));" \
"no" \
"❌ Fehlt final carry check!
→ 999 + 1 = 1000, aber carry wird ignoriert
→ Result: 000 statt 1000
→ Fix: if (carry > 0) result += carry + '0';"

# ============================================================================
# SNIPPETS - operator<< (Left Shift)
# ============================================================================

# RICHTIG: operator<< basic
show_snippet \
"bigint.cpp - operator<<" \
"bigint bigint::operator<<(int n) const
{
    std::string result = this->str;
    for (int i = 0; i < n; i++)
        result += '0';
    return (bigint(result));
}" \
"yes" \
"✓ Append '0' n times
✓ Left shift = multiply by 10^n
✓ Return new bigint
→ Warum richtig? \"123\" << 2 = \"12300\" (× 100)"

# FALSCH: operator<< - prepend statt append
show_snippet \
"bigint.cpp - operator<< Prepend" \
"bigint bigint::operator<<(int n) const
{
    std::string result;
    for (int i = 0; i < n; i++)
        result += '0';
    result += this->str;
    return (bigint(result));
}" \
"no" \
"❌ Fügt '0' VOR str hinzu!
→ \"123\" << 2 würde \"00123\" (falsch)
→ Sollte \"12300\" sein (× 100)
→ Fix: result = this->str; dann result += '0';"

# ============================================================================
# SNIPPETS - operator>> (Right Shift)
# ============================================================================

# RICHTIG: operator>> basic
show_snippet \
"bigint.cpp - operator>>" \
"bigint bigint::operator>>(int n) const
{
    std::string result = this->str;
    if (n >= (int)result.length())
        return (bigint(\"0\"));
    
    result = result.substr(0, result.length() - n);
    result = remove_leading_zeros(result);
    return (bigint(result));
}" \
"yes" \
"✓ Check ob n >= length → return \"0\"
✓ substr(0, length - n) entfernt n chars vom Ende
✓ remove_leading_zeros für \"000\" cases
→ Warum richtig? \"12300\" >> 2 = \"123\" (÷ 100)"

# FALSCH: operator>> - fehlt length check
show_snippet \
"bigint.cpp - operator>> Missing Length Check" \
"bigint bigint::operator>>(int n) const
{
    std::string result = this->str;
    result = result.substr(0, result.length() - n);
    result = remove_leading_zeros(result);
    return (bigint(result));
}" \
"no" \
"❌ Keine length check!
→ Wenn n >= length, length - n ist negativ/0
→ substr mit negativem/0 length: undefined behavior
→ Fix: if (n >= (int)length) return bigint(\"0\");"

# FALSCH: operator>> - substr wrong parameters
show_snippet \
"bigint.cpp - operator>> Wrong substr" \
"bigint bigint::operator>>(int n) const
{
    std::string result = this->str;
    if (n >= (int)result.length())
        return (bigint(\"0\"));
    
    result = result.substr(n);
    return (bigint(result));
}" \
"no" \
"❌ substr(n) startet ab index n!
→ \"12345\".substr(2) = \"345\" (entfernt ANFANG)
→ Sollte ENDE entfernen, nicht Anfang
→ Fix: substr(0, length - n) (0 bis length-n)"

# ============================================================================
# SNIPPETS - Comparison Operators
# ============================================================================

# RICHTIG: operator==
show_snippet \
"bigint.cpp - operator==" \
"bool bigint::operator==(const bigint& obj) const
{
    return (this->str == obj.str);
}" \
"yes" \
"✓ Simple string comparison
✓ Return bool
✓ const method
→ Warum richtig? Strings represent values"

# RICHTIG: operator< length check
show_snippet \
"bigint.cpp - operator< Length Check" \
"bool bigint::operator<(const bigint& obj) const
{
    if (this->str.length() < obj.str.length())
        return (true);
    if (this->str.length() > obj.str.length())
        return (false);
    return (this->str < obj.str);
}" \
"yes" \
"✓ Shorter string = smaller number (\"99\" < \"100\")
✓ Longer string = bigger number
✓ Same length → lexicographic comparison
→ Warum richtig? Handled different lengths correctly"

# FALSCH: operator< - direkt string compare
show_snippet \
"bigint.cpp - operator< Direct Compare" \
"bool bigint::operator<(const bigint& obj) const
{
    return (this->str < obj.str);
}" \
"no" \
"❌ Direkte lexicographic comparison!
→ \"99\" < \"100\" lexicographisch ist FALSE ('9' > '1')
→ Numerisch sollte \"99\" < \"100\" TRUE sein
→ Fix: erst length checken, dann string compare"

# RICHTIG: operator>
show_snippet \
"bigint.cpp - operator>" \
"bool bigint::operator>(const bigint& obj) const
{
    return (obj < *this);
}" \
"yes" \
"✓ Nutzt operator< (code reuse)
✓ a > b ist äquivalent zu b < a
→ Warum richtig? DRY principle, logisch korrekt"

# FALSCH: operator> - copy-paste von operator<
show_snippet \
"bigint.cpp - operator> Copy-Paste" \
"bool bigint::operator>(const bigint& obj) const
{
    if (this->str.length() > obj.str.length())
        return (true);
    if (this->str.length() < obj.str.length())
        return (false);
    return (this->str > obj.str);
}" \
"no" \
"❌ Code duplication!
→ Funktioniert, aber nicht DRY
→ Wenn operator< Bug hat, operator> auch
→ Best practice: return (obj < *this);"

# ============================================================================
# SNIPPETS - Assignment & Compound Operators
# ============================================================================

# RICHTIG: operator=
show_snippet \
"bigint.cpp - operator=" \
"bigint& bigint::operator=(const bigint& source)
{
    if (this != &source)
    {
        this->str = source.str;
    }
    return (*this);
}" \
"yes" \
"✓ Self-assignment check
✓ Kopiert str
✓ return *this für chaining
→ Warum richtig? Standard assignment pattern"

# FALSCH: operator= - kein return
show_snippet \
"bigint.cpp - operator= Missing Return" \
"bigint& bigint::operator=(const bigint& source)
{
    if (this != &source)
    {
        this->str = source.str;
    }
}" \
"no" \
"❌ Fehlt return (*this)!
→ Return-Type ist bigint&
→ Für chaining: b1 = b2 = b3
→ Fix: return (*this); am Ende"

# RICHTIG: operator+=
show_snippet \
"bigint.cpp - operator+=" \
"bigint& bigint::operator+=(const bigint& obj)
{
    *this = *this + obj;
    return (*this);
}" \
"yes" \
"✓ Nutzt operator+ (code reuse)
✓ Modifiziert *this
✓ return *this für chaining
→ Warum richtig? DRY, implementiert += via +"

# FALSCH: operator+= - return by value
show_snippet \
"bigint.cpp - operator+= Return by Value" \
"bigint bigint::operator+=(const bigint& obj)
{
    *this = *this + obj;
    return (*this);
}" \
"no" \
"❌ Return-Type ist bigint (by value)!
→ Sollte bigint& sein (by reference)
→ Chaining funktioniert nicht: b1 += b2 += b3
→ Fix: bigint& als Return-Type"

# ============================================================================
# SNIPPETS - operator<< (Stream Output) NON-MEMBER
# ============================================================================

# RICHTIG: operator<< stream
show_snippet \
"bigint.cpp - operator<< (stream) NON-MEMBER" \
"std::ostream& operator<<(std::ostream& os, const bigint& obj)
{
    os << obj.get_str();
    return (os);
}" \
"yes" \
"✓ NON-MEMBER function (kein bigint::)
✓ Return ostream& für chaining
✓ Nutzt get_str() getter
→ Warum richtig? Standard stream insertion operator"

# FALSCH: operator<< stream - ist member
show_snippet \
"bigint.cpp - operator<< (stream) Member" \
"std::ostream& bigint::operator<<(std::ostream& os, const bigint& obj)
{
    os << obj.get_str();
    return (os);
}" \
"no" \
"❌ Hat bigint:: prefix (member function)!
→ Member signature: this, os, obj (3 parameter)
→ Sollte NON-MEMBER sein (2 parameter)
→ Fix: entferne bigint:: prefix"

# FALSCH: operator<< stream - return void
show_snippet \
"bigint.cpp - operator<< (stream) Return void" \
"void operator<<(std::ostream& os, const bigint& obj)
{
    os << obj.get_str();
}" \
"no" \
"❌ Return-Type ist void!
→ Chaining funktioniert nicht: cout << b1 << b2
→ Muss ostream& returnen
→ Fix: return os; am Ende"

# ============================================================================
# ERGEBNIS
# ============================================================================

clear
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      ERGEBNIS                                ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"

percentage=$((score * 100 / total))

echo -e "${BLUE}║${NC}  Punkte: ${GREEN}$score${NC} / $total"
echo -e "${BLUE}║${NC}  Prozent: ${percentage}%"

if [ $percentage -ge 90 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}🎉 EXCELLENT!${NC} Du erkennst bigint Fehler sofort!"
    echo -e "${BLUE}║${NC}  ${GREEN}String manipulation, carry logic: MASTERED!${NC}"
elif [ $percentage -ge 70 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}👍 GUT!${NC} Noch ein paar Unsicherheiten"
    echo -e "${BLUE}║${NC}  ${YELLOW}Review: char/int conversion, reverse, carry${NC}"
elif [ $percentage -ge 50 ]; then
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}⚠️  OKAY${NC} - Lies bigint_trainer.sh exercises"
    echo -e "${BLUE}║${NC}  ${YELLOW}Focus: operator+, reverse(), substr()${NC}"
else
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${RED}❌ NOCH NICHT READY!${NC}"
    echo -e "${BLUE}║${NC}  ${RED}Run ./bigint_trainer.sh and practice!${NC}"
fi

echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

read -p "Drück ENTER um zu beenden..."
