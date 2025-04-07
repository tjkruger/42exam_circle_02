#include <stdio.h>
#include <stdlib.h>

void fprime(int n)
{
	int i = 2;
	int first = 1;
	while (n > 1)
	{
		while (n % i == 0)
		{
			if(!first)
				printf("*");
			printf("%d", i);
			n /= i;
			first = 0;
		}
		i++;
	}
}
int main(int ac, char **av)
{
	if (ac == 2)
		fprime(atoi(av[1]));
	printf("\n");
	return (0);
}