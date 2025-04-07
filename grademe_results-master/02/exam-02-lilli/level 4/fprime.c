/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fprime.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 18:14:25 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 18:21:04 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int num = atoi(argv[1]);
		if (num == 0)
			printf("0");
		else if (num > 0)
		{
			int i = 2;
			while(i <= num)
			{
				if (num % i == 0)
				{
					printf("%i", i);
					num = num / i;
					if (i == num)
						break;
					printf("*");
					i = 2;
				}
				else
					i++;
			}
		}
	}
	printf("\n");
	return (0);
}