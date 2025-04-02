

#include <stdlib.h>

int     *ft_rrange(int start, int end)
{
    int *array;
    int counter;
    int i = 0;
    if (start < end)
        counter = end - start + 1;
    else if (start > end)
        counter = start - end + 1;
    
    array = malloc(sizeof(int) * counter);

    while(counter)
    {
        array[i] = end;
        if (start < end)
            end--;
        else
            end++;
        counter--;
        i++;
            
    }
    return array;
    
}