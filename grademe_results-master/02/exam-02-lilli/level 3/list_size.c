/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_size.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 14:04:36 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 14:06:50 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

typedef struct    s_list
{
    struct s_list *next;
    void          *data;
}                 t_list;

int ft_list_size(t_list *begin_list)
{
	int count = 0;
	if (begin_list == 0)
		return (0);
	while (begin_list)
	{
		begin_list = begin_list->next;
		count++;
	}
	return(count);
}