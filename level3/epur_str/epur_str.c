

#include <unistd.h>

int	main(int ac, char **av)
{
	char *s = av[1];
	int i = 0;
	if (ac == 2)
	{
		while (s[i] == ' ' || s[i] == '\t')
			i++;
		while (s[i] != '\0')
		{
			if (s[i] == ' ' || s[i] == '\t')
			{
				while (s[i] == ' ' || s[i] == '\t')
					i++;
				if (s[i] != '\0')
					write(1, " ", 1);
			}
			else
			{
				write(1, &s[i], 1);
				i++;
			}
		}
	}
	write(1, "\n", 1);
}