#include <unistd.h>

void putnbr(int n)
{
	if (n > 9)
		putnbr(n / 10);
	write (1, &"0123456789"[n % 10], 1);
}

int main(void)
{
	int temp = 1;
	while (temp <= 100)
	{
		if (temp % 5 == 0 && temp % 3 == 0)
			write (1, "fizzbuzz", 8);
		else if (temp % 5 == 0 && temp % 3 != 0)
			write (1, "buzz", 4);
		else if (temp % 5 != 0 && temp % 3 == 0)
			write (1, "fizz", 4);
		else
			putnbr(temp);
		temp++;
		write (1, "\n", 1);
	}
}
