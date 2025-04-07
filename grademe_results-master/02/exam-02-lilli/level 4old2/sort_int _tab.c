/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_int _tab.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 16:10:41 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 16:49:10 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

void sort_int_tab(int *tab, unsigned int size)
{
	unsigned int i = 0;
	int temp = 0;
	while (i < size - 1)
	{
		if (tab[i] > tab[i + 1])
		{
			temp = tab[i];
			tab[i] = tab[i + 1];
			tab[i + 1] = temp;
			i = 0;
		}
		else
			i++;
	}
}

#include <stdio.h>
int main(void)
{
	int tab[] = {1,3,2,5};
	unsigned int size = 3;
	sort_int_tab(tab, size);
	int i = 0;
	while(i < size)
	{
		printf("%i, ", tab[i]);
		i++;
	}
}