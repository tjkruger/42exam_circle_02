#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

int ft_strlen(char *s)
{
    int i = 0;
    while(s[i] != '\0')
        i++;
    return(i);
}

int my_atoi(const char *s) 
{
    int result = 0;

    while (*s >= '0' && *s <= '9') {
        result = result * 10 + (*s - '0');
        s++;
    }

    return result;
}

void my_itoa(int n, char *s) 
{
    if (n >= 10)
        my_itoa(n / 10, s);

    while (*s) s++;           // go to end
    *s++ = (n % 10) + '0';
    *s = '\0';
}


char *make_map(char *str)
{
    char *map;
    int i = 0;
    int level = 0;
    map = malloc(sizeof(char) * (ft_strlen(str) + 1));

    while(str[i] != '\0')//in here must be a valid strin so error checking must happen earlier
    {
        if(str[i] == '(')
            level++;
        if(str[i] == ')')
            level--;
        map[i] = level + '0';
        i++;
    }
    map[i] = '\0';
    return(map);
}

int find_deepest_lvl(char *str)
{
    int deepest = 0;
    int i = 0;
    while(str[i] != '\0')
    {
        if(str[i] - '0' > deepest)
            deepest = str[i] - '0';
        i++;
    }
    return(deepest);
}

char *make_str_to_calc(int d,char *map, char *old)
{
    char *new;
    int i = 0;
    int j = 0;
    int len = 0;
    while(d != map[i])//iterate until i get to the level i need
        i++;
    while(d + '0' == map[i + len])
        len++;
    new = malloc(sizeof(char) * (len + 1));

    while(my_atoi(d + '0' == map[i + j]))//iterate as long as we are in the same level
    {
        new[j] = old[i + j];
        j++;
    }
    new[j] = '\0';
    return(new);
}

char *resize_str(char *str, int index, int res)
{
    char *new;

    return(new);
}

int calculate(char *str)
{
    int res = 0;
    int tmp;
    int i = 0;
    if(str[0] == '(')
        i++;
    while(str[i] != '\0' || str[i] != ')')
    {
        if(str[i] != '*' || str[i] != '+')
            tmp = my_atoi(str[i]);// i just boldly assume that i have done the error checking correctly and there is always a number after the first bracket
        if(str[i] == '*')
        {

        }

    }
    return(res);
}

char *make_new_original(char *old)
{
    char *to_calc;
    char *new;
    char *map;
    int deepest;
    int calculated;

    map = make_map(old);
    deepest = find_deepest_lvl(map);
    to_calc = make_str_to_calc(deepest, map, old);
    calculated = calculate(to_calc);



    free(to_calc);
    free(map);
    free(old);
    return(new);
}




int main (int ac, char **av)
{
    char *original;

    original = make_new_original(av[1])



    return(0);
}






// 10:49 PM
// build depth map shadow string
// find first depth-1 section
// evaluate what's inside
// replace (...) with result in new string, free old
// repeat until no brackets
// two-pass on flat string: * first, then +