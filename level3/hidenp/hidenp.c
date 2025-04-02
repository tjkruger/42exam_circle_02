#include <unistd.h>

int	main(int ac, char **av)
{
	int		i;
	int		j;
	char	*str1;
	char	*str2;

	if (ac == 3)
	{
		i = 0;
		j = 0;
		str1 = &av[2][i];
		str2 = &av[1][j];
		while (str1[i] != '\0')
		{
			if (str1[i] == str2[j])
				j++;
			i++;
		}
		if (str2[j] == '\0')
			write(1, "1", 1);
		else
			write(1, "0", 1);
	}
	write(1, "\n", 1);
}
