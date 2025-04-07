#include <unistd.h>

int main(int ac, char **av)
{
	if (ac == 2)
	{
		int temp = 0;
		int count = 0;
		while (av[1][temp] != '\0')
		{
			if (av[1][temp] >= 'a' && av[1][temp] <= 'z')
			{
				count = 0;
				while (count < av[1][temp] - 96)
				{
					write (1, &av[1][temp], 1);
					count++;
				}
			}
			else if (av[1][temp] >= 'A' && av[1][temp] <= 'Z')
			{
				count = 0;
				while (count < av[1][temp] - 64)
				{
					write (1, &av[1][temp], 1);
					count++;
				}
			}
			else
				write (1, &av[1][temp], 1);
			temp++;
		}
	}
	write (1, "\n", 1);
	return (0);
}
