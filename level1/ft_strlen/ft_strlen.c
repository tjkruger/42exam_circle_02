int	ft_strlen(char *str)
{
	int	counter;

	counter = 0;
	while (*str)
	{
		counter++;
		str++;
	}
	return (counter);
}

#include <stdio.h>

int	main(void)
{
	char str[] = "hello there";
	int erg;
	erg = ft_strlen(str);
	printf("%d\n", erg);
}