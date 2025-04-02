



void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)())
{
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

}