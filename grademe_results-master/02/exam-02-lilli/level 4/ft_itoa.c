/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_itoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 18:22:24 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 18:39:09 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>


int num_len(int nbr)
{
	if (nbr < 0)
		nbr = -nbr;
	int count = 0;
	while(nbr > 0)
	{
		nbr = nbr / 10;
		count++;
	}
	return (count);
}

char *ft_itoa(int nbr)
{
	int sign = 0;
	if (nbr < 0)
	{
		sign = 1;
		nbr = -nbr;
	}
	else if (nbr == 0)
		printf("0");
	int length = num_len(nbr) + sign + 1;
	char *str = (char *)malloc(sizeof (char) * length);
	str[--length] = '\0';
	while(length > 0)
	{
		str[--length] = nbr % 10 + '0';
		nbr = nbr / 10;
		if (sign == 1 && length == 0)
			str[0] = '-';
	}
	return (str);
}

int main(void)
{
	int num = 0;
	char *str = ft_itoa(num);
	printf("%s\n", str);
	return (0);
}