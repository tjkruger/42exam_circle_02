// Assignment name  : fizzbuzz
// Expected files   : fizzbuzz.c
// Allowed functions: write
// --------------------------------------------------------------------------------

// Write a program that prints the numbers from 1 to 100, each separated by a
// newline.

// If the number is a multiple of 3, it prints 'fizz' instead.

// If the number is a multiple of 5, it prints 'buzz' instead.

// If the number is both a multiple of 3 and a multiple of 5, it prints 'fizzbuzz' instead.

// Example:

// $>./fizzbuzz
// 1
// 2
// fizz
// 4
// buzz
// fizz
// 7
// 8
// fizz
// buzz
// 11
// fizz
// 13
// 14
// fizzbuzz
// [...]
// 97
// 98
// fizz
// buzz
// $>

#include <unistd.h>

void writenumber(int i)
{
	char str[10] = "0123456789";

	if (i > 9)
		writenumber(i / 10);
	write(1, &str[i % 10], 1); // 123 / 10 -> 12 / 10 -> 1 % 10 = 1 -> 12 % 10 = 2 -> 123 % 10 = 3
}

int main(void)
{
	int i = 1;
	while (i <= 100)
	{
		if (i % 3 == 0 && i % 5 == 0)
			write(1, "fizzbuzz", 8);
		else if (i % 3 == 0)
			write(1, "fizz", 4);
		else if (i % 5 == 0)
			write(1, "buzz", 4);
		else
			writenumber(i);
		i++;
		write(1, "\n", 1);
	}
}