#include <unistd.h>
#include <stdlib.h>

static char	ft_toupper(char c)
{
	if (c >= 'a' && c <= 'z')
		return (c - 32);
	return (c);
}

static char	ft_tolower(char c)
{
	if (c >= 'A' && c <= 'Z')
		return (c + 32);
	return (c);
}

void	rstr_capitalizer(char *str)
{
	int	temp;

	temp = 0;
	while (str[temp])
	{
		if (str[temp + 1] == '\0' || str[temp + 1] == ' ' || str[temp + 1] == '\n' || str[temp + 1] == '\t')
				str[temp] = ft_toupper(str[temp]);
		else if (str[temp] >= 'A' && str[temp] <= 'Z')
				str[temp] = ft_tolower(str[temp]);
		write (1, &str[temp], 1);
		temp++;
	}
}

int main(int argc, char **argv)
{
	int	temp;

	temp = 1;
	if (argc >= 2)
	{
		while (argv[temp])
		{
			rstr_capitalizer(argv[temp]);
			temp++;
			write(1, "\n", 1);
		}
	}
	else
		write(1, "\n", 1);
	return 0;
}
