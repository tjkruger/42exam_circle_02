#include <stdlib.h>
#include <stdio.h>

int main(int ac, char **av)
{
    if (ac == 3)
    {
        int num1 = atoi(av[1]);
        int num2 = atoi(av[2]);
        int nenner;
        
        if(num1 > num2)
            nenner = num1;
        else if (num1 < num2)
            nenner = num2;
        else 
            printf("%d\n", num1);
        if (num1 == num2)
            printf("%d\n", num1);
        else 
            while(nenner >= 0)
            {
                if(num1 % nenner == 0 && num2 % nenner == 0)
                {
                    printf("%d\n", nenner);
                    break;
                }
                nenner--;

            }
    }
    else
        printf("\n");
}