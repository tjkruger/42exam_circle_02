

<<<<<<< HEAD
=======
#include "ft_list.h"
#include <stdlib.h>

>>>>>>> origin/main


void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)())
{
<<<<<<< HEAD
    t_list *node;
    t_list *prev;
    node = *begin_list;
    prev = *begin_list;

    int counter;

    while (node)
    {
        if (node->data == data_ref)
        {
            while(counter > 1)
                prev = prev->next;
            prev->next = node->next;
            counter--;
        }
        counter++;
        node = node->next;
    }

=======
	t_list *temp;
	t_list **node = begin_list;

	while(*node)
	{
		if((*cmp)((*node)->data, data_ref) == 0)
		{
			temp = (*node)->next;
			(*node)->next = (*node)->next->next;
			free(temp);
		}
		else
			node = (*node)->next;
	}
>>>>>>> origin/main
}