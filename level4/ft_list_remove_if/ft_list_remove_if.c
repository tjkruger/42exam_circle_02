

#include "ft_list.h"
#include <stdlib.h>



void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)())
{
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
}