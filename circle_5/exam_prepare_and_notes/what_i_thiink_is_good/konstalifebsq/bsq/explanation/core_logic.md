# BSQ (Biggest Square) - Simple Explanation

## What is the Goal?

Imagine you have a grid/map with:
- **Empty spaces** (where you can build)
- **Obstacles** (rocks, walls, things you can't use)

Your job is to **find the biggest square area that has NO obstacles** and **mark it**.

## Example

Let's say you have this map (`.` = empty, `#` = obstacle):

```
. . . . .
. . . # .
. . . . .
. . . . .
```

The algorithm will find the biggest square of empty spaces and fill it with something (like `X`):

```
X X X . .
X X X . .
X X X . .
. . . . .
```

The biggest square here is **3×3**. It fills positions from row 0-2, column 0-2.

---

## How Does the Solution Work?

### Step 1: Parse the Input
The program reads a special format:
- **First line**: `[number of rows][empty char][obstacle char][fill char]`
  - Example: `5.#X` means 5 rows, `.` is empty, `#` is obstacle, `X` is fill character
- **Next lines**: The actual map with empty cells and obstacles

### Step 2: The Smart Algorithm (Dynamic Programming)

This is the **core magic**. Instead of checking every possible square (which would be slow), we use a trick:

**The DP Table Idea:**
- Create a number table (same size as the map)
- For each cell, store: "What's the biggest square with this cell at the bottom-right corner?"

**Example:**

Original map:
```
. . .
. . .
. . .
```

DP table after processing:
```
1 1 1
1 2 2
1 2 3
```

What does this mean?
- `dp[0][0] = 1`: At top-left, biggest square is 1×1
- `dp[1][1] = 2`: At middle, biggest square is 2×2
- `dp[2][2] = 3`: At bottom-right, biggest square is 3×3

### Step 3: The DP Formula

For each empty cell at position `(i, j)`:

```
If there's an obstacle: dp[i][j] = 0

If it's in first row or column: dp[i][j] = 1

Otherwise: dp[i][j] = 1 + min(
                        dp[i-1][j],      // square above
                        dp[i][j-1],      // square to the left
                        dp[i-1][j-1]     // square diagonally
                      )
```

**Why does this work?**

Think of it like building blocks:
- If you have a 2×2 square above, a 2×2 to the left, and a 2×2 diagonally, you can make a 3×3 square!
- The `min()` finds the limiting factor (the smallest square among the three neighbors)

### Step 4: Track the Best Square

As you calculate, remember:
- What's the **biggest size** found?
- Where is it **located** (the bottom-right corner)?

### Step 5: Fill It In

Once you know where the biggest square is, fill all cells in that square with the fill character.

---

## Code Flow (Simplified)

```
1. Read first line → get rows, empty char, obstacle char, fill char
2. Read the map → store it in a 2D array
3. Create DP table and fill it:
   - For each cell in the map:
     - If obstacle → dp[i][j] = 0
     - If first row/column → dp[i][j] = 1
     - Otherwise → dp[i][j] = 1 + min(above, left, diagonal)
     - Track if this is the biggest so far
4. Fill the biggest square with the fill character
5. Print the result
```

---

## Real-World Analogy

**Think of it like finding a parking lot:**

You have a city grid with buildings (obstacles) and empty spaces.
You need to find the biggest square plot of land to build a shopping mall.

Instead of checking every possible square (which takes forever), you:
1. Walk through each corner of the city
2. Ask: "If I put the corner of a square here, how big can it be?"
3. Remember the best location
4. Build the mall there!

---

## Key Insight

**The real cleverness is the DP table:**
- Instead of recalculating from scratch, you **reuse** information from cells you already checked
- This makes it **fast** (O(rows × cols) time, not slower)
- That's why it's called **dynamic programming** - you build the solution step by step, reusing previous work

---

## Time & Space Complexity

- **Time**: O(rows × cols) - you visit each cell once
- **Space**: O(rows × cols) - for the DP table
- **Much faster** than checking every possible square!
