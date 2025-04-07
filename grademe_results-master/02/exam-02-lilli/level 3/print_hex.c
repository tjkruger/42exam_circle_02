/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_hex.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 14:47:38 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 15:49:31 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int ft_atoi(char *str)
{
	int i = 0;
	int sign = 1;
	int res = 0;
	while(str[i] == ' ' || str[i] == '\t')
		i++;
	if (str[i] == '-' || str[i] == '+')
	{
		if(str[i] == '-')
			sign = '-';
		i++;
	}
	while (str[i])
	{
		res = res * 10 + str[i] - '0';
		i++;
	}
	return (sign * res);
}
void print_hexa(int num)
{
	int hexa = 0;
	char digit;
	if (num >= 16)
		print_hexa(num / 16);
	hexa = num % 16;
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
		if (num >= 0)
			print_hexa(num);
	}
	write(1, "\n", 1);
	return (0);
}