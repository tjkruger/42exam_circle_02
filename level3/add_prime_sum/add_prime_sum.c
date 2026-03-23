// Assignment name  : add_prime_sum
// Expected files   : add_prime_sum.c
// Allowed functions: write, exit
// --------------------------------------------------------------------------------

// Write a program that takes a positive integer as argument and displays the sum
// of all prime numbers inferior or equal to it followed by a newline.

// If the number of arguments is not 1, or the argument is not a positive number,
// just display 0 followed by a newline.

// Yes, the examples are right.

// Examples:

// $>./add_prime_sum 5
// 10
// $>./add_prime_sum 7 | cat -e
// 17$
// $>./add_prime_sum | cat -e
// 0$
// $>

#include <unistd.h>

int my_atoi(char *str)
{
    char *s = str;
    int i = 0;
    int res = 0;
    while(s[i] != '\0')
    {
        if(s[i] < '0' || s[i] > '9')
            return(0);
        i++;
    }
    i = 0;
    while(str[i] != '\0')
    {
        res = res * 10 + str[i] - '0';
        i++;
    }
    return(res);
}

void    putnbr(int num)
{
    char c;
    if(num > 9)
        putnbr(num / 10);
    c = num % 10 + '0';
    write(1, &c, 1);
}

int is_prime(int num)
{
    int i = 2;
    while(i <= num / 2)
    {
        if(num % i == 0)
            return(0);
        i++;
    }
    return(1);
}

int main(int ac, char **av)
{
    if(ac == 2)
    {
        int num = my_atoi(av[1]);
        int i = 2;
        int res = 0;
        while(i <= num)
        {
            if (is_prime(i))
                res = res + i;
            i++;
        }
        putnbr(res);
        write(1, "\n", 1);
        return(0);
    }
    write(1, "0\n", 2);
    return(0);
}