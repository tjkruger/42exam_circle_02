#include <unistd.h>


int is_not_in(char *str,int prevpos)
{
	int i = 0;
	while (i < prevpos)
	{
		if(str[i] == str[prevpos])
			return(0);
		i++;
	}
	return(1);

}

int main(int ac, char **av)
{
	if(ac == 3)
	{
		int i = 0;
		int j = 0;
		int k = 0;
		char * str1 = av[1];
		char * str2 = av[2];


		while(str1[i] != '\0')
		{
			j = 0;
			while(str2[j] != '\0')
			{
				if(str1[i] == str2[j])
				{
					if(is_not_in(str1, i))
						write(1, &str1[i], 1);
					break;
				}
				j++;
			}
			i++;
		}
		
	}
	write(1,"\n", 1);
}