

#include <stdlib.h>
int     *ft_range(int start, int end)
{
    int *array;
    int i = 0;
    int counter = 1;
    if(start < end)
        counter = end - start;
    else if (start > end)
        counter = start - end;
    else
        counter = 1;
    array = malloc(sizeof(int) * counter);

    while (counter)
    {
        array[i] = start;
        if(start < end)
            start++;
        else
            start--;
        i++;        
    }
    return array;
}