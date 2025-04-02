#include <unistd.h>

void rev_print(char *str)
{
    int i = 0;

    while(str[i] != 0)
        i++;
    while (i >= 0)
    {
        write(1, &str[i], 1);
        i--;
    }
    write(1, "\n", 1);
}

int main()
{
    char str[] = "hello there";

    rev_print(str);
}