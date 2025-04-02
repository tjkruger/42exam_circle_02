#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc == 2)
    {
        int i;
        int counter;
        i = 0;
        while(argv[1][i] != '\0')
        {
            counter = argv[1][i] - 'A' + 1;
            if (argv[1][i] >= 65 && argv[1][i] <= 90)
            {
                while (counter > 0)
                {
                    write(1, &argv[1][i], 1);
                    counter--;
                }
            }
            counter = argv[1][i] - 'a' + 1;
            if (argv[1][i] >= 97 && argv[1][i] <= 122)
            {
                while (counter > 0)
                {
                    write(1, &argv[1][i], 1);
                    counter--;
                }
            }
            else
                write (1, &argv[1][i], 1);
            i++;
        }
        write(1,"\n", 1);
    }
    else
        write(1,"\n", 1);
}