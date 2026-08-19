/* **************************************************************************** */
/*                        LIFE - ULTRA KLARE DIFF                               */
/* **************************************************************************** */

/*
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎯 LIFE EXAM - CONWAY'S GAME OF LIFE                      ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  📦 AUFGABE:                                                                 ║
║  ─────────                                                                   ║
║                                                                              ║
║  Implementiere Conway's Game of Life in C!                                  ║
║                                                                              ║
║  ./life width height iterations                                             ║
║                                                                              ║
║  Input: stdin Commands (zeichne mit "Stift"):                               ║
║    w/a/s/d → Stift bewegen (up/left/down/right)                            ║
║    x       → Stift heben/senken (start/stop drawing)                       ║
║                                                                              ║
║  Output: Board nach N Iterationen                                           ║
║    'O' = lebende Zelle                                                      ║
║    ' ' = tote Zelle                                                         ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎮 GAME OF LIFE REGELN:                                                    ║
║  ────────────────────────                                                   ║
║                                                                              ║
║  1. Lebende Zelle mit <2 Nachbarn  → stirbt (Unterpopulation)              ║
║  2. Lebende Zelle mit 2-3 Nachbarn → lebt weiter                           ║
║  3. Lebende Zelle mit >3 Nachbarn  → stirbt (Überpopulation)               ║
║  4. Tote Zelle mit ==3 Nachbarn    → wird lebendig (Reproduktion)          ║
║                                                                              ║
║  Nachbarn = alle 8 umliegenden Zellen (inkl. Diagonale!)                   ║
║                                                                              ║
║     NW  N  NE                                                                ║
║      W  X  E     ← X = Zelle, die wir prüfen                               ║
║     SW  S  SE                                                                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    📖 BEISPIEL VERSTEHEN                                     ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  echo 'sdxddssaaww' | ./life 5 5 0                                          ║
║                                                                              ║
║  Commands:                                                                   ║
║  ─────────                                                                   ║
║  s   → runter (0,0) → (1,0)                                                 ║
║  d   → rechts (1,0) → (1,1)                                                 ║
║  x   → Stift SENKEN (start drawing!)                                        ║
║  d   → rechts + zeichne (1,1) → (1,2)  ← O                                 ║
║  d   → rechts + zeichne (1,2) → (1,3)  ← O                                 ║
║  s   → runter + zeichne (1,3) → (2,3)  ← O                                 ║
║  s   → runter + zeichne (2,3) → (3,3)  ← O                                 ║
║  a   → links  + zeichne (3,3) → (3,2)  ← O                                 ║
║  a   → links  + zeichne (3,2) → (3,1)  ← O                                 ║
║  w   → hoch   + zeichne (3,1) → (2,1)  ← O                                 ║
║  w   → hoch   + zeichne (2,1) → (1,1)  ← O                                 ║
║                                                                              ║
║  Ergebnis (Board 5x5, 0 Iterationen):                                       ║
║  ─────────                                                                   ║
║       0 1 2 3 4                                                              ║
║     ┌─────────────                                                          ║
║   0 │                                                                        ║
║   1 │   O O O                                                                ║
║   2 │   O   O                                                                ║
║   3 │   O O O                                                                ║
║   4 │                                                                        ║
║                                                                              ║
║  Nach 1 Iteration (Regeln anwenden):                                        ║
║  ─────────                                                                   ║
║   - Ecken (z.B. 1,1): 3 Nachbarn → bleibt lebendig                          ║
║   - Mitte (2,2): 8 Nachbarn → stirbt (Überpopulation)                       ║
║   - usw...                                                                   ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    🏗️  STRUCTURE: WIE AUFBAUEN?                             ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ┌────────────────────────────────────────────────────────────────────────┐ ║
║  │ 1. STRUCT definieren                                                   │ ║
║  ├────────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                        │ ║
║  │  typedef struct s_game {                                               │ ║
║  │      int width;         // Board-Breite                               │ ║
║  │      int height;        // Board-Höhe                                 │ ║
║  │      int iterations;    // Anzahl Game-of-Life Zyklen                 │ ║
║  │      char alive;        // Zeichen für lebend ('O')                   │ ║
║  │      char dead;         // Zeichen für tot (' ')                      │ ║
║  │      int i, j;          // Stift-Position (y, x)                      │ ║
║  │      int draw;          // Zeichnen aktiv? (0=nein, 1=ja)             │ ║
║  │      char** board;      // 2D Array: board[y][x]                      │ ║
║  │  } t_game;                                                             │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
║  ┌────────────────────────────────────────────────────────────────────────┐ ║
║  │ 2. FUNKTIONEN (5 Kern-Funktionen)                                      │ ║
║  ├────────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                        │ ║
║  │  ① init_game()      → malloc Board, init Variablen                   │ ║
║  │  ② fill_board()     → stdin lesen, Commands ausführen                │ ║
║  │  ③ count_neighbors() → Zähle 8 Nachbarn einer Zelle                  │ ║
║  │  ④ play()           → 1 Game-of-Life Iteration (Regeln anwenden)     │ ║
║  │  ⑤ print_board()    → Board ausgeben (putchar)                       │ ║
║  │  ⑥ free_board()     → Cleanup (free malloc'd memory)                 │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
║  ┌────────────────────────────────────────────────────────────────────────┐ ║
║  │ 3. MAIN FLOW                                                           │ ║
║  ├────────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                        │ ║
║  │  int main(int argc, char* argv[]) {                                   │ ║
║  │      if (argc != 4) return 1;  // width height iterations             │ ║
║  │                                                                        │ ║
║  │      t_game game;                                                      │ ║
║  │      init_game(&game, argv);    // malloc Board                       │ ║
║  │      fill_board(&game);         // Zeichne mit stdin                  │ ║
║  │                                                                        │ ║
║  │      for (int i = 0; i < game.iterations; i++)                        │ ║
║  │          play(&game);            // N Iterationen                     │ ║
║  │                                                                        │ ║
║  │      print_board(&game);         // Ausgabe                           │ ║
║  │      free_board(&game);          // Cleanup                           │ ║
║  │      return 0;                                                         │ ║
║  │  }                                                                     │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 1: init_game()                               ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: Board malloc'en, Variablen initialisieren                      ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  int init_game(t_game* game, char* argv[]) {                                ║
║      // Parse argv                                                           ║
║      game->width = atoi(argv[1]);                                            ║
║      game->height = atoi(argv[2]);                                           ║
║      game->iterations = atoi(argv[3]);                                       ║
║                                                                              ║
║      // Init Variablen                                                       ║
║      game->alive = 'O';         // oder '0' je nach Test                    ║
║      game->dead = ' ';                                                       ║
║      game->i = 0;               // Stift startet bei (0,0)                  ║
║      game->j = 0;                                                            ║
║      game->draw = 0;            // Stift ist gehoben                        ║
║                                                                              ║
║      // ⭐ Malloc 2D Array (board[height][width])                           ║
║      game->board = malloc(game->height * sizeof(char*));                     ║
║      if (!game->board) return -1;                                            ║
║                                                                              ║
║      for (int i = 0; i < game->height; i++) {                               ║
║          game->board[i] = malloc(game->width * sizeof(char));               ║
║          if (!game->board[i]) {                                              ║
║              free_board(game);  // Cleanup bei Fehler!                      ║
║              return -1;                                                      ║
║          }                                                                   ║
║          // Init mit ' ' (tote Zellen)                                      ║
║          for (int j = 0; j < game->width; j++)                              ║
║              game->board[i][j] = ' ';                                        ║
║      }                                                                       ║
║      return 0;                                                               ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - board[y][x] → y = Zeile (height), x = Spalte (width)                    ║
║  - Immer mit ' ' (Leerzeichen) initialisieren                               ║
║  - Error-Handling: Wenn malloc feilt → cleanup + return -1                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 2: fill_board()                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: stdin Commands lesen, Stift bewegen, zeichnen                  ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  void fill_board(t_game* game) {                                             ║
║      char buffer;                                                            ║
║                                                                              ║
║      // ⭐ Lies stdin byte-by-byte                                           ║
║      while (read(STDIN_FILENO, &buffer, 1) == 1) {                           ║
║          switch (buffer) {                                                   ║
║          case 'w':  // Hoch                                                  ║
║              if (game->i > 0)                                                ║
║                  game->i--;                                                  ║
║              break;                                                          ║
║          case 's':  // Runter                                                ║
║              if (game->i < game->height - 1)                                 ║
║                  game->i++;                                                  ║
║              break;                                                          ║
║          case 'a':  // Links                                                 ║
║              if (game->j > 0)                                                ║
║                  game->j--;                                                  ║
║              break;                                                          ║
║          case 'd':  // Rechts                                                ║
║              if (game->j < game->width - 1)                                  ║
║                  game->j++;                                                  ║
║              break;                                                          ║
║          case 'x':  // Toggle drawing                                        ║
║              game->draw = !game->draw;                                       ║
║              break;                                                          ║
║          default:                                                            ║
║              continue;  // Ignoriere andere Zeichen                         ║
║          }                                                                   ║
║                                                                              ║
║          // ⭐ Zeichne wenn draw aktiv                                       ║
║          if (game->draw)                                                     ║
║              game->board[game->i][game->j] = game->alive;                    ║
║      }                                                                       ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - read() von STDIN_FILENO (oder 0)                                         ║
║  - Bounds-Check: 0 <= i < height, 0 <= j < width                            ║
║  - 'x' togglet draw (0→1→0→1...)                                            ║
║  - Nach JEDEM Command (auch w/a/s/d) zeichnen wenn draw==1!                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 3: count_neighbors()                         ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: Zähle alle 8 Nachbarn (inkl. Diagonale!)                       ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  int count_neighbors(t_game* game, int y, int x) {                          ║
║      int count = 0;                                                          ║
║                                                                              ║
║      // ⭐ Loop durch alle 8 Nachbarn                                        ║
║      for (int dy = -1; dy <= 1; dy++) {         // -1, 0, +1                ║
║          for (int dx = -1; dx <= 1; dx++) {     // -1, 0, +1                ║
║              // Skip die Zelle selbst                                       ║
║              if (dy == 0 && dx == 0)                                         ║
║                  continue;                                                   ║
║                                                                              ║
║              int ny = y + dy;                                                ║
║              int nx = x + dx;                                                ║
║                                                                              ║
║              // ⭐ Bounds-Check (außerhalb = tot)                            ║
║              if (ny >= 0 && ny < game->height &&                             ║
║                  nx >= 0 && nx < game->width) {                              ║
║                  if (game->board[ny][nx] == game->alive)                     ║
║                      count++;                                                ║
║              }                                                               ║
║          }                                                                   ║
║      }                                                                       ║
║      return count;                                                           ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - dy, dx von -1 bis +1 → 3×3 Grid                                          ║
║  - Skip (0,0) → die Zelle selbst                                            ║
║  - Zellen außerhalb des Boards = tot (zählen nicht)                         ║
║  - Diagonale ZÄHLEN! (NW, NE, SW, SE)                                       ║
║                                                                              ║
║  Visualisierung:                                                             ║
║  ─────────────                                                               ║
║     (y-1,x-1) (y-1,x) (y-1,x+1)     NW  N  NE                               ║
║     (y,  x-1) (y,  x) (y,  x+1)  →  W  X  E                                 ║
║     (y+1,x-1) (y+1,x) (y+1,x+1)     SW  S  SE                               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 4: play()                                    ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: 1 Game-of-Life Iteration (Regeln anwenden)                     ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  int play(t_game* game) {                                                    ║
║      // ⭐ Temp Board malloc (änderungen erst am Ende!)                      ║
║      char** temp = malloc(game->height * sizeof(char*));                     ║
║      if (!temp) return -1;                                                   ║
║                                                                              ║
║      for (int i = 0; i < game->height; i++) {                               ║
║          temp[i] = malloc(game->width * sizeof(char));                       ║
║          if (!temp[i]) {                                                     ║
║              // Cleanup temp bei Fehler                                     ║
║              for (int k = 0; k < i; k++)                                     ║
║                  free(temp[k]);                                              ║
║              free(temp);                                                     ║
║              return -1;                                                      ║
║          }                                                                   ║
║      }                                                                       ║
║                                                                              ║
║      // ⭐ Game of Life Regeln anwenden                                      ║
║      for (int i = 0; i < game->height; i++) {                               ║
║          for (int j = 0; j < game->width; j++) {                            ║
║              int neighbors = count_neighbors(game, i, j);                    ║
║                                                                              ║
║              if (game->board[i][j] == game->alive) {                         ║
║                  // Lebende Zelle                                           ║
║                  if (neighbors == 2 || neighbors == 3)                       ║
║                      temp[i][j] = game->alive;  // Überlebt                 ║
║                  else                                                        ║
║                      temp[i][j] = game->dead;   // Stirbt                   ║
║              }                                                               ║
║              else {                                                          ║
║                  // Tote Zelle                                              ║
║                  if (neighbors == 3)                                         ║
║                      temp[i][j] = game->alive;  // Reproduktion             ║
║                  else                                                        ║
║                      temp[i][j] = game->dead;   // Bleibt tot               ║
║              }                                                               ║
║          }                                                                   ║
║      }                                                                       ║
║                                                                              ║
║      // ⭐ Ersetze altes Board mit neuem                                     ║
║      free_board(game);                                                       ║
║      game->board = temp;                                                     ║
║      return 0;                                                               ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - TEMP Board nötig! Sonst beeinflussen sich Änderungen gegenseitig         ║
║  - Game of Life Regeln:                                                     ║
║    • Lebendig + 2-3 Nachbarn → lebt                                         ║
║    • Lebendig + andere → stirbt                                             ║
║    • Tot + genau 3 Nachbarn → wird lebendig                                 ║
║    • Tot + andere → bleibt tot                                              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 5: print_board() & free_board()              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: Board ausgeben + Memory freigeben                              ║
║                                                                              ║
║  CODE: print_board()                                                         ║
║  ──────────────────                                                          ║
║                                                                              ║
║  void print_board(t_game* game) {                                            ║
║      for (int i = 0; i < game->height; i++) {                               ║
║          for (int j = 0; j < game->width; j++) {                            ║
║              putchar(game->board[i][j]);  // ⭐ putchar statt printf!       ║
║          }                                                                   ║
║          putchar('\n');  // Zeilenumbruch                                   ║
║      }                                                                       ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG: putchar! Nicht printf/write                                    ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  CODE: free_board()                                                          ║
║  ──────────────────                                                          ║
║                                                                              ║
║  void free_board(t_game* game) {                                             ║
║      if (game->board) {                                                      ║
║          for (int i = 0; i < game->height; i++) {                           ║
║              if (game->board[i])                                             ║
║                  free(game->board[i]);  // Free jede Zeile                  ║
║          }                                                                   ║
║          free(game->board);  // Free Array-Pointer                          ║
║      }                                                                       ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - Erst Zeilen free'en, DANN Array selbst                                   ║
║  - Null-Checks wichtig (falls malloc failed)                                ║
║  - Wird in init_game UND play aufgerufen                                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎓 EXAM CHEAT SHEET                                       ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ⏱️  ZEITPLAN (~30-40 Min):                                                 ║
║  ─────────────────────                                                      ║
║                                                                              ║
║  1. struct + Header      (5 min)  → life.h mit t_game                      ║
║  2. init_game()          (5 min)  → malloc Board                           ║
║  3. fill_board()         (8 min)  → stdin Commands                         ║
║  4. count_neighbors()    (5 min)  → 8 Nachbarn zählen                      ║
║  5. play()               (10 min) → Game of Life Regeln                    ║
║  6. print + free + main  (5 min)  → Output + Cleanup                       ║
║  7. Test & Debug         (5 min)  → Lokales Testen                         ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🎯 DIE 4 GAME OF LIFE REGELN (auswendig können!):                          ║
║  ────────────────────────────────────────────────                           ║
║                                                                              ║
║  if (alive) {                                                                ║
║      if (neighbors == 2 || neighbors == 3) → lebt                           ║
║      else → stirbt                                                           ║
║  }                                                                           ║
║  else {  // tot                                                              ║
║      if (neighbors == 3) → wird lebendig                                    ║
║      else → bleibt tot                                                       ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🔥 HÄUFIGE FEHLER:                                                          ║
║  ─────────────                                                               ║
║                                                                              ║
║  ❌ Vergessen draw zu prüfen → zeichnet auch wenn Stift gehoben             ║
║  ❌ Nach Movement zeichnen vergessen (nur bei x zeichnen)                   ║
║  ❌ Diagonale Nachbarn nicht zählen → nur 4 statt 8                         ║
║  ❌ (dy==0 && dx==0) nicht skippen → zählt Zelle selbst                     ║
║  ❌ Kein temp Board → Zellen beeinflussen sich gegenseitig                  ║
║  ❌ printf statt putchar → falsche Funktion                                 ║
║  ❌ Memory Leaks → free_board vergessen                                     ║
║  ❌ Bounds nicht checken → Segfault                                         ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  ✅ CHECKLIST VOR SUBMIT:                                                   ║
║  ────────────────────                                                       ║
║                                                                              ║
║  □ argc == 4 geprüft?                                                       ║
║  □ Board mit ' ' initialisiert?                                             ║
║  □ draw toggle funktioniert (x)?                                            ║
║  □ Bounds gecheckt (w/a/s/d)?                                               ║
║  □ 8 Nachbarn gezählt (inkl. Diagonale)?                                    ║
║  □ (0,0) Skip in count_neighbors?                                           ║
║  □ Temp Board in play()?                                                    ║
║  □ Game of Life Regeln richtig?                                             ║
║  □ putchar (nicht printf)?                                                  ║
║  □ free_board aufgerufen?                                                   ║
║  □ Lokal getestet?                                                          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    🧪 TEST BEISPIELE                                         ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  echo 'dxss' | ./life 3 3 0                                                 ║
║  ─────────────────────────────                                              ║
║  d   → rechts zu (0,1)                                                      ║
║  x   → Stift senken                                                         ║
║  s   → runter + zeichne (1,1)                                               ║
║  s   → runter + zeichne (2,1)                                               ║
║                                                                              ║
║  Output:                                                                     ║
║     O                                                                        ║
║     O                                                                        ║
║     O                                                                        ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  echo 'dxss' | ./life 3 3 1                                                 ║
║  ─────────────────────────────                                              ║
║  Gleicher Start, aber 1 Iteration:                                          ║
║                                                                              ║
║  (0,1): 1 Nachbar → stirbt                                                  ║
║  (1,1): 2 Nachbarn → lebt                                                   ║
║  (2,1): 1 Nachbar → stirbt                                                  ║
║  (0,0), (0,2): je 2 Nachbarn → werden lebendig                              ║
║  (1,0), (1,2): je 3 Nachbarn → werden lebendig                              ║
║  (2,0), (2,2): je 2 Nachbarn → werden lebendig                              ║
║                                                                              ║
║  Output:                                                                     ║
║                                                                              ║
║     OOO                                                                      ║
║                                                                              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    💡 DEBUGGING TIPPS                                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Problem: Falsches Output nach fill_board                                   ║
║  Lösung: Print Board nach fill_board (vor iterations)                       ║
║          → Sieh ob Zeichnen richtig funktioniert                            ║
║                                                                              ║
║  Problem: Segfault                                                           ║
║  Lösung: Bounds-Checks! Alle i,j,ny,nx prüfen                               ║
║          → 0 <= i < height, 0 <= j < width                                  ║
║                                                                              ║
║  Problem: Falsche Nachbarn-Zahl                                             ║
║  Lösung: Debugge count_neighbors:                                           ║
║          → printf("(%d,%d): %d neighbors\n", y, x, count);                  ║
║          → Checke ob Diagonale gezählt werden                               ║
║          → Checke ob (0,0) geskipped wird                                   ║
║                                                                              ║
║  Problem: Alle Zellen sterben nach 1 Iteration                              ║
║  Lösung: Temp Board? Oder Game-of-Life Regeln falsch?                       ║
║          → 2 ODER 3 Nachbarn → lebt (nicht nur 2!)                          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
*/
