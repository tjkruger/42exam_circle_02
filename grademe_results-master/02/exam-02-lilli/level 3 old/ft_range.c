/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_range.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/10 15:57:46 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/10 16:18:26 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>

int *ft_range(int start, int end)
{
	int size = 0;
	size = (abs(end - start) + 1);
	int *array;
	array = (int *)malloc(sizeof(int) * size);
	int i = 0;
	while (i < size)
	{
		if (start < end)
		{
			array[i] = start;
			printf("%i", array[i]);
			start++;
		}
		else
		{
			array[i] = start;
			printf("%i", array[i]);
			start--;
		}
		i++;
	}
	return (array);
}

int main(void)
{
	ft_range(-1, 7);
	return(0);
}