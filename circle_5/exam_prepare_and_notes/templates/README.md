# C++ Exam Templates - 42 Rank05 Level1

## 📁 Struktur

```
templates/
├── vect2/           ✅ Einfach - 2D Vector mit Arithmetik
├── bigint/          ⚠️  Mittel - Große Zahlen als String
└── polyset/         🧠 OOP - Polymorphe Sets/Bags
```

---

## 🎯 vect2 - COPY-PASTE READY

**Was?** 2D-Vektor mit +, -, *, ++, --, []

**Trick:** Alles inline im Header, 0 Denken nötig

**Files:**
- `vect2.hpp` - Komplett fertig
- `vect2.cpp` - Leer (alles im header)

**Test:**
```bash
cp templates/vect2/* rendu/vect2/
cd rendu/vect2 && c++ -Wall -Wextra -Werror main.cpp vect2.cpp && ./a.out
```

---

## 🔢 bigint - STRING ARITHMETIK

**Was?** Zahlen größer als SIZE_MAX via String speichern

**Trick:** Addition wie in Grundschule (reverse → add → reverse)

**Kernlogik:**
```cpp
// String umdrehen → Stelle für Stelle addieren → Übertrag
"42" + "21" → "24" + "12" → "36" → "63"
```

**Shift:**
- `<<` = Nullen anhängen: `42 << 3` = "42000"
- `>>` = Stellen abschneiden: `1337 >> 2` = "13"

**Test:**
```bash
cp templates/bigint/* rendu/bigint/
cd rendu/bigint && c++ -Wall -Wextra -Werror main.cpp bigint.cpp && ./a.out
```

---

## 🎭 polyset - OOP VERERBUNG

**Was?** Sets (keine Duplikate) basierend auf Array/Tree Bags

**Files:**
1. `searchable_array_bag.hpp` - Array + Suchfunktion
2. `searchable_tree_bag.hpp` - BST + Suchfunktion  
3. `set.hpp` - Wrapper der Duplikate filtert

**Trick:** Nur weiterleiten, kein eigener Code

```cpp
// searchable_array_bag
virtual bool has(int value) const {
    for (int i = 0; i < size; i++)
        if (data[i] == value) return true;
    return false;
}

// set
void insert(int value) {
    if (!bag->has(value))  // Prüfe Duplikat
        bag->insert(value);
}
```

**Test:**
```bash
# Kopiere subject files + templates
cp .resources/rank05/level1/polyset/subject/* rendu/polyset/
cp templates/polyset/* rendu/polyset/
cd rendu/polyset && c++ -Wall -Wextra -Werror *.cpp && ./a.out
```

---

## 💡 Lernstrategie

1. **vect2** zuerst → Erfolgserlebnis in 5 Min
2. **bigint** → String-Tricks verstehen
3. **polyset** → OOP ohne Kopfschmerz

**Im Exam:**
- Templates kopieren → main.cpp anpassen → testen
- Keine Panik bei Fehlern, Schritt für Schritt debuggen

---

## 🚀 Quick Copy Commands

```bash
# Alle auf einmal testen
for dir in vect2 bigint; do
    cp templates/$dir/* rendu/$dir/ 2>/dev/null
done

# Polyset braucht subject files
cp .resources/rank05/level1/polyset/subject/* rendu/polyset/
cp templates/polyset/* rendu/polyset/
```

---

**Viel Erfolg!** 🍀
