/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_range.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 14:07:10 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 14:16:23 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int *ft_range(int start, int end)
{
	int length = 0;
	int i = 0;
	if (start < end)
		length = end - start + 1;
	else
		length = start - end + 1;
	int *array = (int *)malloc(sizeof (int) * length);
	while (i < length)
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
	int *array = ft_range(1,-1);
	return (0);
}
