#include <stdlib.h>

char *ft_itoa(int nbr)
{
    int i = 0;
    int j = nbr;
    char temp;
    char *str = NULL;
    int sign = 0;
    int len;


    while(j)
    {
        len++;
        j /= 10;
    }
    j = 0;
    if (nbr < 0)
    {
        sign = 1;
        len++;
        nbr = nbr * -1;
    }
    
    str = malloc(sizeof(char) * len + 1);
    if (nbr == 0)
    {
        str[0] = '0';
        str[1] = '\0';
        return str;
    }
    while(nbr)
    {
        str[i] = (nbr % 10) + '0';
        nbr /= 10;
        i++;
    }
    if(sign)
    {
        str[i] = '-';
        i++;
    }
    str[i] = '\0';
    i--;
    while(j <= i)
    {
        temp = str[j];
        str[j] = str[i];
        str[i] = temp;
        j++;
        i--;
    }
    return(str);

}



#include <stdio.h>

char *ft_itoa(int nbr);

int main(void)
{
    int numbers[] = {0, 1, -1, 42, -42, 123456, -987654, 2147483647, -2147483648};
    int size = sizeof(numbers) / sizeof(numbers[0]);

    for (int i = 0; i < size; i++)
    {
        char *str = ft_itoa(numbers[i]);
        if (str)
        {
            printf("Number: %d -> String: %s\n", numbers[i], str);
            free(str); 
        }
        else
        {
            printf("Error converting number: %d\n", numbers[i]);
        }
    }
    return 0;
}

