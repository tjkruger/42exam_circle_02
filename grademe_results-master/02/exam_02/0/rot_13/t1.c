#include <unistd.h>

int main(int ac, char **av)
{
	if (ac == 2)
	{
		int temp = 0;
		while (av[1][temp] != '\0')
		{
			if (av[1][temp] >= 'a' && av[1][temp] <= 'm' || av[1][temp] >= 'A' && av[1][temp] <= 'M')
				av[1][temp] += 13;
			else if (av[1][temp] >= 'n' && av[1][temp] <= 'z' || av[1][temp] >= 'N' && av[1][temp] <= 'Z')
				av[1][temp] -= 13;
			write (1, &av[1][temp], 1);
			temp++;
		}
	}
	write (1, "\n", 1);
	return (0);
}