#include <stdlib.h>


char	*ft_itoa(int nbr)
{
	int len = 0;
	int temp = nbr;
	char *s = NULL;
	while(temp > 0)
	{
		len++;
		temp /= 10;
	}
	if (nbr == -2147483648)
	{
		s = malloc(sizeof(char) * 12);
		s = "-2147483648\0";
		return(s);
	}
	if (nbr < 0)
		len++;

	s = malloc(sizeof(char) *(len + 1));
	s[len] = '\0';
	if (nbr == 0)
		s[0] = '0';
	while(nbr)
	{
		s[--len] = (nbr % 10) + '0';
		nbr /= 10;
	}
	return(s);

}

#include <stdio.h>

int main()
{
	int nbr = 0;
	printf("%s\n",ft_itoa(nbr));
}