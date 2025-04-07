/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fprime.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 10:56:21 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 11:02:05 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int num = atoi(argv[1]);
		if (num > 0)
		{
			if (num == 1)
				printf("1");
			int i = 2;
			while (i <= num)
			{
				if (num % i == 0)
				{
					printf("%i", i);
					if (num == i)
						break;
					num = num / i;
					i = 2;
					printf("*");
				}
				i++;
			}
		}
	}
	printf("\n");
	return (0);
}