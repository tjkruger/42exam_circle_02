#include <stdio.h>
#include <stdlib.h>


int is_prime(int n)
{
	int i = 2;
	while(i <= n / 2)
	{
		if(n % i == 0)
			return(0);
		i++;
	}
	return(1);
}

int next_prime(int old)
{
	int new = old + 1;
	while(!is_prime(new))
		new++;
	return(new);
}



int main(int ac, char **av)
{
	if(ac == 2)
	{
		int num = atoi(av[1]);
		int prime = 2;
		int schalter;
		if(num == 1)
			printf("1");
		while(num >= prime)
		{
			schalter = 0;
			if(num % prime == 0)
			{
				num /= prime;
				printf("%d",prime);
				schalter = 1;
			}
			else
				prime = next_prime(prime);
			if(num > prime && schalter)
				printf("*");
		}
	}
	printf("\n");
}





/*
nummer 
nummer = nummer / prime 
print prime
solange nummer > prime 
	print *
wiederholen 


while()
{
	if(num % prime == 0)
		num /= prime;
		printf("%d",prime);
	else
		prime = next_prime;
	if(nummer > prime)
		printf("*");
}
*/