#include <unistd.h>
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


int	next_prime(int i)
{
	i++;
	while(!is_prime(i))
		i++;
	return(i);
}

int my_atoi(char *str)
{
	int n = 0;
	int i = 0;

	while (str[i] >= '0' && str[i] <= '9')
    {
        n = n * 10 + (str[i] - '0');
        i++;
    }
	return(n);
}

void putnbr(int n)
{
	char temp;
	while(n)
	{
		temp = (n % 10) + '0';
		write(1, &temp, 1);
		n /= 10;
	}
}

int	main(int ac, char **av)
{
	int nbr = my_atoi(av[1]);
	int prime = 1;
	int i = 0;
	putnbr(nbr);
	write(1, "\n", 1);
	while(i < 10)
	{
		prime = next_prime(prime);
		putnbr(prime);
		i++;
		write(1, "\n", 1);
	}

}