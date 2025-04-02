#include <unistd.h>
#include <stdlib.h>

int	main(int ac, char **av)
{
	if (ac > 1)
	{
		int i = 0;
		int j = 0;
		int k = 0;
		int len;
		char *str = av[1];
		char *firstword = NULL;
		while(str[i] == ' ' || str[i] == '\t')
			i++;
		j = i;    			// j is now start of first word;
		while(str[i] != ' ' && str[i] !=  '\0')
			i++;
		len = i - j;
		firstword = malloc(sizeof(char) * len);
		firstword[len] = '\0';
		while(k < len)
		{
			firstword[k] = str[j];
			j++;				
			k++;
		}
		while(str[i] == ' ' || str[i] == '\t')
			i++;
		while(str[i] != '\0')
		{
			if(str[i] == ' ' || str[i] == '\t')
			{
				while(str[i] == ' ' || str[i] == '\t')
					i++;
				if(str[i] != '\0')
					write(1, " ", 1);
			}
			else
			{	
				write(1, &str[i], 1);
				i++;
			}
		}
		write(1, " ", 1);
		j = 0;
		while(firstword[j] != '\0')
		{
			write(1, &firstword[j], 1);
			j++;
		}

		free(firstword);
	}
	write(1, "\n", 1);
}