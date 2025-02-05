#include <unistd.h>

void writenumber(int i)
{
    char str[10] = "0123456789";
    if (i > 9)
        writenumber(i/10);
    write(1, &str[i % 10], 1);
}

int main()
{
    int i = 1;
    while(i <= 100)
    {
        if (i % 3 == 0 && i % 5 == 0)
            write(1, "FizzBuzz", 8);
        else if (i % 5 == 0)
            write(1, "Buzz", 4);
        else if (i % 3 == 0)
            write(1, "Fizz", 4);
        else
            writenumber(i);
        write(1, "\n", 1);
        i++;
    }
}