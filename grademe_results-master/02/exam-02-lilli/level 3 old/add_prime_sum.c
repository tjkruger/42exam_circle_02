/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   add_prime_sum.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/10 15:08:28 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/10 15:30:21 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void ft_putnbr(int num)
{
	if (num >= 10)
		ft_putnbr(num / 10);
	char digit = num % 10 + '0';
	write(1, &digit, 1);
}

int ft_atoi(char *str)
{
	int i = 0;
	int res = 0;
	int sign = 1;

	while(str[i] == ' ' || str[i] == '\t')
		i++;
	if (str[i] == '-' || str[i] == '+')
	{
		if (str[i] == '-')
			sign = -1;
		i++;
	}
	while(str[i])
	{
		res = res * 10 + str[i] - '0';
		i++;
	}
	return (res * sign);
}

int is_prime(int n)
{
	int i = 2;
	while (n >= i * i)
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
		int num = ft_atoi(argv[1]);
		if (num > 0)
		{
			int sum = 0;
			if (num == 1)
				ft_putnbr(1);
			else
			{
				while (num >= 2)
				{
					if (is_prime(num) == 1)
						sum += num;
					num--;
				}
				ft_putnbr(sum);
			}
		}
		else
			ft_putnbr(0);
	}
	else
		ft_putnbr(0);
	write(1, "\n", 1);
	return (0);
}