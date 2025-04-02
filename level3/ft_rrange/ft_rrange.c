#include <stdlib.h>

int	*ft_rrange(int start, int end)
{
	int	i;
	int	j;
	int	*array;
	int	len;

	j = 0;
	i = 0;
	array = NULL;
	if (start > end)
		len = start - end + 2;
	else
		len = end - start + 2;
	array = malloc(sizeof(int) * len);
	array[len] = '\0';
	len--;
	while (len > i)
	{
		if (start > end)
		{
			array[i] = start - j;
			j++;
		}
		else if (start < end)
		{
			array[i] = start + j;
			j++;
		}
		i++;
	}
	return (array);
}
#include <stdio.h>

int	*ft_rrange(int start, int end); // Function prototype

void	print_array(int *arr, int size)
{
	if (!arr)
	{
		printf("NULL\n");
		return ;
	}
	for (int i = 0; i < size; i++)
	{
		printf("%d ", arr[i]);
	}
	printf("\n");
}

int	main(void)
{
	int	*arr;
	int	size;
	int	num_tests;
	int	start;
	int	end;

	// Test cases
	int test_cases[][2] = {
		{1, 3},
		{-1, 2},
		{0, 0},
		{0, -3},
		{5, 5},
		{-5, -2},
		{10, 5},
	};
	num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
	for (int i = 0; i < num_tests; i++)
	{
		start = test_cases[i][0];
		end = test_cases[i][1];
		size = abs(end - start) + 1; // Size of the array
		arr = ft_rrange(start, end); // Call function
		printf("ft_rrange(%d, %d) -> ", start, end);
		print_array(arr, size);
		free(arr); // Avoid memory leaks
	}
	return (0);
}
