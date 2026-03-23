#include <unistd.h>
#include <stdlib.h>

int is_space(char c)
{
	if(c <= 32)
		return(1);
	return(0);
}


char	*firstword(char *str)
{
	int i = 0;
	char *fword = NULL;
	int start;
	while(is_space(str[i]) && str[i])
		i++;
	start = i;
	while(!is_space(str[i]) && str[i])
		i++;
	fword = malloc(sizeof(char) * (i - start + 1));
	fword[i - start] = '\0';
	i = 0;
	while(!is_space(str[start + i]) && str[start + i])
	{
		fword[i] = str[start + i];
		i++;
	}
	return(fword);
}



int	main(int ac, char **av)
{
	if (ac > 1)
	{
		char *str = av[1];
		char *fword = firstword(str);
		int i = 0;
		int printed = 0;
		while(is_space(str[i]) && str[i])
			i++;
		while(!is_space(str[i]) && str[i])
			i++;
		while(is_space(str[i]) && str[i])
			i++;
		while(str[i])
		{
			if(!is_space(str[i]))
				write(1, &str[i], 1);
			else
			{
				while(is_space(str[i]))
					i++;
				i--;
				write(1, " ", 1);
				
			}
			i++;
			printed = 1;
		}
		if(printed)
			write(1, " ", 1);
		int j = 0;
		while(fword[j])
		{
			write(1, &fword[j], 1);
			j++;
		}
		
		free(fword);
	}
	write(1, "\n", 1);
}