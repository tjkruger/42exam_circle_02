#include <unistd.h>

void print_number(int num)
{
    if(num > 9)
        print_number(num/10);
    char c = (num % 10) + '0';
    write(1, &c, 1);
}


int main(int ac, char **av)
{
    (void)av;
    print_number(ac - 1);
    write(1, "\n", 1);
}