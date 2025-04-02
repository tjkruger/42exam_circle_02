<<<<<<< HEAD
#include <unistd.h>

int main(int ac, char **av)
{
    if(ac == 2)
    {
        int i = 0;
        while(av[1][i] == ' ' || av[1][i] == '\t')
            i++;
        while(av[1][i] != '\0')
        {
            if (av[1][i] == ' ' || av[1][i] == '\t')
            {
                while (av[1][i] == ' ' || av[1][i] == '\t')
                    i++;
                if (av[1][i] != '\0')
                    write(1, " ", 1);
            }
            else
            {
                write(1, &av[1][i], 1);
                i++;
            }

        }
    }
    write(1, "\n", 1);
=======


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
>>>>>>> origin/main
}