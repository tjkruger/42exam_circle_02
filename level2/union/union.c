#include <unistd.h>


int not_already_exists(char *str1, int counter1, char *str2, int counter2, char searchedfor)
{
	int i = 0;
	int j = 0;
	while(i < counter1)
	{
		if(str1[i] == searchedfor)
			return(0);
		i++;
	}
	while(j < counter2)
	{
		if(str2[j] == searchedfor)
			return(0);
		j++;
	}
	return(1);
}


int main(int ac, char **av)
{
	if(ac == 3)
	{
		int i = 0;
		int j = 0;
		char * str1 = av[1];
		char * str2 = av[2];
		while(str1[i] != '\0')
		{
			if(not_already_exists(str1, i, str2, j, str1[i]))
				write(1, &str1[i], 1);
			i++;
		}
		while(str2[j] != '\0')
		{
			if(not_already_exists(str1, i, str2, j, str2[j]))
				write(1, &str2[j], 1);
			j++;
		}

		
	}
	write(1,"\n", 1);
}