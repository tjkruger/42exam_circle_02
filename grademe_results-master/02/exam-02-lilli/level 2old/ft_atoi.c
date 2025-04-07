/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 14:03:12 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 14:08:57 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int ft_atoi(const char *str)
{
	int i = 0;
	int sign = 1;
	int result = 0;
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
		result = result * 10 + str[i] - '0';
		i++;
	}
	return (result * sign);
}
int main(void)
{
	char str[] = "-0";
	int num = ft_atoi(str);
	printf("%i\n", num);
	return (0);
}