

int	    is_power_of_2(unsigned int n)
{
    while(n / 2 != 1)
    {
        if (n % 2 == 0)
            n /= 2;
        else
            return(0);
    }
    return(1);
}

#include <stdio.h>

int main()
{
    int num;
    unsigned int n;
    n = 126;
    num = is_power_of_2(n);
    printf("%d\n", num);
}