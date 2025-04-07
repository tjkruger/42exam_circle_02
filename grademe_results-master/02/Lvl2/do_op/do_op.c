#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	if (argc == 4)
	{
		int first = atoi(argv[1]);
		int second = atoi(argv[3]);

		if (argv[2][0] == '+')
			printf("%d", first + second);
		else if (argv[2][0] == '-')
			printf("%d", first - second);
		else if (argv[2][0] == '*')
			printf("%d", first * second);
		else if (argv[2][0] == '/')
			printf("%d", first / second);
		else if (argv[2][0] == '%')
			printf("%d", first % second);
	}
	printf("\n");
}
