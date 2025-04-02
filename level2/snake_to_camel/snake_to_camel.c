#include <unistd.h>
#include <stdlib.h>


void snaketocamel(char *str)
{
	int i = 0;
	int j = 0;
	int counter = 0;
	char *copy = str;
	char *new;
	while(copy[i] != '\0')
	{
		if(copy[i] != '_')
			counter++;
		i++;
	}
	new = malloc(sizeof(char) * (i - counter + 1));
	i = 0;
	while(str[i] != '\0')
	{
		if(str[i] == '_')
		{
			i++;
			new[j] = str[i] - 32;
			i++;
			j++;
		}
		new[j] = str[i];
		i++;
		j++;
	}
	new[j] = '\0';
	i = 0;
	while(new[i] != '\0')
		{
			write(1, &new[i], 1);
			i++;
		}
	write(1, "\n", 1);

}

int main(int ac,char **av)
{
	if (ac == 2)
	{
		int i = 0;
		char *str;
		str = av[1];
		snaketocamel(str);
	}
	else
		write(1, "\n", 1);
	return(0);
}
