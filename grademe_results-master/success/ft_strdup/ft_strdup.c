#include <stdlib.h>

char    *ft_strdup(char *src)
{
	int len = 0;
	char *dup;
	int temp = 0;

	while (src[temp] != '\0')
	{
		temp++;
		len++;
	}
	dup = malloc((len + 1) * sizeof(char));
	temp = 0;
	while (src[temp])
	{
		dup[temp] = src[temp];
		temp++;
	}
	return (dup);
}
