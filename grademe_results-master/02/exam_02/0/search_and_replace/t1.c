#include <unistd.h>

int main(int ac, char **av)
{
	if (ac == 4)
	{
		int temp = 0;
		char c = *av[2];
		char c2 = *av[3];
		while (av[1][temp] != '\0')
		{
			if (av[1][temp] == c)
				av[1][temp] = c2;
			write (1, &av[1][temp], 1);
			temp++;
		}
	}
	write (1, "\n", 1);
	return (0);
}