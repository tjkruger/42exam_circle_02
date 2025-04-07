/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_itoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 11:03:04 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 11:25:22 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>

int num_len(int n)
{
	int length = 0;
	if (n == 0)
		return (1);
	while (n > 0)
	{
		n = n / 10;
		length ++;
	}
	return(length);
}

char *ft_itoa(int nbr)
{
	int sign = 0;
	if (nbr < 0)
	{
		sign = 1;
		nbr = -nbr;
	}
	int length = num_len(nbr) + sign + 1;
	char *str = (char *)malloc(sizeof (char) * length);
	if (!str)
		return (NULL);
	str[--length] = '\0';
	while(length > 0)
	{
		str[--length] = nbr % 10 + '0';
		nbr = nbr / 10;
		if (sign == 1 && length == 0)
			str[length] = '-';
	}
	return (str);
}

int main(void)
{
	int num = -123;
	char *str = ft_itoa(num);
	printf("%s\n", str);
	return (0);
}