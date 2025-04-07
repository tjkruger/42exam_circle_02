#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int temp = 0;
		while (argv[1][temp] == ' ' || argv[1][temp] == '\t')
			temp++;
		while (argv[1][temp] != ' ' && argv[1][temp] != '\t' && argv[1][temp] != '\0')
		{
			write(1, &argv[1][temp], 1);
			temp++;
		}
		while (argv[1][temp] != '\0')
		{
			if (argv[1][temp] == ' ' || argv[1][temp] == '\t')
				temp++;
			else
			{
				write(1, " ", 1);
				while (argv[1][temp] != ' ' && argv[1][temp] != '\t' && argv[1][temp] != '\0')
				{
					write(1, &argv[1][temp], 1);
					temp++;
				}
			}
		}
	}
	write (1, "\n", 1);
	return (0);
}
