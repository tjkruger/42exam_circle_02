/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_list.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 19:06:37 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 19:10:10 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

typedef struct    s_list
{
    struct s_list *next;
    void          *data;
}                 t_list;

#include <stdio.h>
t_list *sort_list(t_list *lst, int (*cmp)(int, int))
{
	t_list *start;
	int swap = 0;
	start = lst;
	if (lst != NULL && lst->next != NULL)
	{
		swap = lst->data;
		lst->data = lst->next->data;
		lst->next->data = swap;
		lst = start;
	}
	else
		lst = lst->next;
}