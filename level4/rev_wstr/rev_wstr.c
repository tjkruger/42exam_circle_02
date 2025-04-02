#include <stdlib.h>
#include <unistd.h>

void	putstr(char *str)
{
	int	i;

	i = 0;
	while (str[i])
	{
		write(1, &str[i], 1);
		i++;
	}
}

int	main(int ac, char **av)
{
	int i = 0;
	int wordend = 0;
	int wordstart = 0;
	int j = 0;
	char *str = NULL;
	if (ac == 2)
	{
		while (av[1][i] != '\0') // end of the original string
			i++;
		while(i >= 0)
		{
			j = 0;
			wordend = i;
			while(i >= 0 && av[1][i] != ' ')
				i--;
			if (i == 0)
				wordstart = i;
			else
			{
				wordstart = i + 1;
			}
			str = malloc(sizeof(char) * (wordend - wordstart + 1));
			while(wordstart + j <= wordend)
			{
				str[j] = av[1][wordstart + j];
				j++; 
			}
			str[j] = '\0';
			putstr(str);
			free(str);
			i--;
			if (i >= 0)
				write(1, " ", 1);
		}

		
	
	}
	write(1, "\n", 1);
}




/*
count till eol

in loop

count backwards till word is cut out
print word 
adjust for space

*/