<<<<<<< HEAD


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
=======
#include <stdlib.h>

int	*ft_range(int start, int end)
{
	int	*array;
	int	counter;
	int	i;

	counter = 1;
	i = 0;
	if (start < end)
		counter = end - start + 1;
	else
		counter = start - end + 1;
	array = malloc(sizeof(int) * counter);
	while (i < counter)
	{
		if (start < end)
			array[i] = start + i;
		else
			array[i] = start - i;
		i++;
	}
	return (array);
}
>>>>>>> origin/main
