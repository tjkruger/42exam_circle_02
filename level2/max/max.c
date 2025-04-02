// int	max(int *tab, unsigned int len);

// The first parameter is an array of int,
// 	the second is the number of elements in the array
// 		.

// 	The function returns the largest number found in the array.

// 	If the array is empty,
// 	the function returns 0.
// ```

int	max(int *tab, unsigned int len)
{
	int	i;
	int	max;

	i = 0;
	if (!tab || len == 0)
		return (0);
	max = tab[i];
	while (i < len)
	{
		if (tab[i] > max)
			max = tab[i];
		i++;
	}
	return (max);
}
#include <stdio.h>

int	main(void)
{
	int	tab[] = {0, 1, 2, 3, 4, 5, 4, 7, 8, 9};
	int	ma;

	ma = max(tab, 10);
	printf("%d\n", ma);
}
