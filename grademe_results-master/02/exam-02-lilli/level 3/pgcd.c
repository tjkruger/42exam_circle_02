/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pgcd.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 14:34:21 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 14:46:39 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 3)
	{
		int num1 = atoi(argv[1]);
		int num2 = atoi(argv[2]);
		if (num1 > 0 && num2 > 0)
		{
			int temp = 0;
			while(num2 != 0)
			{
				temp = num2;
				num2 = num1 % temp;
				num1 = temp;
			}
			printf("%i", num1);
		}
	}
	printf("\n");
	return (0);
}