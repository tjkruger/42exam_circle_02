

void sort_int_tab(int *tab, unsigned int size)
{
    int still_rotating = 1;
    int temp = 0;
    int counter = 0;
    int i = 0;
    while(still_rotating == 1)
    {
        still_rotating = 0;
        counter = 0;
        i = 0;
        while(size - 1 > counter)
        {
            if(tab[i] > tab[i + 1])
            {
                temp = tab[i];
                tab[i] = tab[i + 1];
                tab[i + 1] = temp;
                still_rotating = 1;
            }
            counter++;
            i++;
        }
    }
}

#include <stdio.h>


void print_array(int *tab, unsigned int size)
{
    for (unsigned int i = 0; i < size; i++)
    {
        printf("%d ", tab[i]);
    }
    printf("\n");
}

int main(void)
{
    int tab[] = {5};  // Example array
    unsigned int size = sizeof(tab) / sizeof(tab[0]);  // Calculate array size

    printf("Before sorting: ");
    print_array(tab, size);

    sort_int_tab(tab, size);  // Call your sorting function

    printf("After sorting: ");
    print_array(tab, size);

    return 0;
}

    