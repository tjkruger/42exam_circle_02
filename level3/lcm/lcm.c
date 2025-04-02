

unsigned int	lcm(unsigned int a, unsigned int b)
{
	unsigned int	temp;
	unsigned		temp2;
	unsigned		temp3;

	temp2 = a;
	temp3 = b;
	while (b != 0)
	{
		temp = a % b;
		a = b;
		b = temp;
	}
	temp = 0;
	temp = (temp2 * temp3) / a;
	return (temp);
}

#include <stdio.h>

int	main(void)
{
	unsigned int	num_tests;

	unsigned int a, b;
	// Test Cases
	int test_cases[][2] = {
		{15, 20}, // Expected: 60
		{7, 5},   // Expected: 35
		{21, 6},  // Expected: 42
		{8, 12},  // Expected: 24
		{1, 1},   // Expected: 1
		{0, 5},   // Edge case: 0 (LCM with 0 is usually undefined)
		{13, 13}  // Expected: 13 (same number => LCM is the number itself)
	};
	num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
	for (int i = 0; i < num_tests; i++)
	{
		a = test_cases[i][0];
		b = test_cases[i][1];
		printf("LCM of %d and %d is: %d\n", a, b, lcm(a, b));
	}
	return (0);
}
