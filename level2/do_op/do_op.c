#include <stdlib.h>
#include <stdio.h>

int main(int ac, char **av)
{
    if (ac == 4)
    {
        int num1 = atoi(av[1]);
        int num2 = atoi(av[3]);
        char op = av[2][0];
        
        if(op == '+')
        {
            printf("%d",num1 + num2);
        }
        if(op == '-')
        {
            printf("%d",num1 - num2);
        }
        if(op == '/')
        {
            printf("%d",num1 / num2);
        }
        if(op == '*')
        {
            printf("%d",num1 * num2);
        }
        if(op == '%')
        {
            printf("%d",num1 % num2);
        }
        printf("\n");
    }
    else 
    printf("\n");
}