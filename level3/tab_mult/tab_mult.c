#include <unistd.h>

<<<<<<< HEAD
int simple_atoi(char *str)
{
    int result = 0;
    while(*str >= '0' && *str <= '9')
    {
        result = result * 10 + (*str - '0');
        str++;
    }
    return(result);
}

void print_nbr(int num)
{
    char buf[12];
    int i = 11;
    buf[i--] = '\0';

    if (num == 0)
        buf[i--] = '\0';
    while(num > 0)
    {
        buf[i--] = (num % 10) + '0';
        num /= 10;
    }
    write(1, &buf[i + 1], sizeof(buf) - i - 2);
}

int main(int a, char **v)
{
    if(a == 2)
    {
        int num1 = 1;
        int num2 = simple_atoi(v[1]);
        int res;
        while(num1 < 10)
        {
            res = num1 * num2;
            print_nbr(num1);
            write(1, " x ", 3);
            print_nbr(num2);
            write(1, " = ", 3);
            print_nbr(res);
            write(1, "\n", 1);
            num1++;
        }
    }
    else
        write(1, "\n", 1);
}

=======
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
>>>>>>> origin/main
