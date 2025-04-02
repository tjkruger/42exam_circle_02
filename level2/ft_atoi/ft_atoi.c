

int	ft_atoi(const char *str)
{
	int res = 0;
	int i = 0;
	int sign = 0;

	while(str[i] == ' ' || str[i] == '\t' || str[i] == '\n' || str[i] == '\v' || str[i] == 'f' || str[i] == 'r')
		i++;

	if(str[i] == '-' || str[i] == '+')
	{
		if(str[i] == '-')
			sign = 1;
		i++;
	}
	
	while(str[i] != '\0')
	{
		res = res * 10 + (str[i] - '0'); 
		i++;
	}


	if(sign)
		res *= -1;

	return(res);
}

#include <stdio.h>
int main()
{
	char *str = "2147483648";
	int n = ft_atoi(str);
	printf("%d\n", n);
	return(0);
}