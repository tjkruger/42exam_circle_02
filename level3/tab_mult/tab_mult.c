#include <unistd.h>

int simple_atoi(char *str)
{
    int result = 0;
    while(*str >= '0' && *str <= '9')
    {
        result = result * 10 + (*str - '0');
        str++;
    }
    return(result);
}

void print_nbr(int num)
{
    char buf[12];
    int i = 11;
    buf[i--] = '\0';

    if (num == 0)
        buf[i--] = '\0';
    while(num > 0)
    {
        buf[i--] = (num % 10) + '0';
        num /= 10;
    }
    write(1, &buf[i + 1], sizeof(buf) - i - 2);
}

int main(int a, char **v)
{
    if(a == 2)
    {
        int num1 = 1;
        int num2 = simple_atoi(v[1]);
        int res;
        while(num1 < 10)
        {
            res = num1 * num2;
            print_nbr(num1);
            write(1, " x ", 3);
            print_nbr(num2);
            write(1, " = ", 3);
            print_nbr(res);
            write(1, "\n", 1);
            num1++;
        }
    }
    else
        write(1, "\n", 1);
}

