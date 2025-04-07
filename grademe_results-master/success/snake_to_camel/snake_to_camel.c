#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>

char	capital(char c)
{
	if (c >= 'a' && c <= 'z')
		return (c - 32);
	return (c);
}

void	snake_to_camel(char *str)
{
	int i;

	i = 0;
	while (str[i]) {
		if (str[i] == '_')
		{
			i++;
			char upper = capital(str[i]);
			write(1, &upper, 1);
		} else {
			write(1, &str[i], 1);
		}
		i++;
	}
}

int main(int argc, char **argv)
{
	if (argc == 2) {
		snake_to_camel(argv[1]);
	}
	write(1, "\n", 1);
	return 0;
}
