/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   max.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 16:54:03 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 17:08:24 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int max(int *tab, unsigned int len)
{
	int greatest = tab[0];
	unsigned int i = 1;
	if (len == 0)
		return (0);
	while(i < len)
	{
		if (tab[i] > greatest)
			greatest = tab[i];
		i++;;
	}
	return (greatest);
}
int main(void)
{
	int len = 2;
	int tab[] = {1, 4 ,5 ,3 ,7 };
	int greatest = max(tab, len);
	printf("%i\n", greatest);
	return (0);
}