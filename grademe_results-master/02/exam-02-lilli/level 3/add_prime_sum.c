/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   add_prime_sum.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 19:20:44 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 19:34:08 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int is_prime(int n)
{
	int i = 2;
	while(i * i <= n)
	{
		if (n % i == 0)
			return (0);
		i++;
	}
	return (1);
}
int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int num = atoi(argv[1]);
		int sum = 0;
		while(num >= 2)
		{
			if (is_prime(num) == 1)
				sum += num;
			num--;
		}
		printf("%i", sum);
	}
	write(1, "\n", 1);
	return (0);
}