#include <unistd.h>

void	ft_putstr(char *str)
{
	int temp = 0;
	while (str[temp] != '\0')
	{
		write (1, &str[temp], 1);
		temp++;
	}
}
