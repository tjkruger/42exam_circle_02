/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi_base_new.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 19:34:57 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 19:46:16 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int ft_atoi_base(const char *str, int str_base)
{
	int i = 0;
	int sign = 1;
	int value = 0;
	int res = 0;
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
		if (str[i] >= '0' && str[i] <= '9')
			value = str[i] - '0';
		else if (str[i] >= 'a' && str[i] <= 'f')
			value = str[i] - 'a' + 10;
		else if (str[i] >= 'A' && str[i] <= 'Z')
			value = str[i] - 'A' + 10;
		res = res * str_base + value;
		i++;
	}
	return(res * sign);
}
int main(int argc, char **argv)
{
	const char *str = "ff";
	int str_base = 16;
	int num = ft_atoi_base(str, str_base);
	printf("%i", num);
	return (0);
}