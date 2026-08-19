/* **************************************************************************** */
/*                        BSQ - ULTRA KLARE DIFF                                */
/* **************************************************************************** */

/*
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎯 BSQ EXAM - BIGGEST SQUARE                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  📦 AUFGABE:                                                                 ║
║  ─────────                                                                   ║
║                                                                              ║
║  Finde das größte leere Quadrat in einer Map und fülle es!                  ║
║                                                                              ║
║  ./bsq [file]    → Mit Datei                                                ║
║  ./bsq           → stdin                                                    ║
║                                                                              ║
║  Input Format:                                                               ║
║    Zeile 1:  "n_lines empty obstacle full"  (durch Space getrennt)          ║
║    Zeile 2+: Die Map (nur empty und obstacle Zeichen!)                      ║
║                                                                              ║
║  Beispiel:                                                                   ║
║    "5 . o f"    → 5 Zeilen, '.' = leer, 'o' = Hindernis, 'f' = füllen     ║
║                                                                              ║
║  Output: Map mit größtem Quadrat gefüllt (empty → full)                    ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🔑 DER KERN-ALGORITHMUS: Dynamic Programming                               ║
║  ─────────────────────────────────────────────                              ║
║                                                                              ║
║  dp[i][j] = Seitenlänge des größten Quadrats,                              ║
║             dessen untere-rechte Ecke bei (i,j) liegt                       ║
║                                                                              ║
║  Regel:                                                                      ║
║    ① Hindernis:             dp[i][j] = 0                                    ║
║    ② Erste Zeile ODER Spalte: dp[i][j] = 1  (wenn kein Hindernis)          ║
║    ③ Sonst:                                                                  ║
║       dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1            ║
║                      oben         links        diagonal                     ║
║                                                                              ║
║  Warum min()? Das Quadrat ist so groß wie das KLEINSTE der 3 Teilquadrate! ║
║                                                                              ║
║  Visualisierung für dp[i][j]:                                               ║
║     ┌─────┬──┐                                                               ║
║     │ NW  │ N│   dp[i-1][j-1]  dp[i-1][j]                                  ║
║     ├─────┼──┤                                                               ║
║     │  W  │ X│   dp[i][j-1]    dp[i][j]  ← wir berechnen das               ║
║     └─────┴──┘                                                               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    📖 BEISPIEL VERSTEHEN                                     ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Input:                                                                      ║
║    6 . o f                                                                   ║
║    ......                                                                    ║
║    ......                                                                    ║
║    ..oo..                                                                    ║
║    ......                                                                    ║
║    ......                                                                    ║
║    ......                                                                    ║
║                                                                              ║
║  dp-Matrix:                                                                  ║
║    1 1 1 1 1 1                                                               ║
║    1 2 2 2 2 2                                                               ║
║    1 2 0 0 2 2                                                               ║
║    1 2 1 1 2 2                                                               ║
║    1 2 2 2 3 3                                                               ║
║    1 2 2 2 3 4  ← dp[5][5] = 4 → größtes Quadrat hat Größe 4!             ║
║                                                                              ║
║  Position des Quadrats:                                                      ║
║    row = 5 - 4 + 1 = 2                                                      ║
║    col = 5 - 4 + 1 = 2                                                      ║
║    → Quadrat startet bei (2, 2), Größe 4×4                                 ║
║                                                                              ║
║  Output: (f = gefüllt)                                                       ║
║    ......                                                                    ║
║    ......                                                                    ║
║    ..oo..                                                                    ║
║    ..ffff                                                                    ║
║    ..ffff                                                                    ║
║    ..ffff  ← Nein, Hindernis verhindert größeres Quadrat!                  ║
║                                                                              ║
║  💡 Korrekte Ausgabe zeigt das größte hindernisfreie Quadrat gefüllt.      ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    🏗️  STRUCTURE: WIE AUFBAUEN?                             ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ┌────────────────────────────────────────────────────────────────────────┐ ║
║  │ 1. STRUCTS definieren                                                  │ ║
║  ├────────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                        │ ║
║  │  typedef struct s_elements {                                           │ ║
║  │      int  n_lines;    // Anzahl Zeilen aus Header                     │ ║
║  │      char empty;      // Zeichen für leere Zelle (z.B. '.')           │ ║
║  │      char obstacle;   // Zeichen für Hindernis  (z.B. 'o')           │ ║
║  │      char full;       // Zeichen zum Füllen     (z.B. 'f')           │ ║
║  │  } t_elements;                                                         │ ║
║  │                                                                        │ ║
║  │  typedef struct s_map {                                                │ ║
║  │      char **grid;     // 2D Grid: grid[y][x]                          │ ║
║  │      int  width;      // Breite (aus erster Map-Zeile)                │ ║
║  │      int  height;     // Höhe (= n_lines)                             │ ║
║  │  } t_map;                                                              │ ║
║  │                                                                        │ ║
║  │  typedef struct s_square {                                             │ ║
║  │      int size;        // Seitenlänge des größten Quadrats             │ ║
║  │      int row;         // Startzeile (oben-links)                      │ ║
║  │      int col;         // Startspalte (oben-links)                     │ ║
║  │  } t_square;                                                           │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
║  ┌────────────────────────────────────────────────────────────────────────┐ ║
║  │ 2. FUNKTIONEN                                                          │ ║
║  ├────────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                        │ ║
║  │  ① load_elements()   → Header parsen (fscanf)                        │ ║
║  │  ② load_map()        → Zeilen lesen (getline), Map validieren        │ ║
║  │  ③ solve()           → DP-Matrix aufbauen, Quadrat finden+füllen     │ ║
║  │  ④ free_map()        → Cleanup (free malloc'd memory)                │ ║
║  │  ⑤ execute_bsq()    → Orchestrierung: alles zusammen                │ ║
║  │  ⑥ main()           → argc prüfen, FILE öffnen                      │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
║  ┌────────────────────────────────────────────────────────────────────────┐ ║
║  │ 3. MAIN FLOW                                                           │ ║
║  ├────────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                        │ ║
║  │  int main(int argc, char* argv[]) {                                   │ ║
║  │      if (argc == 1)                                                    │ ║
║  │          execute_bsq(stdin);                                           │ ║
║  │      else if (argc == 2) {                                             │ ║
║  │          FILE *f = fopen(argv[1], "r");                               │ ║
║  │          if (!f) return 1;                                             │ ║
║  │          execute_bsq(f);                                               │ ║
║  │          fclose(f);                                                    │ ║
║  │      }                                                                 │ ║
║  │      else return 1;                                                    │ ║
║  │      return 0;                                                         │ ║
║  │  }                                                                     │ ║
║  │                                                                        │ ║
║  └────────────────────────────────────────────────────────────────────────┘ ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 1: load_elements()                           ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: Erste Zeile parsen → n_lines, empty, obstacle, full            ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  int load_elements(FILE *file, t_elements *el) {                            ║
║      int ret = fscanf(file, "%d %c %c %c",                                  ║
║                  &el->n_lines, &el->empty, &el->obstacle, &el->full);       ║
║                                                                              ║
║      if (ret != 4 || el->n_lines <= 0)                                      ║
║          return -1;                                                          ║
║                                                                              ║
║      // Alle 3 Zeichen müssen verschieden sein                              ║
║      if (el->empty == el->obstacle || el->empty == el->full                 ║
║          || el->obstacle == el->full)                                        ║
║          return -1;                                                          ║
║                                                                              ║
║      // Alle müssen druckbare ASCII-Zeichen sein (>= 32)                    ║
║      if (el->empty < 32 || el->obstacle < 32 || el->full < 32)             ║
║          return -1;                                                          ║
║                                                                              ║
║      // ⭐ Rest der Header-Zeile konsumieren (das '\n' überspringen!)       ║
║      char *line = NULL;                                                      ║
║      size_t cap = 0;                                                         ║
║      if (getline(&line, &cap, file) == -1) {                                ║
║          free(line);                                                         ║
║          return -1;                                                          ║
║      }                                                                       ║
║      free(line);                                                             ║
║      return 0;                                                               ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - fscanf liest "%d %c %c %c" → stoppt VOR dem '\n'                        ║
║  - Danach MUSS getline() aufgerufen werden, sonst liest load_map() den      ║
║    Rest der Header-Zeile als erste Map-Zeile!                               ║
║  - ret == 4 checken (nicht mehr, nicht weniger)                             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 2: load_map()                                ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: Map-Zeilen lesen, validieren, in grid speichern                ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  int load_map(FILE *file, t_map *map, t_elements *el) {                     ║
║      map->height = el->n_lines;                                              ║
║      map->width = -1;                                                        ║
║      map->grid = malloc((map->height + 1) * sizeof(char *));                 ║
║      if (!map->grid) return -1;                                              ║
║      map->grid[map->height] = NULL;  // NULL-Terminierung!                  ║
║                                                                              ║
║      for (int i = 0; i < map->height; i++) {                                ║
║          char *line = NULL;                                                  ║
║          size_t cap = 0;                                                     ║
║          ssize_t n = getline(&line, &cap, file);                             ║
║                                                                              ║
║          if (n <= 0) { free(line); map->height = i; free_map(map); return -1; }║
║                                                                              ║
║          // ⭐ '\n' am Ende entfernen                                        ║
║          int len = (int)n;                                                   ║
║          if (len > 0 && line[len - 1] == '\n')                               ║
║              line[--len] = '\0';                                             ║
║                                                                              ║
║          if (len == 0) { free(line); map->height = i; free_map(map); return -1; }║
║                                                                              ║
║          // ⭐ Breite der ersten Zeile merken, danach vergleichen           ║
║          if (map->width < 0)                                                 ║
║              map->width = len;                                               ║
║          else if (len != map->width) {                                       ║
║              free(line); map->height = i; free_map(map); return -1;         ║
║          }                                                                   ║
║                                                                              ║
║          // ⭐ Nur empty und obstacle erlaubt!                               ║
║          for (int j = 0; j < len; j++) {                                    ║
║              if (line[j] != el->empty && line[j] != el->obstacle) {         ║
║                  free(line); map->height = i; free_map(map); return -1;     ║
║              }                                                               ║
║          }                                                                   ║
║          map->grid[i] = line;                                                ║
║      }                                                                       ║
║      return 0;                                                               ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - grid hat height+1 Einträge → letzter ist NULL (für free_map loop)       ║
║  - map->height MUSS vor free_map gesetzt werden (free_map braucht es!)      ║
║  - Breiten-Check: alle Zeilen müssen gleich breit sein                      ║
║  - Zeichen-Check: nur empty und obstacle erlaubt (kein full!)               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 3: solve() — Der DP-Algorithmus              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  🎯 Aufgabe: DP-Matrix aufbauen, größtes Quadrat finden, füllen             ║
║                                                                              ║
║  CODE:                                                                       ║
║  ────                                                                        ║
║                                                                              ║
║  void solve(t_map *map, t_elements *el) {                                   ║
║      // ⭐ DP-Matrix malloc (int**)                                          ║
║      int **dp = malloc(map->height * sizeof(int *));                         ║
║      if (!dp) return;                                                        ║
║      for (int i = 0; i < map->height; i++)                                  ║
║          dp[i] = calloc(map->width, sizeof(int));  // calloc → alles 0!    ║
║                                                                              ║
║      // Quadrat-Tracking                                                     ║
║      t_square sq = {0, 0, 0};  // size=0, row=0, col=0                     ║
║                                                                              ║
║      // ⭐ DP-Matrix füllen                                                  ║
║      for (int i = 0; i < map->height; i++) {                                ║
║          for (int j = 0; j < map->width; j++) {                             ║
║              if (map->grid[i][j] == el->obstacle)                            ║
║                  dp[i][j] = 0;                                               ║
║              else if (i == 0 || j == 0)                                      ║
║                  dp[i][j] = 1;                                               ║
║              else                                                            ║
║                  dp[i][j] = min3(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1;║
║                                                                              ║
║              // ⭐ Ist das aktuell größte Quadrat?                          ║
║              if (dp[i][j] > sq.size) {                                       ║
║                  sq.size = dp[i][j];                                         ║
║                  sq.row = i - dp[i][j] + 1;  // obere-linke Ecke!          ║
║                  sq.col = j - dp[i][j] + 1;                                 ║
║              }                                                               ║
║          }                                                                   ║
║      }                                                                       ║
║                                                                              ║
║      // ⭐ Quadrat in grid füllen                                            ║
║      for (int i = sq.row; i < sq.row + sq.size; i++)                        ║
║          for (int j = sq.col; j < sq.col + sq.size; j++)                    ║
║              map->grid[i][j] = el->full;                                     ║
║                                                                              ║
║      // ⭐ DP-Matrix free'en                                                 ║
║      for (int i = 0; i < map->height; i++)                                  ║
║          free(dp[i]);                                                        ║
║      free(dp);                                                               ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG:                                                                 ║
║  ─────────                                                                   ║
║  - dp[i][j] speichert die Größe des UNTEREN-RECHTEN Eckpunkts               ║
║  - Startposition: row = i - size + 1  (nicht einfach i!)                   ║
║  - calloc() statt malloc() → initialisiert alles mit 0                     ║
║  - min3(oben, links, diagonal) + 1                                          ║
║                                                                              ║
║  Warum row = i - size + 1?                                                  ║
║  ─────────────────────────                                                  ║
║  dp[4][5] = 3 bedeutet: Quadrat 3×3 endet bei Zeile 4                      ║
║  Startzeile = 4 - 3 + 1 = 2 ✓                                              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    ✍️  FUNKTION 4: free_map() + execute_bsq()               ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  CODE: free_map()                                                            ║
║  ──────────────                                                              ║
║                                                                              ║
║  void free_map(t_map *map) {                                                 ║
║      if (map->grid) {                                                        ║
║          for (int i = 0; i < map->height; i++) {                            ║
║              if (map->grid[i])                                               ║
║                  free(map->grid[i]);                                         ║
║          }                                                                   ║
║          free(map->grid);                                                    ║
║          map->grid = NULL;                                                   ║
║      }                                                                       ║
║  }                                                                           ║
║                                                                              ║
║  💡 WICHTIG: map->grid = NULL setzen nach free → verhindert double-free!   ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  CODE: execute_bsq()                                                         ║
║  ───────────────────                                                         ║
║                                                                              ║
║  int execute_bsq(FILE *file) {                                               ║
║      t_elements el;                                                          ║
║      t_map map;                                                              ║
║                                                                              ║
║      if (load_elements(file, &el) == -1)                                     ║
║          return -1;                                                          ║
║      if (load_map(file, &map, &el) == -1)                                    ║
║          return -1;                                                          ║
║                                                                              ║
║      solve(&map, &el);                                                       ║
║                                                                              ║
║      // ⭐ Map ausgeben                                                      ║
║      for (int i = 0; i < map.height; i++)                                   ║
║          fprintf(stdout, "%s\n", map.grid[i]);                               ║
║                                                                              ║
║      free_map(&map);                                                         ║
║      return 0;                                                               ║
║  }                                                                           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎓 EXAM CHEAT SHEET                                       ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ⏱️  ZEITPLAN (~30-40 Min):                                                 ║
║  ─────────────────────                                                      ║
║                                                                              ║
║  1. structs + Header       (5 min)  → bsq.h mit 3 Structs                  ║
║  2. load_elements()        (5 min)  → fscanf + getline Flush                ║
║  3. load_map()             (10 min) → getline Loop, Validierung             ║
║  4. solve() + min3()       (10 min) → DP-Matrix, Quadrat finden+füllen     ║
║  5. free_map() + execute() (5 min)  → Cleanup + Ausgabe                    ║
║  6. main()                 (2 min)  → argc, fopen                          ║
║  7. Test & Debug           (5 min)  → Lokales Testen                       ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🎯 DER DP-KERN (auswendig können!):                                        ║
║  ────────────────────────────────                                           ║
║                                                                              ║
║  if (obstacle)       dp[i][j] = 0;                                          ║
║  else if (i==0||j==0) dp[i][j] = 1;                                         ║
║  else                dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1;║
║                                                                              ║
║  if (dp[i][j] > sq.size) {                                                  ║
║      sq.size = dp[i][j];                                                    ║
║      sq.row = i - dp[i][j] + 1;   // ← untere-rechte → obere-linke!       ║
║      sq.col = j - dp[i][j] + 1;                                             ║
║  }                                                                           ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  🔥 HÄUFIGE FEHLER:                                                          ║
║  ─────────────                                                               ║
║                                                                              ║
║  ❌ fscanf Header-Zeile nicht mit getline flushen                           ║
║     → load_map liest Rest der Header-Zeile als Map-Zeile!                  ║
║  ❌ row/col Formel vergessen: i - size + 1 (nicht einfach i)               ║
║  ❌ calloc statt malloc vergessen → dp Matrix nicht genullt                ║
║  ❌ map->height nicht setzen vor free_map bei Error                        ║
║  ❌ grid[height] = NULL vergessen → free_map loop crasht                   ║
║  ❌ Breitencheck fehlt → verschiedene Zeilenlängen = invalid               ║
║  ❌ Zeichenvalidierung fehlt → 'full' in der Map wäre invalid              ║
║  ❌ DP matrix nicht free'en → Memory Leak                                  ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  ✅ CHECKLIST VOR SUBMIT:                                                   ║
║  ────────────────────                                                       ║
║                                                                              ║
║  □ argc == 1 (stdin) oder argc == 2 (file)?                                ║
║  □ fscanf Header korrekt geparst (ret == 4)?                               ║
║  □ Header-Zeile nach fscanf mit getline geflusht?                          ║
║  □ Alle 3 Zeichen verschieden + druckbar?                                  ║
║  □ grid[height] = NULL gesetzt?                                             ║
║  □ map->height vor free_map gesetzt bei Fehler?                            ║
║  □ Breite aller Zeilen gleich?                                              ║
║  □ Nur empty+obstacle erlaubt?                                              ║
║  □ DP: obstacle=0, erste Zeile/Spalte=1, sonst min3+1?                    ║
║  □ Startposition: row = i - size + 1?                                      ║
║  □ Quadrat korrekt gefüllt (grid[i][j] = full)?                            ║
║  □ Ausgabe mit fprintf(stdout, "%s\n")?                                    ║
║  □ free_map + dp free aufgerufen?                                           ║
║  □ Lokal getestet?                                                          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    🧪 TEST BEISPIELE                                         ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Test 1 — einfaches 4x4 ohne Hindernisse:                                  ║
║  ─────────────────────────────────────────                                  ║
║                                                                              ║
║  Input (test.txt):                                                           ║
║    4 . o f                                                                   ║
║    ....                                                                      ║
║    ....                                                                      ║
║    ....                                                                      ║
║    ....                                                                      ║
║                                                                              ║
║  ./bsq test.txt                                                              ║
║                                                                              ║
║  Output:                                                                     ║
║    ffff                                                                      ║
║    ffff                                                                      ║
║    ffff                                                                      ║
║    ffff                                                                      ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  Test 2 — Mit Hindernissen:                                                 ║
║  ───────────────────────────                                                ║
║                                                                              ║
║  Input (test.txt):                                                           ║
║    4 . o f                                                                   ║
║    ....                                                                      ║
║    ..o.                                                                      ║
║    ....                                                                      ║
║    ....                                                                      ║
║                                                                              ║
║  dp-Matrix:                                                                  ║
║    1 1 1 1                                                                   ║
║    1 2 0 1                                                                   ║
║    1 2 1 1                                                                   ║
║    1 2 2 2  ← größtes dp=2 → 2x2 Quadrat                                  ║
║                                                                              ║
║  Output:                                                                     ║
║    ....                                                                      ║
║    ..o.                                                                      ║
║    .ff.                                                                      ║
║    .ff.                                                                      ║
║                                                                              ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║                                                                              ║
║  Test 3 — stdin:                                                             ║
║                                                                              ║
║    printf "3 . o f\n...\n...\n...\n" | ./bsq                               ║
║                                                                              ║
║  Output:                                                                     ║
║    fff                                                                       ║
║    fff                                                                       ║
║    fff                                                                       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


╔══════════════════════════════════════════════════════════════════════════════╗
║                    💡 DEBUGGING TIPPS                                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  Problem: Map wird falsch gelesen (erste Zeile = Header-Rest)               ║
║  Lösung: getline() nach fscanf() einfügen → flush Header-Zeile             ║
║                                                                              ║
║  Problem: Segfault in free_map                                              ║
║  Lösung: map->height vor dem free_map Aufruf korrekt setzen!               ║
║          → map->height = i; free_map(map); return -1;                       ║
║                                                                              ║
║  Problem: Falsches Quadrat (zu groß oder falsche Position)                  ║
║  Lösung: DP-Matrix ausgeben (temporäres Debug-printf)                       ║
║          → printf("%d", dp[i][j]); nach der Berechnung                     ║
║                                                                              ║
║  Problem: Quadrat-Position stimmt nicht                                     ║
║  Lösung: Formel prüfen: row = i - dp[i][j] + 1 (nicht nur i)              ║
║          dp[i][j] gibt untere-rechte Ecke → umrechnen auf oben-links!      ║
║                                                                              ║
║  Problem: Map leer obwohl kein Hindernis                                    ║
║  Lösung: Zeichenvalidierung? full-Zeichen in Map erlaubt?                  ║
║          → Nur empty und obstacle dürfen in der Map vorkommen!              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
*/
