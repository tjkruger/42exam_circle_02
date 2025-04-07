/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_hex.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/10 17:27:45 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/10 17:38:53 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int ft_atoi(char *str)
{
	int i = 0;
	int sign = 1;
	int res = 0;
	while (str[i] == ' ' || str[i] == '\t')
		i++;
	if (str[i] == '-' || str[i] == '+')
	{
		if (str[i] == '-')
			sign = -1;
		i++;
	}
	while (str[i])
	{
		res = res * 10 + str[i] - '0';
		i++;
	}
	return (sign * res);
}

void put_hexa(int num)
{
	char digit;
	if (num >= 16)
		put_hexa(num / 16);
	int hexa = num % 16;
	if (hexa >= 0 && hexa <= 9)
		digit = hexa + '0';
	else if (hexa >= 10 && hexa <= 16)
		digit = hexa - 10 + 'a';
	write(1, &digit, 1);
}

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int num = ft_atoi(argv[1]);
		put_hexa(num);
	}
	write(1, "\n", 1);
	return (0);
}