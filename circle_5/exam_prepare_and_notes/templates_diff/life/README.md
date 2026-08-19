# LIFE - Conway's Game of Life in C

## 🎯 Aufgabe

Implementiere Conway's Game of Life!

```bash
./life width height iterations
```

**Input:** stdin Commands (zeichne mit "Stift")
- `w/a/s/d` → Stift bewegen (up/left/down/right)  
- `x` → Stift heben/senken (toggle)

**Output:** Board nach N Iterationen
- `O` = lebende Zelle
- ` ` = tote Zelle

---

## 🎮 Game of Life Regeln

```
Lebende Zelle:
  - <2 Nachbarn  → stirbt (Unterpopulation)
  - 2-3 Nachbarn → lebt weiter
  - >3 Nachbarn  → stirbt (Überpopulation)

Tote Zelle:
  - ==3 Nachbarn → wird lebendig (Reproduktion)
```

**Nachbarn = 8 umliegende Zellen (inkl. Diagonale!)**

```
NW  N  NE
 W  X  E
SW  S  SE
```

---

## 📋 Die 6 Funktionen

| Funktion | Was? |
|----------|------|
| `init_game()` | malloc Board, init Variablen |
| `fill_board()` | stdin lesen, Commands ausführen |
| `count_neighbors()` | 8 Nachbarn zählen |
| `play()` | 1 Game-of-Life Iteration |
| `print_board()` | putchar Output |
| `free_board()` | Cleanup |

---

## ⚡ Quick Pattern

### 1. Struct

```c
typedef struct s_game {
    int width, height, iterations;
    char alive, dead;
    int i, j;       // Stift-Position
    int draw;       // Zeichnen aktiv?
    char** board;   // 2D Array
} t_game;
```

### 2. Init (malloc 2D Array)

```c
int init_game(t_game* g, char* argv[]) {
    g->width = atoi(argv[1]);
    g->height = atoi(argv[2]);
    g->iterations = atoi(argv[3]);
    g->alive = 'O';
    g->dead = ' ';
    g->i = g->j = g->draw = 0;
    
    g->board = malloc(g->height * sizeof(char*));
    if (!g->board) return -1;
    
    for (int i = 0; i < g->height; i++) {
        g->board[i] = malloc(g->width * sizeof(char));
        if (!g->board[i]) {
            free_board(g);
            return -1;
        }
        for (int j = 0; j < g->width; j++)
            g->board[i][j] = ' ';
    }
    return 0;
}
```

### 3. Fill (stdin Commands)

```c
void fill_board(t_game* g) {
    char c;
    while (read(STDIN_FILENO, &c, 1) == 1) {
        if (c == 'w' && g->i > 0) g->i--;
        else if (c == 's' && g->i < g->height - 1) g->i++;
        else if (c == 'a' && g->j > 0) g->j--;
        else if (c == 'd' && g->j < g->width - 1) g->j++;
        else if (c == 'x') g->draw = !g->draw;
        
        if (g->draw)
            g->board[g->i][g->j] = g->alive;
    }
}
```

### 4. Count Neighbors (8 Zellen)

```c
int count_neighbors(t_game* g, int y, int x) {
    int count = 0;
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            if (dy == 0 && dx == 0) continue;  // Skip self
            
            int ny = y + dy, nx = x + dx;
            if (ny >= 0 && ny < g->height && 
                nx >= 0 && nx < g->width) {
                if (g->board[ny][nx] == g->alive)
                    count++;
            }
        }
    }
    return count;
}
```

### 5. Play (Game of Life)

```c
int play(t_game* g) {
    // Temp Board malloc
    char** temp = malloc(g->height * sizeof(char*));
    if (!temp) return -1;
    for (int i = 0; i < g->height; i++) {
        temp[i] = malloc(g->width * sizeof(char));
        if (!temp[i]) { /* cleanup */ return -1; }
    }
    
    // Apply rules
    for (int i = 0; i < g->height; i++) {
        for (int j = 0; j < g->width; j++) {
            int n = count_neighbors(g, i, j);
            
            if (g->board[i][j] == g->alive) {
                // Lebend: 2-3 → lebt, sonst stirbt
                temp[i][j] = (n == 2 || n == 3) ? g->alive : g->dead;
            } else {
                // Tot: ==3 → lebt, sonst tot
                temp[i][j] = (n == 3) ? g->alive : g->dead;
            }
        }
    }
    
    free_board(g);
    g->board = temp;
    return 0;
}
```

### 6. Print & Free

```c
void print_board(t_game* g) {
    for (int i = 0; i < g->height; i++) {
        for (int j = 0; j < g->width; j++)
            putchar(g->board[i][j]);
        putchar('\n');
    }
}

void free_board(t_game* g) {
    if (g->board) {
        for (int i = 0; i < g->height; i++)
            if (g->board[i]) free(g->board[i]);
        free(g->board);
    }
}
```

### 7. Main

```c
int main(int argc, char* argv[]) {
    if (argc != 4) return 1;
    
    t_game game;
    if (init_game(&game, argv) == -1) return 1;
    
    fill_board(&game);
    
    for (int i = 0; i < game.iterations; i++)
        if (play(&game) == -1) {
            free_board(&game);
            return 1;
        }
    
    print_board(&game);
    free_board(&game);
    return 0;
}
```

---

## 🔥 Häufige Fehler

❌ **Vergessen draw zu prüfen** → zeichnet immer  
❌ **Nach w/a/s/d nicht zeichnen** → nur bei x zeichnen  
❌ **Nur 4 Nachbarn** → Diagonale vergessen!  
❌ **(0,0) nicht skippen** → zählt Zelle selbst  
❌ **Kein temp Board** → Zellen beeinflussen sich  
❌ **printf statt putchar** → falsche Funktion  

---

## ✅ Exam Checklist

- [ ] argc == 4 geprüft?
- [ ] Board mit ' ' init?
- [ ] x togglet draw?
- [ ] Bounds gecheckt (w/a/s/d)?
- [ ] 8 Nachbarn (inkl. Diagonale)?
- [ ] (0,0) geskipped in count_neighbors?
- [ ] Temp Board in play()?
- [ ] Regeln: 2-3 lebt, ==3 reproduziert?
- [ ] putchar (nicht printf)?
- [ ] free_board aufgerufen?

---

## 🧪 Test

```bash
echo 'dxss' | ./life 3 3 0
# Output:
#  O
#  O
#  O

echo 'dxss' | ./life 3 3 1
# Output:
# 
#  OOO
# 
```

---

## ⏱️ Zeitplan (40 Min)

1. **struct + Header** (5 min)
2. **init_game()** (5 min)
3. **fill_board()** (8 min)
4. **count_neighbors()** (5 min)
5. **play()** (10 min)
6. **print + free + main** (5 min)
7. **Test** (2 min)

---

**Mehr:** Siehe `DIFF_life.c` für detaillierte Erklärungen! 🚀
