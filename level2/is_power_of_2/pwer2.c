int	is_power_of_2(unsigned int n)
{
	return (n > 0 && (n & (n - 1)) == 0);
}
#include <stdio.h>

int	main(void)
{
	unsigned int	x;
	int				y;

	x = 24;
	y = is_power_of_2(x);
	printf("%d\n", y);
}
