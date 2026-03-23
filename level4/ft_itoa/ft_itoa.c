
#include <stdlib.h>

char *ft_itoa(int num)
{
    int i = 0;
    int test = num;
    int sign = 0;
    int len = 0;
    char *res = NULL;

    if(test < 0)
    {
        len = 1;
        sign = 1;
        num *= -1;
    }
    while(test)
    {
        test /= 10;
        len++;
    }
    res = malloc(sizeof(char) * (len + 1));
    res[len + 1] = '\0';
    

    if(num == 0)
    {
        res[0] = '0';
        return(res);
    }
    if(sign)
        res[0] = '-';
    while(num)
    {
        res[--len] = (num % 10) + '0';
        num /= 10;
    }
    
    return(res);
}


#include <stdio.h>
#include <stdlib.h>
#include <string.h>



int main(void)
{
    int tests[] = {0, 42, -42, 123456, -987654, 2147483647, -2147483648};
    int i = 0;
    while (i < sizeof(tests) / sizeof(tests[0]))
    {
        char *res = ft_itoa(tests[i]);
        printf("ft_itoa(%d) = \"%s\"\n", tests[i], res);
        free(res);
        i++;
    }
    return 0;
}