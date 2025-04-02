#include <unistd.h>

void	putchar(char c)
{
	write(1, &c, 1);
}

void	putstr(char *str)
{
	int	i;

	i = 0;
	while (str[i] != '\0')
	{
		putchar(str[i]);
		i++;
	}
}

void	putnbr(int n)
{
	if (n > 9)
		putnbr(n / 10);
	putchar(n % 10 + '0');
}

int	my_atoi(char *str)
{
	int	i;
	int	res;

	i = 0;
	res = 0;
	while (str[i] >= '0' && str[i] <= '9')
	{
		res = res * 10 + (str[i] - '0');
		i++;
	}
	return (res);
}

int	main(int ac, char **av)
{
	if (ac == 2)
	{
		int i = 1;
		// int num = my_atoi(av[1]);
		while (i < 10)
		{
			putnbr(i);
			write(1, " x ", 3);
			putstr(av[1]);
			write(1, " = ", 3);
			putnbr(i * my_atoi(av[1]));
			write(1, "\n", 1);
			i++;
		}
	}
	else
		write(1, "\n", 1);
}