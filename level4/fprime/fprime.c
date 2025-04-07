#include <stdio.h>
#include <stdlib.h>

int is_prime(int n)
{
	int i = 2;
	if (n <= 1) 
		return 0;
	while(i <= n / 2)
	{
		if(n % i == 0)
			return(0);
		i++;
	}
	return(1);
}


int	next_prime(int last_prime)
{
	last_prime++;
	while(!(is_prime(last_prime)))
	{
		last_prime++;
	}
	return(last_prime);
	
}


int	main(int ac, char **av)
{
	int n = atoi(av[1]);
	int current_prime = 2;
	while(n > 1)
	{
		if(n % current_prime == 0)
		{
			n /= current_prime;
			printf("%d", current_prime);
			if(n > 1)
				printf("*");
		}
		else
			current_prime = next_prime(current_prime);
	}
	printf("\n");
	

}