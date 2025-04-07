/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_rrange.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 19:46:49 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 19:53:42 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>

int *ft_rrange(int start, int end)
{
	int temp = 0;
	temp = start;
	start = end;
	end = temp;
	int length = 0;
	
	if (start < end)
		length = end - start;
	else
		length = start - end;
	int *array = (int *)malloc(sizeof (int) * length + 1);
	int i = 0;
	while (i <= length)
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
	int *array = ft_rrange(-1, -1);
	return (0);
}