#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int	isprime(int nb)
{
	long	temp;

	if (nb == 2)
		return (1);
	if (nb <= 1 || nb % 2 == 0)
		return (0);
	temp = 3;
	while (nb >= temp * temp)
	{
		if (nb % temp == 0)
			return (0);
		temp += 2;
	}
	return (1);
}

int	main(int argc, char **argv)
{
	int temp = 0;
	int count = 0;
	int sum = 0;
	if (argc == 2)
	{
		int nbr = atoi(argv[1]);
		if (nbr > 0)
		{
			temp = nbr;
			if (isprime(nbr))
			{
				while (temp > 0)
				{
					if(isprime(temp))
						sum += temp;
					temp--;
				}
			}
			else
			{
				printf("0\n");
				exit(0);
			}
			printf("%d\n", sum);
			exit(0);
		}
	}
	write(1, "0", 1);
	write (1, "\n", 1);
	exit(0);
}
