// Include necessary headers for system calls and memory management
#include <unistd.h>  // For read() system call
#include <stdlib.h>  // For malloc(), calloc(), free(), atoi()
#include <stdio.h>   // For putchar() (though not heavily used here)

// Main function: takes command-line arguments (width, height, iterations)
int	main(int ac, char **av)
{
	// Check if exactly 3 arguments were provided (width height iterations)
	if (ac != 4)
		return (1);

	// Parse command-line arguments and convert from strings to integers
	int	width = atoi(av[1]);      // Grid width
	int	height = atoi(av[2]);     // Grid height
	int	iterations = atoi(av[3]); // Number of Game of Life iterations

	// Validate that all dimensions and iterations are non-negative
	if (width < 0 || height < 0 || iterations < 0)
		return (1);

	// Pen state variables
	int	x = 0, y = 0;  // Pen position (0-indexed, starts at top-left)
	int	pen = 0;       // Pen state: 0 = up (not drawing), 1 = down (drawing)
	char	c;          // Character buffer for reading input commands

	// Allocate memory for 2 grids (used for double-buffering in Game of Life)
	// Grid[0] and Grid[1] alternate between current and next generation
	int	***grid = (int ***)malloc(2 * sizeof(int **));
	for (int b = 0; b < 2; b++)
	{
		// Allocate rows for each buffer (height + 2 for padding)
		grid[b] = (int **)malloc((height + 2) * sizeof(int *));
		for (int i = 0; i < height + 2; i++)
		{
			// Allocate columns for each row (width + 2 for padding)
			// calloc initializes all cells to 0 (dead cells)
			grid[b][i] = (int *)calloc(width + 2, sizeof(int));
		}
	}

	// READ INPUT PHASE: Process drawing commands from stdin
	// Commands: 'w' (up), 's' (down), 'a' (left), 'd' (right), 'x' (toggle pen)
	while (read(0, &c, 1) > 0)
	{
		// Move pen up (decrease y, but stay within bounds [0, height-1])
		if (c == 'w' && y > 0)
			y--;
		// Move pen down (increase y, but stay within bounds [0, height-1])
		else if (c == 's' && y < height - 1)
			y++;
		// Move pen left (decrease x, but stay within bounds [0, width-1])
		else if (c == 'a' && x > 0)	
			x--;
		// Move pen right (increase x, but stay within bounds [0, width-1])
		else if (c == 'd' && x < width - 1)
			x++;
		// Toggle pen state (0 = up, 1 = down)
		else if (c == 'x')
			pen = !pen;
		
		// If pen is down, mark the current cell as alive in grid[0]
		// Note: grid uses (y+1, x+1) because of 1-cell padding around the grid
		if (pen)
			grid[0][y + 1][x + 1] = 1;
	}

	// GAME OF LIFE SIMULATION PHASE
	// Apply the Game of Life rules for the specified number of iterations
	for (int it = 0; it < iterations; it++)
	{
		// Double-buffering: alternate between grid[0] and grid[1]
		// cur = current generation, next = next generation to compute
		int	cur = it % 2;      // Current generation (0 or 1)
		int	next = (it + 1) % 2;  // Next generation to compute (opposite of cur)

		// CLEAR PHASE: Reset the next buffer to all zeros (dead cells)
		// This ensures no garbage data carries over from previous iterations
		// Important: this clears the padding cells and the entire grid
		for (int i = 0; i < height + 2; i++)
			for (int j = 0; j < width + 2; j++)
				grid[next][i][j] = 0;

		// COMPUTATION PHASE: Calculate next generation using Game of Life rules
		// Only iterate through the actual grid (indices 1 to height, 1 to width)
		// Skip the padding cells (index 0 and height+1, width+1)
		for (int i = 1; i <= height; i++)
		{
			for (int j = 1; j <= width; j++)
			{
				// COUNT NEIGHBORS: Count live cells in all 8 adjacent cells
				int	n = 0;
				// Check all 8 neighbors (dy and dx range from -1 to 1)
				for (int dy = -1; dy <= 1; dy++)
				{
					for (int dx = -1; dx <= 1; dx++)
						// Skip the center cell (only count neighbors)
						if (dx != 0 || dy != 0)
							n += grid[cur][i + dy][j + dx];
				}
				
				// APPLY GAME OF LIFE RULES:
				// Rule 1: Live cell with 2-3 neighbors survives
				// Rule 2: Dead cell with exactly 3 neighbors becomes alive
				// Rule 3: All other cells die or stay dead
				if (grid[cur][i][j] == 1)
					// Cell is alive: survives only with 2 or 3 neighbors
					grid[next][i][j] = (n == 2 || n == 3);
				else
					// Cell is dead: becomes alive only with exactly 3 neighbors
					grid[next][i][j] = (n == 3);
			}
		}
	}

	// OUTPUT PHASE: Print the final grid state
	// Determine which buffer contains the final state after all iterations
	int	final = iterations % 2;
	for (int i = 1; i <= height; i++)
	{
		for (int j = 1; j <= width; j++)
		{
			// Print 'O' for alive cells, space for dead cells
			if (grid[final][i][j])
				putchar('O');
			else
				putchar(' ');
		}
		// Print newline at end of each row
		putchar('\n');
	}

	// CLEANUP PHASE: Free all allocated memory
	// Free in reverse order of allocation (nested freeing)
	for (int b = 0; b < 2; b++)
	{
		// Free each row in the current buffer
		for (int i = 0; i < height + 2; i++)
			free(grid[b][i]);
		// Free the row pointers array
		free(grid[b]);
	}
	// Free the buffer pointers array
	free(grid);

	return (0);
}
